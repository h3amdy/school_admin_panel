import 'package:ashil_school/Utils/custom_dilog/confert_dilog.dart';
import 'package:ashil_school/features/subject/controllers/subject_stats_controller.dart';
import 'package:ashil_school/features/subject/models/subject.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// ويدجت لعرض المادة بشكل بطاقة
class SubjectCard extends StatelessWidget {
  final SubjectModel subject;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const SubjectCard({
    super.key,
    required this.subject,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // [FIX] 1. وضع المتحكم الخاص بالإحصائيات لهذه البطاقة
    // نستخدم subject.id كـ tag لضمان أن كل بطاقة لها متحكمها الخاص
    final statsController = Get.put(
      SubjectStatsController(subjectId: subject.id),
      tag: subject.id,
    );

    return InkWell(
      onTap: onTap,
      onLongPress: () => showEditDeleteOptions(
        onEdit: onEdit,
        onDelete: onDelete,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/subject_bg.png', // افترض وجود صورة في المسار
                fit: BoxFit.cover,
                // في حال لم يتم العثور على الصورة، يتم عرض لون
                errorBuilder: (context, error, stackTrace) {
                  return Container(color: Colors.blue.shade100);
                },
              ),
            ),
            // 2. تراكب لوني شفاف

            // 3. المحتوى (الاسم والتفاصيل)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // اسم المادة في الأعلى
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      subject.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        shadows: [
                          Shadow(
                              blurRadius: 4.0,
                              color: Colors.black54,
                              offset: Offset(1, 1))
                        ],
                      ),
                    ),
                  ),
                  const Spacer(), // يدفع التفاصيل للأسفل
                  
                  // [FIX] 2. تغليف التفاصيل بـ Obx لمراقبة التغييرات
                  Obx(() {
                    return _buildContentDetails(context, statsController);
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // [FIX] 3. تعديل الدالة لتستقبل المتحكم
  /// ويدجت لعرض تفاصيل المحتوى (وحدات، دروس، أسئلة)
  Widget _buildContentDetails(
      BuildContext context, SubjectStatsController controller) {
    // تحديد النصوص بناءً على حالة التحميل
    final String unitsText;
    final String lessonsText;
    final String questionsText;

    if (controller.isLoading.value) {
      // عرض "..." أثناء التحميل
      unitsText = '...';
      lessonsText = '...';
      questionsText = '...';
    } else {
      // عرض الأعداد الحقيقية بعد التحميل
      unitsText = '${controller.unitCount.value} وحدات';
      lessonsText = '${controller.lessonCount.value} درس';
      questionsText = '${controller.questionCount.value} سؤال';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _detailItem(Icons.folder_copy_outlined, unitsText),
          _detailItem(Icons.menu_book_outlined, lessonsText),
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
