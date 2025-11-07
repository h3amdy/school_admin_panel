import 'package:ashil_school/Utils/constants/sizes.dart';
import 'package:ashil_school/Utils/custom_dilog/confert_dilog.dart';
import 'package:ashil_school/Utils/theme/decorations/app_decorations.dart';
import 'package:ashil_school/features/lesson/models/lesson.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ashil_school/Utils/Styles.dart';

class LessonListWidget extends StatelessWidget {
  final RxList<LessonModel> lessons;
  final LessonModel? selectedLesson;
  final Function(LessonModel) onLessonSelected;
  final bool isLoading;
  final Function(LessonModel?) onEdit; // دالة للتعديل
  final Function(String) onDelete; // دالة للحذف

  const LessonListWidget({
    super.key,
    required this.lessons,
    required this.selectedLesson,
    required this.onLessonSelected,
    required this.isLoading,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (isLoading) {
        return const Center(child: CircularProgressIndicator());
      }
      if (lessons.isEmpty) {
        return const Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Text("لا توجد دروس في هذه الوحدة بعد."),
          ),
        );
      }

      return SizedBox(
        height: 70,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: lessons.length, // تمت إزالة +1 لزر الإضافة
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            final lesson = lessons[index];
            final isSelected = selectedLesson?.id == lesson.id;
            return _lessonItem(context, lesson, isSelected);
          },
        ),
      );
    });
  }

  Widget _lessonItem(
      BuildContext context, LessonModel lesson, bool isSelected) {
    return GestureDetector(
      onLongPress: () => showEditDeleteOptions(
        onEdit: () => onEdit(lesson), // استخدام دالة التعديل الممررة
        onDelete: () => onDelete(lesson.id), // استخدام دالة الحذف الممررة
      ),
      onTap: () => onLessonSelected(lesson), // استخدام دالة الاختيار الممررة
      child: Align(
          alignment: Alignment.center,
          child: AnimatedContainer(
            height: 60,
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.symmetric(
                horizontal: KSizes.sm, vertical: KSizes.sm),
            decoration:
                AppDecorations.cardDecoration(context, selected: isSelected),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.book, color: isSelected ? Colors.white : null),
                const SizedBox(width: 6),
                Text(
                  lesson.title,
                  style: normalStyle(
                    color: isSelected ? Colors.white : null,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
          )),
    );
  }

  // تم حذف _addLessonBtn بالكامل
}
