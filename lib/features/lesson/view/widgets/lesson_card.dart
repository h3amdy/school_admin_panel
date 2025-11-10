import 'package:ashil_school/Utils/custom_dilog/confert_dilog.dart';
import 'package:ashil_school/features/lesson/controllers/lesson_stats_controller.dart';
import 'package:ashil_school/features/lesson/models/lesson.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// ويدجت لعرض الدرس بشكل بطاقة (مشابه لـ SubjectCard)
class LessonCard extends StatelessWidget {
  final LessonModel lesson;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const LessonCard({
    super.key,
    required this.lesson,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // 1. وضع المتحكم الخاص بالإحصائيات لهذه البطاقة
    final statsController = Get.put(
      LessonStatsController(lessonId: lesson.id),
      tag: lesson.id,
    );
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      onLongPress: () => showEditDeleteOptions(
        onEdit: onEdit,
        onDelete: onDelete,
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  /// خلفية البطاقة
                  Positioned.fill(
                    child: Image.asset(
                      'assets/images/lesson_bg.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(color: Colors.blue.shade100);
                      },
                    ),
                  ),

                  /// محتوى البطاقة
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // اسم الدرس
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            lesson.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const Spacer(),
                        // تفاصيل المحتوى (عدد الأسئلة)
                        Obx(() {
                          return _buildContentDetails(context, statsController);
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// رقم الدرس في الأعلى (شارة دائرية)
          Positioned(
            top: 0,
            right: 2,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.primaryColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                '${lesson.order ?? 1}', // <-- هنا الرقم، عدّل الحقل حسب الموديل
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ويدجت لعرض تفاصيل المحتوى (أسئلة)
  Widget _buildContentDetails(
      BuildContext context, LessonStatsController controller) {
    final String questionsText;

    if (controller.isLoading.value) {
      questionsText = '...';
    } else {
      questionsText = '${controller.questionCount.value} سؤال';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _detailItem(Icons.question_answer_outlined, questionsText),
        ],
      ),
    );
  }

  // ويدجت لعرض كل تفصيل (أيقونة + نص)
  Widget _detailItem(IconData icon, String text) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: 18),
        const SizedBox(height: 2),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
