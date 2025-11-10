import 'dart:async';
import 'dart:io';
import 'package:ashil_school/Utils/custom_dilog/confert_dilog.dart';
import 'package:ashil_school/Utils/custom_dilog/custom_dialog.dart';
import 'package:ashil_school/Utils/helpers/loaders/loaders.dart';
import 'package:ashil_school/features/lesson/models/content_block.dart';
import 'package:ashil_school/features/lesson/models/lesson.dart';
import 'package:ashil_school/features/lesson/models/position_data.dart';
import 'package:ashil_school/features/lesson/view/dialogs/add_edit_text_dialog.dart';
import 'package:ashil_school/features/lesson/view/dialogs/details_lesson.dart';
import 'package:ashil_school/features/lesson/view/lesson_details_page.dart';
import 'package:ashil_school/features/subject/controllers/subject_details_controller.dart';
import 'package:ashil_school/features/unit/models/unit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rxdart/rxdart.dart' as rxdart;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:record/record.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

// حالات التسجيل
enum RecordingState { stopped, recording, paused }

class AddEditLessonController extends GetxController {
  final SubjectDetailsController subjectController;
  final LessonModel? lessonToEdit;

  late bool isEditing;
  final uuid = const Uuid();

  // مفاتيح ونماذج التفاصيل
  final detailFormKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final orderController = TextEditingController();
  final profileImage = RxnString();
  final selectedUnit = Rxn<UnitModel>();
  // عند التعريفات
  final titleRx = ''.obs;
  final orderRx = ''.obs;

  final detailAutovalidateMode = AutovalidateMode.disabled.obs;

  // عرض/إخفاء حوار التفاصيل
  final detailsDialogOpen = false.obs;

  // المحتوى
  final contentBlocks = <ContentBlock>[].obs;

  // --------------------------------
  // الصوت [تم التعديل]
  // --------------------------------
  final audioPath = RxnString(); // المسار النهائي المحفوظ (للدرس)
  final recordingState = Rx<RecordingState>(RecordingState.stopped);
  final isPlaying = false.obs;

  StreamSubscription<Amplitude>? _amplitudeSubscription;
  final recordingAmplitudes = <double>[].obs;

  StreamSubscription? _playerStateSubscription;
  StreamSubscription? _playingSubscription;

  final audioRecorder = AudioRecorder();
  final audioPlayer = AudioPlayer();
  final isSaving = false.obs;

  // عدّاد مدة التسجيل
  Timer? _recTimer;
  final recordingElapsed = Duration.zero.obs;
  final recordingElapsedStr = '0:00'.obs;

  // [جديد] مسارات إدارة الجلسة (بدلاً من _segments)
  String? _mergedPreviewPath; // المسار المدمج التراكمي (للمعاينة)
  String? _currentSegmentPath; // المسار الجاري تسجيله حالياً

  // إعدادات WAV (ضروري للدمج)
  static const int _wavSampleRate = 44100;
  static const int _wavChannels = 1; // Mono
  static const int _wavBitsPerSample = 16;
  // --------------------------------
  // نهاية تعديلات الصوت
  // --------------------------------

  // تمرير وربط عناصر المحتوى
  final contentScrollController = ScrollController();
  final Map<String, GlobalObjectKey> contentItemKeys = {};
  GlobalObjectKey getScrollKey(String id) =>
      contentItemKeys.putIfAbsent(id, () => GlobalObjectKey(id));

  AddEditLessonController({
    required this.subjectController,
    this.lessonToEdit,
  });

