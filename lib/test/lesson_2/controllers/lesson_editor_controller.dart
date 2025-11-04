import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/lesson_model.dart';

class LessonEditorController extends GetxController {
  // الدرس الذي يتم تعديله/إضافته
  final lesson = Lesson(lessonNumber: 1).obs;
  
  // حالة ظهور لوحة التحرير
  var isEditingDetails = false.obs;

  // حالة تشغيل الصوت
  final audioPlayer = AudioPlayer();
  var isPlaying = false.obs;
  var currentPosition = Duration.zero.obs;
  var totalDuration = Duration.zero.obs;
  
  // أدوات اختيار الفترة في شريط الصوت (لربط المحتوى)
  var selectionStart = Duration.zero.obs;
  var selectionEnd = Duration.zero.obs;
  
  // ********* متغيرات التسجيل الصوتي *********
  final recorder = AudioRecorder();
  var isRecording = false.obs;
  // *******************************************
  
  // نموذج لألوان محددة للعناصر لتمييزها
  final List<Color> contentColors = [
    Colors.indigo.shade300,
    Colors.teal.shade300,
    Colors.deepOrange.shade300,
    Colors.pink.shade300,
    Colors.lightBlue.shade300,
  ];
  
  // متحكمات حقول النص (لتعديل تفاصيل الدرس)
  late TextEditingController titleController;
  late TextEditingController detailsController;
  late TextEditingController orderController;

  @override
  void onInit() {
    super.onInit();
    
    // تهيئة المتحكمات بقيم الدرس الحالية
    titleController = TextEditingController(text: lesson.value.title.value);
    detailsController = TextEditingController(text: lesson.value.details.value);
    orderController = TextEditingController(text: lesson.value.order.value.toString());

    // الاستماع لحالة الصوت وموقعه
    audioPlayer.playerStateStream.listen((state) {
      isPlaying.value = state.playing;
    });
    audioPlayer.positionStream.listen((position) {
      currentPosition.value = position ?? Duration.zero;
    });
    audioPlayer.durationStream.listen((duration) {
      totalDuration.value = duration ?? Duration.zero;
    });
  }
  
  // ********* وظائف التسجيل الصوتي *********

  // طلب إذن الميكروفون
  Future<bool> _checkPermission() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  // بدء التسجيل
  Future<void> startRecording() async {
    if (await _checkPermission()) {
      try {
        if (await recorder.isRecording()) return;

        // تحديد مسار حفظ الملف
        final dir = await getApplicationDocumentsDirectory();
        final path = '${dir.path}/lesson_audio_${DateTime.now().millisecondsSinceEpoch}.m4a';
        
        // إعداد وضبط التسجيل (نستخدم aacLc كإعداد قياسي)
        await recorder.start(
          const RecordConfig(encoder: AudioEncoder.aacLc, sampleRate: 44100),
          path: path,
        );
        
        isRecording.value = true;
        Get.snackbar("بدء التسجيل", "بدأ تسجيل شرح الدرس.", backgroundColor: Colors.green.shade100);
      } catch (e) {
        Get.snackbar("خطأ في التسجيل", "لم نتمكن من بدء التسجيل: $e", backgroundColor: Colors.red.shade100);
      }
    } else {
      Get.snackbar("خطأ", "يجب منح إذن الميكروفون لاستخدام هذه الميزة.", backgroundColor: Colors.red.shade100);
    }
  }

  // إيقاف التسجيل وتحميل الملف المشغل
  Future<void> stopRecording() async {
    try {
      final path = await recorder.stop();
      if (path != null) {
        // تحميل المسار المسجل مباشرة إلى مشغل الصوت
        lesson.value.audioPath.value = path;
        await audioPlayer.setFilePath(path);
        
        // إعادة تعيين مؤشرات التحديد إلى بداية ونهاية التسجيل
        selectionStart.value = Duration.zero;
        selectionEnd.value = totalDuration.value;
        
        Get.snackbar("تم الإيقاف", "تم حفظ التسجيل بنجاح.", backgroundColor: Colors.blue.shade100);
      }
      isRecording.value = false;
    } catch (e) {
      Get.snackbar("خطأ في الإيقاف", "فشل إيقاف التسجيل: $e", backgroundColor: Colors.red.shade100);
      isRecording.value = false;
    }
  }
  
