import 'package:ashil_school/Utils/constants/colors.dart';
import 'package:ashil_school/Utils/formatters/formatter.dart';

import 'dart:io';
import 'package:ashil_school/Utils/constants/sizes.dart';
import 'package:ashil_school/common/widgets/image_screen.dart';
import 'package:ashil_school/features/lesson/controllers/add_edit_lesson_controller.dart';
import 'package:ashil_school/features/lesson/models/content_block.dart';
import 'package:ashil_school/features/lesson/view/widgets/amplitude_painter.dart';
import 'package:ashil_school/features/question/views/questions_page.dart';
import 'package:ashil_school/features/subject/controllers/subject_details_controller.dart';
import 'package:ashil_school/features/lesson/models/lesson.dart';
import 'package:ashil_school/features/lesson/models/position_data.dart'; // <-- استدعاء الكلاس الجديد
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:just_audio/just_audio.dart';

/// الصفحة الجديدة التي تحتوي على صفحتين (تفاصيل + محتوى)
class AddEditLessonPage extends StatelessWidget {
  final SubjectDetailsController subjectController;
  final LessonModel? lessonToEdit;

  const AddEditLessonPage({
    super.key,
    required this.subjectController,
    this.lessonToEdit,
  });

  @override
  Widget build(BuildContext context) {
    // نهيئ المتحكم الجديد
    final controller = Get.put(AddEditLessonController(
      subjectController: subjectController,
      lessonToEdit: lessonToEdit,
    ));
    // إظهار حوار التفاصيل تلقائياً عند الدخول
    controller.openDetailsOnEnter(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, KSizes.appBarHeight),
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: _buildContentHeader(context, controller),
        ),
      ),
      body: Column(
        children: [
          // جسم المحتوى (قائمة عادية بلا سحب)
          Expanded(child: _buildContentList(context, controller)),
          const Divider(height: 1),
          // شريط المصغرات (مع إعادة ترتيب أفقية)
          _buildContentThumbStrip(context, controller),
          // شريط الصوت
          _buildAudioStrip(context, controller),

          // شريط سفلي مبسط (حفظ فقط)
          _buildBottomBar(context, controller),
        ],
      ),
    );
  }

  // أ. شريط العنوان والتعديل
  Widget _buildContentHeader(
      BuildContext context, AddEditLessonController controller) {
    return Obx(() {
      final imagePath = controller.profileImage.value;
      final bool isNetworkImage =
          imagePath != null && imagePath.startsWith('http');
      final bool isLocalFile = imagePath != null && !isNetworkImage;

      return ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          backgroundImage: isLocalFile ? FileImage(File(imagePath!)) : null,
          child: isNetworkImage
              ? ClipOval(
                  child: Image.network(
                  imagePath,
                  fit: BoxFit.cover,
                  width: 40,
                  height: 40,
                ))
              : (imagePath == null ? const Icon(Iconsax.back_square) : null),
        ),
        title: Text(
          controller.titleRx.value.trim().isEmpty
              ? "(بدون عنوان)"
              : controller.titleRx.value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
            "الوحدة: ${controller.selectedUnit.value?.name ?? '(غير محدد)'} | الترتيب: ${controller.orderRx.value}"),
        trailing: IconButton(
          icon:
              Icon(Iconsax.edit, color: Theme.of(context).colorScheme.primary),
          tooltip: "تعديل تفاصيل الدرس",
          onPressed: controller.goToDetailsPage,
        ),
      );
    });
  }

  // ج. شريط المحتوى المصغر — مع إعادة الترتيب فقط هنا
  Widget _buildContentThumbStrip(
      BuildContext context, AddEditLessonController controller) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      color: Theme.of(context).canvasColor,
      child: Row(
        children: [
          // زر الإضافة
          InkWell(
            onTap: () => controller.showAddContentDialog(context),
            child: Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Iconsax.add_circle, color: colorScheme.primary),
            ),
          ),
          const SizedBox(width: 10),

          // القائمة المصغّرة القابلة لإعادة الترتيب (أفقياً)
          Expanded(
            child: Obx(() {
              final blocks = controller.contentBlocks;

              if (blocks.isEmpty) {
                return const SizedBox.shrink();
              }

              return ReorderableListView.builder(
                scrollDirection: Axis.horizontal,
                buildDefaultDragHandles: true, // السحب من أي مكان في العنصر
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                itemCount: blocks.length,
                onReorder: (oldIndex, newIndex) {
                  // تعديل فهرس Flutter القياسي
                  if (oldIndex < newIndex) newIndex -= 1;
                  controller.onReorder(oldIndex, newIndex);
                  // سيُعاد البناء تلقائياً لأننا داخل Obx
                },
                proxyDecorator: (child, index, animation) {
                  // تأثير بسيط أثناء السحب
                  final t = Curves.easeInOut.transform(animation.value);
                  final scale = 0.98 + (1 - t) * 0.02;
                  return Transform.scale(
                    scale: scale,
                    alignment: Alignment.center,
                    child: Material(
                      elevation: 6,
                      borderRadius: BorderRadius.circular(8),
                      clipBehavior: Clip.antiAlias,
                      child: child,
                    ),
                  );
                },
                itemBuilder: (ctx, index) {
                  final block = blocks[index];
                  return Padding(
                    key: ValueKey(block.id),
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: InkWell(
                      onTap: () => controller.scrollToContentBlock(block.id),
                      child: Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: colorScheme.outlineVariant,
                          ),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: block.type == ContentType.image
                            ? (block.data.startsWith('http')
                                ? Image.network(block.data, fit: BoxFit.cover)
                                : Image.file(File(block.data),
                                    fit: BoxFit.cover))
                            : Icon(Iconsax.text, color: colorScheme.secondary),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  // ب. جسم المحتوى (قائمة عرض فقط بلا إعادة ترتيب)
  Widget _buildContentList(
    BuildContext context,
    AddEditLessonController controller,
  ) {
    return Obx(() {
      if (controller.contentBlocks.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Iconsax.document_upload, size: 60, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                "المحتوى فارغ",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                "أضف نصوص أو صور من الشريط في الأعلى",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        key: const PageStorageKey('contentListReadonly'),
        controller: controller.contentScrollController,
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        cacheExtent: 10000,
        itemCount: controller.contentBlocks.length,
        itemBuilder: (context, index) {
          final block = controller.contentBlocks[index];
          return Container(
            key: ValueKey(block.id),
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: Card(
              clipBehavior: Clip.antiAlias,
              elevation: 1,
              child: Container(
                key: controller.getScrollKey(block.id), // للتمرير من المصغّرات
                child: _buildContentBlockItem(context, controller, block),
              ),
            ),
          );
        },
      );
    });
  }

  // عنصر واحد في قائمة المحتوى
  Widget _buildContentBlockItem(BuildContext context,
      AddEditLessonController controller, ContentBlock block) {
    return Stack(
      children: [
        // المحتوى الفعلي
        Padding(
          padding: const EdgeInsets.only(
              top: 30.0, left: 8.0, right: 8.0, bottom: 8.0),
          child: block.type == ContentType.text
              ? _buildTextBlock(context, block)
              : _buildImageBlock(context, block),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Icon(
                block.type == ContentType.text
                    ? Iconsax.text_block
                    : Iconsax.image,
                color: Colors.grey,
                size: 20),
          ),
        ),
        // أزرار التعديل والحذف
        Positioned(
          top: 0,
          left: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Iconsax.edit,
                      size: 20, color: Theme.of(context).colorScheme.secondary),
                  onPressed: () => controller.editContentBlock(context, block),
                  tooltip: "تعديل",
                  visualDensity: VisualDensity.compact,
                ),
                IconButton(
                  icon: Icon(Iconsax.trash,
                      size: 20, color: Theme.of(context).colorScheme.error),
                  onPressed: () =>
                      controller.confirmRemoveContentBlock(context, block.id),
                  tooltip: "حذف",
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // عنصر النص
  Widget _buildTextBlock(BuildContext context, ContentBlock block) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              block.data,
              style:
                  Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  // عنصر الصورة
  Widget _buildImageBlock(BuildContext context, ContentBlock block) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: block.data.startsWith('http')
            ? Image.network(
                block.data,
                fit: BoxFit.cover,
                width: double.infinity,
              )
            : InkWell(
                onTap: () => Get.to(() => ImageScreen(
                      image: File(block.data),
                    )),
                child: Image.file(
                  File(block.data),
                  fit: BoxFit.cover,
                  width: double.infinity,
                )),
      ),
    );
  }

  Widget _buildAudioStrip(
    BuildContext context,
    AddEditLessonController controller,
  ) {
    final scheme = Theme.of(context).colorScheme;

    IconData centerIcon(RecordingState s) {
      switch (s) {
        case RecordingState.stopped:
          return Iconsax.microphone; // بدء
        case RecordingState.recording:
          return Iconsax.pause; // إيقاف مؤقت
        case RecordingState.paused:
          return Iconsax.play; // استئناف
      }
    }

    Future<void> onCenterPressed(RecordingState s) async {
      switch (s) {
        case RecordingState.stopped:
          await controller.startRecording();
          break;
        case RecordingState.recording:
          await controller.pauseRecording();
          break;
        case RecordingState.paused:
          await controller.resumeRecording();
          break;
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Obx(() {
        final state = controller.recordingState.value;
        final hasAudio = controller.hasAnyAudio;

        final bool isPreviewing = state == RecordingState.paused &&
            (controller.isPlaying.value ||
                (controller.audioPlayer.processingState ==
                    ProcessingState.ready));

        final bool isFinalAudioReady = state == RecordingState.stopped &&
            controller.audioPath.value != null;

        // نستخدم هذا العلم لعرض/إخفاء الشريط العلوي (الترددات أو السلايدر)
        bool showTopRow = true;
        Widget topRow;

        // 1) النهائي أو المعاينة => شريط الصوت
        if (isFinalAudioReady || isPreviewing) {
          topRow = StreamBuilder<PositionData>(
            stream: controller.positionDataStream,
            builder: (context, snapshot) {
              final d = snapshot.data?.duration ?? Duration.zero;
              final p = snapshot.data?.position ?? Duration.zero;
              return Row(
                children: [
                  Text(
                    KFormatter.formatDuration(p), // <-- استخدام الكلاس الجديد
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Slider(
                      value: p.inMilliseconds
                          .toDouble()
                          .clamp(0, d.inMilliseconds.toDouble()),
                      max: d.inMilliseconds.toDouble() == 0
                          ? 1
                          : d.inMilliseconds.toDouble(),
                      onChanged: (v) => controller.audioPlayer
                          .seek(Duration(milliseconds: v.round())),
                      activeColor: scheme.primary,
                      inactiveColor: scheme.primaryContainer,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    KFormatter.formatDuration(d), // <-- استخدام الكلاس الجديد
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(width: 8),
                  Obx(
                    () => Tooltip(
                      message: controller.isPlaying.value ? "إيقاف" : "تشغيل",
                      child: IconButton(
                        icon: Icon(
                          controller.isPlaying.value
                              ? Iconsax.pause
                              : Iconsax.play,
                          color: scheme.primary,
                        ),
                        onPressed: controller.toggleAudioPlayback,
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        }
        // 2) أثناء التسجيل => مرسِم الترددات
        else if (state == RecordingState.recording) {
          topRow = Column(
            children: [
              _buildRecordingVisualizer(context, controller),
              Row(
                children: [
                  Text(
                    controller.recordingElapsedStr.value,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const Spacer(),
                  Tooltip(
                    message: "تشغيل غير متاح أثناء التسجيل",
                    child: IconButton(
                        icon: const Icon(Iconsax.play), onPressed: null),
                  ),
                ],
              ),
            ],
          );
        }
        // 3) متوقف مؤقتًا => شريط الصوت (بدلًا من المرئي) + معاينة
        else if (state == RecordingState.paused) {
          topRow = StreamBuilder<PositionData>(
            stream: controller.positionDataStream,
            builder: (context, snapshot) {
              final d = snapshot.data?.duration ?? Duration.zero;
              final p = snapshot.data?.position ?? Duration.zero;
              return Row(
                children: [
                  Text(
                    KFormatter.formatDuration(p), // <-- استخدام الكلاس الجديد
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Slider(
                      value: p.inMilliseconds
                          .toDouble()
                          .clamp(0, d.inMilliseconds.toDouble()),
                      max: d.inMilliseconds.toDouble() == 0
                          ? 1
                          : d.inMilliseconds.toDouble(),
                      onChanged: (v) => controller.audioPlayer
                          .seek(Duration(milliseconds: v.round())),
                      activeColor: scheme.primary,
                      inactiveColor: scheme.primaryContainer,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    KFormatter.formatDuration(d), // <-- استخدام الكلاس الجديد
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(width: 8),
                  Obx(
                    () => Tooltip(
                      message: controller.isPlaying.value
                          ? "إيقاف المعاينة"
                          : "معاينة",
                      child: IconButton(
                        icon: Icon(
                          controller.isPlaying.value
                              ? Iconsax.pause
                              : Iconsax.play,
                          color: scheme.primary,
                        ),
                        onPressed: controller.toggleAudioPlayback,
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        }
        // 4) متوقف ولا يوجد أي تسجيل => لا نعرض الشريط العلوي نهائيًا
        else /* state == RecordingState.stopped && !hasAudio */ {
          showTopRow = false;
          topRow = const SizedBox.shrink();
        }

        // ---------- السطر السفلي كما هو ----------
        final bottomRow = Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // حذف
            Tooltip(
              message: "حذف المقطع",
              child: IconButton(
                icon: Icon(
                  Iconsax.trash,
                  color: (state == RecordingState.stopped && hasAudio)
                      ? scheme.error
                      : Colors.grey,
                ),
                onPressed: (state == RecordingState.stopped && hasAudio)
                    ? controller.deleteAudio
                    : null,
              ),
            ),

            // زر رئيسي (بدء/إيقاف مؤقت/استئناف)
            Expanded(
              child: Center(
                child: Tooltip(
                  message: state == RecordingState.stopped
                      ? "بدء التسجيل"
                      : (state == RecordingState.recording
                          ? "إيقاف مؤقت"
                          : "استئناف"),
                  child: FloatingActionButton(
                    heroTag: 'fab-rec',
                    onPressed: () => onCenterPressed(state),
                    backgroundColor: state == RecordingState.recording
                        ? scheme.error
                        : (state == RecordingState.paused
                            ? scheme.secondary
                            : scheme.primary),
                    child: Icon(centerIcon(state), color: Colors.white),
                  ),
                ),
              ),
            ),

            // إنهاء
            Tooltip(
              message: "إنهاء التسجيل",
              child: IconButton(
                icon: Icon(
                  Iconsax.stop_circle,
                  color: (state == RecordingState.recording ||
                          state == RecordingState.paused)
                      ? scheme.error
                      : Colors.grey,
                ),
                onPressed: (state == RecordingState.recording ||
                        state == RecordingState.paused)
                    ? () async => controller.stopRecording()
                    : null,
              ),
            ),
          ],
        );

        // الإرجاع: لا نضيف المسافة الفاصلة إلا إذا كان هناك شريط علوي ظاهر
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showTopRow) topRow,
            if (showTopRow) const SizedBox(height: 6),
            bottomRow,
          ],
        );
      }),
    );
  }

  // واجهة عرض الترددات أثناء التسجيل
  Widget _buildRecordingVisualizer(
      BuildContext context, AddEditLessonController controller) {
    return Obx(() {
      final amplitudes = controller.recordingAmplitudes.toList();
      final displayAmplitudes = amplitudes.length > 50
          ? amplitudes.sublist(amplitudes.length - 50)
          : amplitudes;

      return Container(
        height: 40,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color:
              Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
          borderRadius: BorderRadius.circular(8),
        ),
        child: CustomPaint(
          // <-- استخدام الويدجت المفصول
          painter: AmplitudePainter(
            amplitudes: displayAmplitudes,
            color: Theme.of(context).colorScheme.primary,
          ),
          size: const Size(double.infinity, 40),
        ),
      );
    });
  }

  Widget _buildBottomBar(
      BuildContext context, AddEditLessonController controller) {
    return Obx(() => BottomAppBar(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Tooltip(
                message: "إنهاء التسجيل",
                child: IconButton(
                  icon: Icon(
                    Iconsax.message_question,
                    size: 40,
                    color: KColors.primary,
                  ),
                  onPressed: () {
                    Get.to(QuestionsPage(
                      lessonId: "dkjkd",
                      lessonName: controller.titleRx.value,
                    ));
                  },
                ),
              ),
              Spacer(),
              OutlinedButton.icon(
                icon: const Icon(Iconsax.eye),
                label: const Text("معاينة"),
                // تعطيل المعاينة أثناء الحفظ
                onPressed:
                    controller.isSaving.value ? null : controller.goToPreview,
              ),

              // [تعديل] تغيير زر الحفظ إلى ElevatedButton لتمييزه
              ElevatedButton.icon(
                icon: controller.isSaving.value
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          // لون أبيض ليتناسب مع الزر
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      )
                    : const Icon(Iconsax.save_2),
                label: const Text("حفظ الدرس"),
                onPressed:
                    controller.isSaving.value ? null : controller.saveLesson,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              const SizedBox(width: 12),
            ],
          ),
        ));
  }
}