  @override
  void onInit() {
    super.onInit();
    isEditing = lessonToEdit != null;

    if (isEditing) {
      final lesson = lessonToEdit!;
      titleController.text = lesson.title;
      orderController.text = lesson.order?.toString() ?? '0';
      profileImage.value = lesson.profileImageUrl;
      audioPath.value = lesson.audioUrl;

      for (var block in lesson.contentBlocks) {
        contentItemKeys[block.id] = GlobalObjectKey(block.id);
      }
      contentBlocks.assignAll(lesson.contentBlocks);

      selectedUnit.value = subjectController.units
          .firstWhereOrNull((u) => u.id == lesson.unitId);
    } else {
      selectedUnit.value = subjectController.filterUnits.isNotEmpty
          ? subjectController.filterUnits.first
          : subjectController.units.firstOrNull;

      final nextOrder = ((subjectController
                  .getControllerForUnit(selectedUnit.value?.id ?? '')
                  ?.lessons
                  .length) ??
              0) +
          1;
      orderController.text = nextOrder.toString();
    }
    // ✅ اربط Rx بالنصوص
    titleRx.value = titleController.text;
    orderRx.value = orderController.text;

    titleController.addListener(() {
      titleRx.value = titleController.text;
    });
    orderController.addListener(() {
      orderRx.value = orderController.text;
    });
    // [معدّل] ربط مستمعات المشغل
    _playerStateSubscription = audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        audioPlayer.seek(Duration.zero);
        audioPlayer.pause();
      }
    });
    _playingSubscription = audioPlayer.playingStream.listen((playing) {
      isPlaying.value = playing;
    });
  }

  @override
  void onClose() {
    _amplitudeSubscription?.cancel();
    _recTimer?.cancel();
    _playerStateSubscription?.cancel();
    _playingSubscription?.cancel();

    titleController.dispose();
    orderController.dispose();
    audioRecorder.dispose();
    audioPlayer.dispose();
    contentScrollController.dispose();

    // [جديد] تنظيف أي ملفات مؤقتة متبقية عند الإغلاق
    _cleanSessionFiles(deleteFinalPath: false);
    super.onClose();
  }

  // فتح حوار التفاصيل تلقائياً
  void openDetailsOnEnter(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDetailsDialog(context);
    });
  }

  // [معدّل]
  bool get hasAnyAudio =>
      (audioPath.value != null) || (_mergedPreviewPath != null);

  // إظهار الـDialog

  // صورة البروفايل
  void pickProfileImage() async {
    try {
      final XFile? file =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (file != null) {
        profileImage.value = file.path;
      }
    } catch (e) {
      KLoaders.error(title: "خطأ", message: "لم نتمكن من اختيار الصورة: $e");
    }
  }

  // الرجوع إلى تفاصيل (لم تعد صفحة، بل حوار)
  void goToDetailsPage() {
    showDetailsDialog(Get.context!);
  }

  /// لإظهار حوار التفاصيل
  void showDetailsDialog(BuildContext context, {bool forceValidate = false}) {
    if (forceValidate) detailAutovalidateMode.value = AutovalidateMode.always;
    if (detailsDialogOpen.value) return;
    detailsDialogOpen.value = true;

    showDialog(
      context: context,
      barrierDismissible: true, // يمكن غلقه بدون حفظ
      builder: (_) => CustomDialog(
        title: isEditing ? 'تعديل تفاصيل الدرس' : 'إضافة تفاصيل الدرس',
        body: DetailsFormBody(controller: this),
      ),
    ).then((_) {
      detailsDialogOpen.value = false;
    });
  }

  // تمرير إلى كتلة
  void scrollToContentBlock(String id) {
    final key = contentItemKeys[id];
    if (key == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = key.currentContext;
      if (ctx != null) {
        Scrollable.ensureVisible(
          ctx,
          duration: const Duration(milliseconds: 450),
          curve: Curves.easeInOut,
          alignment: 0.08,
        );
      }
    });
  }

  // إضافة محتوى
  void showAddContentDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.text_fields),
              title: const Text("إضافة نص"),
              onTap: () {
                Get.back();
                _addTextContentDialog(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text("صورة من المعرض"),
              onTap: () {
                Get.back();
                _pickImageContent(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("صورة من الكاميرا"),
              onTap: () {
                Get.back();
                _pickImageContent(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _addTextContentDialog(BuildContext context,
      [ContentBlock? toEdit]) async {
    // 1. استدعاء الحوار الجديد وانتظار النتيجة
    // النتيجة ستكون `String` (النص) أو `null` (إذا ضغط إلغاء)
    final String? newText = await Get.dialog<String>(
      AddEditTextDialog(toEdit: toEdit),
    );

    // 2. التحقق إذا قام المستخدم بالحفظ (newText != null)
    // وأن النص غير فارغ (تم التحقق منه داخل الحوار ولكن نتحقق هنا أيضاً)
    if (newText != null && newText.isNotEmpty) {
      // 3. تطبيق نفس المنطق القديم (الإضافة أو التعديل)
      if (toEdit != null) {
        // ----- منطق التعديل -----
        final index = contentBlocks.indexWhere((b) => b.id == toEdit.id);
        if (index != -1) {
          contentBlocks[index] = ContentBlock(
            id: toEdit.id,
            type: ContentType.text,
            data: newText, // استخدام النص الجديد من الحوار
            order: toEdit.order,
          );
        }
      } else {
        // ----- منطق الإضافة -----
        final newBlock = ContentBlock(
          id: uuid.v4(),
          type: ContentType.text,
          data: newText, // استخدام النص الجديد من الحوار
          order: contentBlocks.length,
        );
        contentBlocks.add(newBlock);
        contentItemKeys[newBlock.id] = GlobalObjectKey(newBlock.id);
      }
    }
  }

  // صور متعددة من المعرض، وصورة واحدة من الكاميرا
  void _pickImageContent(ImageSource source) async {
    try {
      if (source == ImageSource.gallery) {
        final List<XFile> files = await ImagePicker().pickMultiImage();
        if (files.isNotEmpty) {
          for (final file in files) {
            final newBlock = ContentBlock(
              id: uuid.v4(),
              type: ContentType.image,
              data: file.path,
              order: contentBlocks.length,
            );
            contentBlocks.add(newBlock);
            contentItemKeys[newBlock.id] = GlobalObjectKey(newBlock.id);
          }
        }
      } else {
        final XFile? file = await ImagePicker().pickImage(source: source);
        if (file != null) {
          final newBlock = ContentBlock(
            id: uuid.v4(),
            type: ContentType.image,
            data: file.path,
            order: contentBlocks.length,
          );
          contentBlocks.add(newBlock);
          contentItemKeys[newBlock.id] = GlobalObjectKey(newBlock.id);
        }
      }
    } catch (e) {
      KLoaders.error(title: "خطأ", message: "لم نتمكن من اختيار الصورة: $e");
    }
  }

  // تعديل كتلة
  void editContentBlock(BuildContext context, ContentBlock block) {
    if (block.type == ContentType.text) {
      _addTextContentDialog(context, block);
    } else {
      showModalBottomSheet(
        context: context,
        builder: (ctx) => SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text("تغيير (المعرض)"),
                onTap: () async {
                  Get.back();
                  try {
                    final XFile? file = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);
                    if (file != null) {
                      final index =
                          contentBlocks.indexWhere((b) => b.id == block.id);
                      if (index != -1) {
                        contentBlocks[index] = ContentBlock(
                          id: block.id,
                          type: ContentType.image,
                          data: file.path,
                          order: block.order,
                        );
                      }
                    }
                  } catch (e) {
                    KLoaders.error(
                        title: "خطأ", message: "لم نتمكن من اختيار الصورة: $e");
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("تغيير (الكاميرا)"),
                onTap: () async {
                  Get.back();
                  try {
                    final XFile? file = await ImagePicker()
                        .pickImage(source: ImageSource.camera);
                    if (file != null) {
                      final index =
                          contentBlocks.indexWhere((b) => b.id == block.id);
                      if (index != -1) {
                        contentBlocks[index] = ContentBlock(
                          id: block.id,
                          type: ContentType.image,
                          data: file.path,
                          order: block.order,
                        );
                      }
                    }
                  } catch (e) {
                    KLoaders.error(
                        title: "خطأ", message: "لم نتمكن من اختيار الصورة: $e");
                  }
                },
              ),
            ],
          ),
        ),
      );
    }
  }

  // تأكيد الحذف
  void confirmRemoveContentBlock(BuildContext context, String id) {
    showConfirmationDialog(
        onCancel: () => Get.back(),
        isDestructive: true,
        title: "حذف المحتوى",
        message: "هل أنت متأكد أنك تريد حذف هذا المحتوى؟",
        onConfirm: () {
          removeContentBlock(id);
          Get.back();
        });
  }

  // حذف كتلة
  void removeContentBlock(String id) {
    contentBlocks.removeWhere((b) => b.id == id);
    contentItemKeys.remove(id);
    _reorderBlocks();
  }

  // إعادة ترتيب
  void onReorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;
    final item = contentBlocks.removeAt(oldIndex);
    contentBlocks.insert(newIndex, item);
    _reorderBlocks();
  }

  void _reorderBlocks() {
    for (int i = 0; i < contentBlocks.length; i++) {
      final block = contentBlocks[i];
      if (block.order != i) {
        contentBlocks[i] = ContentBlock(
          id: block.id,
          type: block.type,
          data: block.data,
          order: i,
        );
      }
    }
  }

  // --------------------------------
  // الصوت [تمت إعادة البناء بالكامل]
  // --------------------------------

  /// [جديد] دالة مساعدة للحصول على مسار ملف جديد
  Future<String> _getNewAudioPath([String prefix = 'seg']) async {
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/$prefix${uuid.v4()}.wav';
  }

  /// [جديد] دالة مساعدة لتنظيف ملفات الجلسة المؤقتة
  Future<void> _cleanSessionFiles({bool deleteFinalPath = false}) async {
    // حذف المسار المدمج المؤقت
    try {
      if (_mergedPreviewPath != null &&
          await File(_mergedPreviewPath!).exists()) {
        await File(_mergedPreviewPath!).delete();
      }
    } catch (_) {}
    _mergedPreviewPath = null;

    // حذف المقطع الجاري تسجيله (إذا كان موجوداً وتالفاً)
    try {
      if (_currentSegmentPath != null &&
          await File(_currentSegmentPath!).exists()) {
        await File(_currentSegmentPath!).delete();
      }
    } catch (_) {}
    _currentSegmentPath = null;

    // حذف المسار النهائي (فقط عند بدء تسجيل جديد أو الحذف)
    if (deleteFinalPath) {
      try {
        final p = audioPath.value;
        if (p != null && await File(p).exists()) {
          await File(p).delete();
        }
      } catch (_) {}
      audioPath.value = null;
    }
  }

  /// [جديد] دالة الدمج الفوري
  Future<void> _mergeCurrentSession(String newSegmentPath) async {
    final previousMergedPath = _mergedPreviewPath;

    // الحالة 1: هذا هو المقطع الأول في الجلسة
    if (previousMergedPath == null) {
      _mergedPreviewPath = newSegmentPath;
      return;
    }

    // الحالة 2: دمج المقطع الجديد مع المقطع المدمج السابق
    final newMergedOutputPath = await _getNewAudioPath('_merged_');
    try {
      await _mergeWavSegments(
        [previousMergedPath, newSegmentPath],
        newMergedOutputPath,
      );

      // تحديث المسار الرئيسي
      _mergedPreviewPath = newMergedOutputPath;

      // تنظيف الملفات القديمة (المدمج السابق والمقطع الجديد)
      try {
        File(previousMergedPath).delete();
        File(newSegmentPath).delete();
      } catch (_) {}
    } catch (e) {
      KLoaders.error(title: "خطأ دمج", message: "فشل دمج المقطع الصوتي: $e");
      // في حالة الفشل، احتفظ بالقديم وحاول تجاهل الجديد (أو العكس)
      // لتبسيط، سنحتفظ بالقديم فقط
      try {
        File(newSegmentPath).delete();
      } catch (_) {}
    }
  }

  /// [جديد] تهيئة المشغل للمعاينة
  Future<void> _setupAudioPlayerForPreview() async {
    String? pathToLoad;
    if (recordingState.value == RecordingState.stopped) {
      pathToLoad = audioPath.value; // المسار النهائي
    } else {
      pathToLoad = _mergedPreviewPath; // المسار المدمج المؤقت
    }

    if (pathToLoad != null) {
      try {
        await audioPlayer.setFilePath(pathToLoad);
        await audioPlayer.setLoopMode(LoopMode.off);
        await audioPlayer.stop(); // أعده للبداية
      } catch (e) {
        KLoaders.error(title: "خطأ", message: "فشل تحميل ملف المعاينة: $e");
      }
    } else {
      // لا يوجد مسار، أعد المشغل لوضع الخمول
      try {
        await audioPlayer.stop();
        await audioPlayer
            .setAudioSource(ConcatenatingAudioSource(children: []));
      } catch (_) {}
    }
  }

  // دمج بيانات المشغل
  Stream<PositionData> get positionDataStream {
    return rxdart.Rx.combineLatest3<Duration, Duration, Duration?,
        PositionData>(
      audioPlayer.positionStream,
      audioPlayer.bufferedPositionStream,
      audioPlayer.durationStream,
      (position, bufferedPosition, duration) =>
          PositionData(position, bufferedPosition, duration ?? Duration.zero),
    );
  }

  // مؤقت مدة التسجيل
  void _startElapsed() {
    _recTimer?.cancel();
    _recTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      recordingElapsed.value += const Duration(seconds: 1);
      final m = recordingElapsed.value.inMinutes.remainder(60);
      final s = recordingElapsed.value.inSeconds
          .remainder(60)
          .toString()
          .padLeft(2, '0');
      recordingElapsedStr.value = '$m:$s';
    });
  }

  void _pauseElapsed() {
    _recTimer?.cancel();
  }

  void _stopElapsed() {
    _recTimer?.cancel();
    _recTimer = null;
    recordingElapsed.value = Duration.zero;
    recordingElapsedStr.value = '0:00';
  }

  Future<void> startRecording() async {
    try {
      if (await audioRecorder.hasPermission()) {
        // هذه جلسة تسجيل جديدة، احذف كل شيء سابق
        await _cleanSessionFiles(deleteFinalPath: true);
        await _setupAudioPlayerForPreview(); // إيقاف وإلغاء تحميل المشغل

        // ابدأ المقطع الأول
        final path = await _getNewAudioPath();
        await audioRecorder.start(
          RecordConfig(
            encoder: AudioEncoder.wav,
            sampleRate: _wavSampleRate,
            numChannels: _wavChannels,
          ),
          path: path,
        );

        _currentSegmentPath = path;
        recordingState.value = RecordingState.recording;

        // مرئيات
        recordingAmplitudes.clear();
        _amplitudeSubscription?.cancel();
        _amplitudeSubscription = audioRecorder
            .onAmplitudeChanged(const Duration(milliseconds: 100))
            .listen((amp) {
          double normalized = (amp.current + 30) / 30;
          recordingAmplitudes.add(normalized.clamp(0.0, 1.0));
        });

        // عدّاد
        recordingElapsed.value = Duration.zero;
        recordingElapsedStr.value = '0:00';
        _startElapsed();

        if (isPlaying.value) {
          await audioPlayer.stop();
        }
      }
    } catch (e) {
      KLoaders.error(title: "خطأ", message: "فشل بدء التسجيل: $e");
    }
  }

  Future<void> pauseRecording() async {
    if (recordingState.value != RecordingState.recording) return;

    try {
      // نغلق الملف فعليًا
      final segmentPath = await audioRecorder.stop();
      _currentSegmentPath = null;
      _pauseElapsed();
      _amplitudeSubscription?.cancel();

      if (segmentPath != null) {
        // [المنطق الجديد] ادمج المقطع فوراً
        await _mergeCurrentSession(segmentPath);
        // جهز المشغل للمعاينة بالملف المدمج
        await _setupAudioPlayerForPreview();
      }

      recordingState.value = RecordingState.paused;
    } catch (e) {
      KLoaders.error(title: "خطأ", message: "فشل الإيقاف المؤقت: $e");
    }
  }

  Future<void> resumeRecording() async {
    if (recordingState.value != RecordingState.paused) return;

    try {
      // تأكد من إيقاف المعاينة قبل الاستئناف
      if (audioPlayer.playing) {
        await audioPlayer.stop();
      }

      // افتح ملف WAV جديد
      final path = await _getNewAudioPath();
      await audioRecorder.start(
        RecordConfig(
          encoder: AudioEncoder.wav,
          sampleRate: _wavSampleRate,
          numChannels: _wavChannels,
        ),
        path: path,
      );

      _currentSegmentPath = path;
      recordingState.value = RecordingState.recording;

      // أعد تشغيل المرئيات والمؤقت
      _amplitudeSubscription?.cancel();
      _amplitudeSubscription = audioRecorder
          .onAmplitudeChanged(const Duration(milliseconds: 100))
          .listen((amp) {
        double normalized = (amp.current + 30) / 30;
        recordingAmplitudes.add(normalized.clamp(0.0, 1.0));
      });
      _startElapsed();
    } catch (e) {
      KLoaders.error(title: "خطأ", message: "فشل الاستئناف: $e");
    }
  }

  Future<String?> stopRecording() async {
    if (recordingState.value == RecordingState.stopped) return audioPath.value;

    try {
      _amplitudeSubscription?.cancel();
      _stopElapsed();

      // 1) إذا كنا نسجّل الآن، أغلق المقطع الجاري
      if (recordingState.value == RecordingState.recording) {
        final lastSegment = await audioRecorder.stop();
        _currentSegmentPath = null;
        if (lastSegment != null) {
          // ادمج المقطع الأخير
          await _mergeCurrentSession(lastSegment);
        }
      } else {
        // إذا كانت الحالة Paused، تأكد أن المسجل متوقف بالفعل
        await audioRecorder.stop();
      }

      // 2) الآن، المسار المدمج المؤقت هو النهائي
      audioPath.value = _mergedPreviewPath;
      _mergedPreviewPath = null; // أفرغ مسار الجلسة
      _currentSegmentPath = null; // (احتياطي)

      recordingState.value = RecordingState.stopped;

      // 3) جهز المشغل بالملف النهائي
      await _setupAudioPlayerForPreview();

      return audioPath.value;
    } catch (e) {
      recordingState.value = RecordingState.stopped;
      _stopElapsed();
      KLoaders.error(title: "خطأ", message: "فشل إيقاف/دمج التسجيل: $e");
      return null;
    }
  }

  Future<void> deleteAudio() async {
    if (recordingState.value != RecordingState.stopped) {
      await stopRecording(); // يُغلق أي ملف جارٍ وينقله إلى audioPath
    }

    // أوقف المشغل وأفرغ مصدره
    if (isPlaying.value ||
        audioPlayer.processingState != ProcessingState.idle) {
      await audioPlayer.stop();
      try {
        await audioPlayer
            .setAudioSource(ConcatenatingAudioSource(children: []));
      } catch (e) {
        // تجاهل الخطأ
      }
    }

    // احذف كل الملفات (النهائي والمؤقتات)
    await _cleanSessionFiles(deleteFinalPath: true);

    _stopElapsed();
  }

  /// [معدّل] تشغيل/إيقاف المعاينة (أبسط الآن)
  Future<void> toggleAudioPlayback() async {
    // 1. إذا كان المشغل يعمل، أوقفه
    if (audioPlayer.playing) {
      await audioPlayer.pause();
      return;
    }

    // 2. حدد المسار الذي يجب تشغيله
    String? pathToplay;
    if (recordingState.value == RecordingState.stopped) {
      pathToplay = audioPath.value; // المسار النهائي
    } else if (recordingState.value == RecordingState.paused) {
      pathToplay = _mergedPreviewPath; // المسار المدمج المؤقت
    }

    // 3. إذا لم يوجد مسار، لا تفعل شيئاً
    if (pathToplay == null) return;

    try {
      // 4. تحقق إذا كان المشغل جاهزاً وفي وضع "متوقف مؤقتاً"
      // (أي: ليس في البداية)
      if (audioPlayer.processingState == ProcessingState.ready &&
          audioPlayer.position > Duration.zero) {
        // استأنف التشغيل
        await audioPlayer.play();
      } else {
        // 5. قم بتحميل الملف من البداية
        // (نستخدم _setupAudioPlayerForPreview لضمان تحميل المسار الصحيح)
        await _setupAudioPlayerForPreview();
        await audioPlayer.play();
      }
    } catch (e) {
      KLoaders.error(title: "خطأ", message: "فشل تشغيل الصوت: $e");
    }
  }

  // حفظ الدرس
  Future<void> saveLesson() async {
    // [FIX] التحقق من صحة المتحكمات مباشرة بدلاً من GlobalKey
    // لأن GlobalKey يكون null عندما يكون الحوار مغلقاً.
    bool isTitleValid = titleController.text.trim().length >= 3;
    // التحقق من أن الحقل ليس فارغاً وأن قيمته رقم صحيح
    bool isOrderValid = orderController.text.trim().isNotEmpty &&
        int.tryParse(orderController.text.trim()) != null;
    bool isUnitValid = selectedUnit.value != null;

    if (!isTitleValid || !isOrderValid || !isUnitValid) {
      KLoaders.error(
          title: "بيانات ناقصة", message: "يرجى مراجعة تفاصيل الدرس.");
      // فتح حوار التفاصيل مع تفعيل الـvalidator لإظهار الأخطاء للمستخدم
      showDetailsDialog(Get.context!, forceValidate: true);
      return;
    }

    // إذا كان لا يزال هناك تسجيل جارٍ — أوقفه قبل الحفظ
    if (recordingState.value != RecordingState.stopped) {
      await stopRecording();
    }

    try {
      final lessonCtrl =
          subjectController.getControllerForUnit(selectedUnit.value!.id);

      final lesson = LessonModel(
        id: isEditing ? lessonToEdit!.id : uuid.v4(),
        title: titleController.text.trim(),
        unitId: selectedUnit.value!.id,
        order: int.tryParse(orderController.text.trim()) ?? 0,
        profileImageUrl: profileImage.value,
        audioUrl: audioPath.value,
        contentBlocks: contentBlocks.toList(),
      );

      isSaving.value = true;

      if (isEditing) {
        await lessonCtrl.updateLesson(lesson.id, lesson);
      } else {
        await lessonCtrl.addLesson(lesson);
      }

      await subjectController.loadAllLessons();
      subjectController.refreshStatsOnCurriculumPage();

      isSaving.value = false;
      Get.back(); // العودة
      KLoaders.success(title: "تم الحفظ", message: "تم حفظ الدرس بنجاح.");
    } catch (e) {
      isSaving.value = false;
      KLoaders.error(title: "خطأ فادح", message: "فشل حفظ الدرس: $e");
    }
  }

  Future<void> goToPreview() async {
    // إذا كان التسجيل يعمل، قم بإيقافه أولاً
    // هذا سيقوم بدمج المقطع الأخير وتجهيز audioPath.value
    if (recordingState.value != RecordingState.stopped) {
      await stopRecording();
    }

    // أنشئ نموذج درس مؤقت من البيانات الحالية في المتحكم
    final tempLesson = LessonModel(
      id: isEditing ? lessonToEdit!.id : 'preview_id',
      title: titleController.text.trim().isEmpty
          ? "(معاينة الدرس)"
          : titleController.text.trim(),
      unitId: selectedUnit.value?.id ?? 'preview_unit',
      order: int.tryParse(orderController.text.trim()) ?? 0,
      profileImageUrl: profileImage.value,
      audioUrl: audioPath.value, // المسار النهائي (المدمج)
      contentBlocks: contentBlocks.toList(),
    );

    // انتقل إلى شاشة التفاصيل مع النموذج المؤقت
    Get.to(() => LessonDetailsPage(lesson: tempLesson));
  }

  /// [معدّل] دالة دمج مقاطع WAV
  Future<void> _mergeWavSegments(List<String> inputs, String output) async {
    // جمع الداتا الخام (بدون ترويسات) وحساب الطول الكلي
    final dataBuffers = <List<int>>[];
    int totalDataLen = 0;

    for (final path in inputs) {
      final f = File(path);
      if (!await f.exists()) continue;
      final bytes = await f.readAsBytes();
      if (bytes.length < 44) continue; // ترويسة فقط أو ملف تالف
      final data = bytes.sublist(44); // تفترض 44 بايت ترويسة قياسية
      dataBuffers.add(data);
      totalDataLen += data.length;
    }

    if (dataBuffers.isEmpty) {
      throw Exception("لا توجد مقاطع صالحة للدمج");
    }

    // اكتب الترويسة النهائية + كل البيانات
    final out = File(output);
    final sink = out.openWrite();

    final header = _buildWavHeader(
      dataLength: totalDataLen,
      sampleRate: _wavSampleRate,
      channels: _wavChannels,
      bitsPerSample: _wavBitsPerSample,
    );
    sink.add(header);

    for (final data in dataBuffers) {
      sink.add(data);
    }

    await sink.flush();
    await sink.close();
  }

  List<int> _buildWavHeader({
    required int dataLength,
    required int sampleRate,
    required int channels,
    required int bitsPerSample,
  }) {
    final byteRate = sampleRate * channels * (bitsPerSample ~/ 8);
    final blockAlign = channels * (bitsPerSample ~/ 8);
    final chunkSize = 36 + dataLength;

    final bytes = BytesBuilder();

    // ChunkID "RIFF"
    bytes.add([0x52, 0x49, 0x46, 0x46]);
    // ChunkSize (little-endian)
    bytes.add(_le32(chunkSize));
    // Format "WAVE"
    bytes.add([0x57, 0x41, 0x56, 0x45]);

    // Subchunk1ID "fmt "
    bytes.add([0x66, 0x6D, 0x74, 0x20]);
    // Subchunk1Size 16 for PCM
    bytes.add(_le32(16));
    // AudioFormat 1 = PCM
    bytes.add(_le16(1));
    // NumChannels
    bytes.add(_le16(channels));
    // SampleRate
    bytes.add(_le32(sampleRate));
    // ByteRate
    bytes.add(_le32(byteRate));
    // BlockAlign
    bytes.add(_le16(blockAlign));
    // BitsPerSample
    bytes.add(_le16(bitsPerSample));

    // Subchunk2ID "data"
    bytes.add([0x64, 0x61, 0x74, 0x61]);
    // Subchunk2Size data length
    bytes.add(_le32(dataLength));

    return bytes.toBytes();
  }

  List<int> _le16(int v) => [v & 0xFF, (v >> 8) & 0xFF];
  List<int> _le32(int v) => [
        v & 0xFF,
        (v >> 8) & 0xFF,
        (v >> 16) & 0xFF,
        (v >> 24) & 0xFF,
      ];
}