  // ********* وظائف تشغيل وربط الصوت *********

  // تشغيل/إيقاف الصوت
  void toggleAudioPlay() {
    if (isPlaying.value) {
      audioPlayer.pause();
    } else {
      audioPlayer.play();
    }
  }

  // فتح/إغلاق لوحة التحرير
  void toggleEditDetails() {
    isEditingDetails.toggle();
    if (isEditingDetails.isFalse) {
      // إعادة تعيين المتحكمات للقيم الحالية عند الإلغاء
      titleController.text = lesson.value.title.value;
      detailsController.text = lesson.value.details.value;
      orderController.text = lesson.value.order.value.toString();
    }
  }

  // حفظ تفاصيل الدرس
  void saveDetails() {
    lesson.value.title.value = titleController.text;
    lesson.value.details.value = detailsController.text;
    lesson.value.order.value = int.tryParse(orderController.text) ?? lesson.value.order.value;
    isEditingDetails.value = false;
    lesson.refresh(); 
  }

  // إضافة محتوى جديد
  void addContentItem(ContentType type) {
    // تحديد بداية ونهاية افتراضية للربط (يجب أن يتم تعديلها من قبل المستخدم)
    Duration start = selectionStart.value;
    Duration end = selectionEnd.value.inMilliseconds > start.inMilliseconds ? selectionEnd.value : start + const Duration(seconds: 5);
        
    // تخصيص لون جديد
    Color newColor = contentColors[lesson.value.contentItems.length % contentColors.length];
    
    lesson.value.contentItems.add(
      ContentItem(
        id: UniqueKey().toString(),
        type: type,
        content: type == ContentType.text ? 'نص جديد # ${lesson.value.contentItems.length + 1}' : 'مسار صورة افتراضي',
        startTime: start,
        endTime: end, 
        color: newColor,
      ),
    );
    Get.back(); // إغلاق الـ BottomSheet
    lesson.refresh();
  }

  // حذف المقطع الصوتي (ويشمل حذف الملف الفعلي)
  void deleteAudio() {
    final path = lesson.value.audioPath.value;
    if (path.isNotEmpty) {
        try {
            audioPlayer.stop();
            File(path).deleteSync(); 
        } catch(e) {
            // تجاهل الخطأ في حالة عدم وجود الملف
        }
    }
    lesson.value.audioPath.value = '';
    totalDuration.value = Duration.zero;
    lesson.value.contentItems.clear(); // إزالة كل الروابط القديمة
    Get.snackbar("تنبيه", "تم حذف المقطع الصوتي وكافة الروابط الزمنية.", backgroundColor: Colors.yellow.shade100);
  }
  
  // حفظ الدرس
  void saveLesson() {
    // منطق حفظ الدرس
    Get.snackbar("تم الحفظ", "تم حفظ الدرس: ${lesson.value.title.value} بنجاح!", backgroundColor: Colors.blue.shade100);
  }

  // معاينة الدرس
  void previewLesson() {
    // منطق الانتقال إلى صفحة المعاينة (بافتراض وجود مسار)
    Get.snackbar("معاينة", "سيتم الانتقال إلى صفحة المعاينة.", backgroundColor: Colors.purple.shade100);
  }

  // دالة لتحديث بداية ونهاية فترة التحديد (يحتاج إلى منطق تفاعل سحب في الواجهة)
  void updateSelection(Duration start, Duration end) {
    selectionStart.value = start;
    selectionEnd.value = end;
  }

  @override
  void onClose() {
    titleController.dispose();
    detailsController.dispose();
    orderController.dispose();
    audioPlayer.dispose();
    recorder.dispose();
    super.onClose();
  }
}
