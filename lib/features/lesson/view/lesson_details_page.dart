import 'dart:io';

import 'package:ashil_school/Utils/formatters/formatter.dart';
import 'package:ashil_school/features/lesson/models/content_block.dart';
import 'package:ashil_school/features/lesson/models/lesson.dart';
import 'package:ashil_school/features/lesson/controllers/lesson_details_controller.dart';
import 'package:ashil_school/features/lesson/models/position_data.dart'; // <-- استدعاء الكلاس الجديد
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

/// شاشة عرض تفاصيل الدرس (للقراءة والمعاينة)
class LessonDetailsPage extends StatelessWidget {
  final LessonModel lesson;
  const LessonDetailsPage({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    // حقن المتحكم الخاص بهذه الصفحة لإدارة الصوت
    final controller = Get.put(LessonDetailsController(lesson: lesson));
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      // استخدام CustomScrollView لإعطاء تأثير احترافي للشريط العلوي
      body: CustomScrollView(
        slivers: [
          // الشريط العلوي (يختفي ويظهر مع التمرير)
          SliverAppBar(
            expandedHeight: 250.0,
            floating: false,
            pinned: true,
            backgroundColor: colorScheme.surface,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                lesson.title,
                style: textTheme.titleLarge
                    ?.copyWith(color: colorScheme.onSurface),
              ),
              background: _buildHeaderImage(lesson.profileImageUrl),
            ),
          ),
          // قائمة محتوى الدرس
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final block = lesson.contentBlocks[index];
                  if (block.type == ContentType.text) {
                    return _buildTextBlock(context, block);
                  } else {
                    return _buildImageBlock(context, block);
                  }
                },
                childCount: lesson.contentBlocks.length,
              ),
            ),
          ),
        ],
      ),
      // مشغل الصوت الثابت في الأسفل
      bottomNavigationBar: Obx(
        () => controller.hasAudio.value
            ? _buildAudioPlayer(context, controller)
            : const SizedBox.shrink(),
      ),
    );
  }

  /// ويدجت لعرض صورة رأس الصفحة (مع معالجة المسارات)
  Widget _buildHeaderImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return Container(color: Colors.grey[300]);
    }

    Widget imageWidget;
    bool isNetwork = imageUrl.startsWith('http');

    if (isNetwork) {
      imageWidget = Image.network(imageUrl, fit: BoxFit.cover);
    } else {
      // للمعاينة من ملف محلي
      imageWidget = Image.file(File(imageUrl), fit: BoxFit.cover);
    }

    return Container(
      decoration: const BoxDecoration(
        // تدرج بسيط لتحسين قراءة العنوان فوق الصورة
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.black45],
          stops: [0.5, 1.0],
        ),
      ),
      child: imageWidget,
    );
  }

  /// ويدجت لعرض كتلة نصية (مع إمكانية التحديد)
  Widget _buildTextBlock(BuildContext context, ContentBlock block) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: SelectableText(
        block.data,
        style: Theme.of(context)
            .textTheme
            .bodyLarge
            ?.copyWith(fontSize: 17, height: 1.6, color: Colors.black87),
      ),
    );
  }

  /// ويدجت لعرض كتلة صورة
  Widget _buildImageBlock(BuildContext context, ContentBlock block) {
    Widget imageWidget;
    bool isNetwork = block.data.startsWith('http');

    if (isNetwork) {
      imageWidget = Image.network(block.data, fit: BoxFit.cover);
    } else {
      imageWidget = Image.file(File(block.data), fit: BoxFit.cover);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: imageWidget,
      ),
    );
  }

  /// ويدجت مشغل الصوت
  Widget _buildAudioPlayer(
      BuildContext context, LessonDetailsController controller) {
    final scheme = Theme.of(context).colorScheme;
    return BottomAppBar(
      height: 122,
      child: Obx(
        () {
          if (controller.isLoadingAudio.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return StreamBuilder<PositionData>(
            stream: controller.positionDataStream,
            builder: (context, snapshot) {
              final duration = snapshot.data?.duration ?? Duration.zero;
              final position = snapshot.data?.position ?? Duration.zero;

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // شريط التقدم
                  Slider(
                    value: position.inMilliseconds
                        .toDouble()
                        .clamp(0, duration.inMilliseconds.toDouble()),
                    max: duration.inMilliseconds.toDouble() == 0
                        ? 1
                        : duration.inMilliseconds.toDouble(),
                    onChanged: (v) => controller.audioPlayer
                        .seek(Duration(milliseconds: v.round())),
                    activeColor: scheme.primary,
                    inactiveColor: scheme.primaryContainer,
                  ),
                  // الأزرار والوقت
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(KFormatter.formatDuration(
                            position)), // <-- استخدام الكلاس الجديد
                        Obx(
                          () => IconButton.filled(
                            icon: Icon(controller.isPlaying.value
                                ? Iconsax.pause
                                : Iconsax.play),
                            iconSize: 30,
                            onPressed: controller.togglePlayPause,
                          ),
                        ),
                        Text(KFormatter.formatDuration(
                            duration)), // <-- استخدام الكلاس الجديد
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
