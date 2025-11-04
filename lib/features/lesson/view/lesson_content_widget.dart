// lib/features/lesson/view/lesson_content_widget.dart
import 'package:flutter/material.dart';
import 'package:ashil_school/Utils/theme/container_theme.dart';
import 'package:ashil_school/features/lesson/models/lesson.dart';

class LessonContentWidget extends StatelessWidget {
  final LessonModel selectedLesson;

  const LessonContentWidget({super.key, required this.selectedLesson});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      decoration: Theme.of(context).extension<KContainerTheme>()!.container,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "📑 محتوى الدرس: ${selectedLesson.title}",
            style: theme.textTheme.titleMedium!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            selectedLesson.content,
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
