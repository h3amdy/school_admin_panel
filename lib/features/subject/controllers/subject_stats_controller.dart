import 'package:ashil_school/data/repositories/local/lesson_local_repository.dart';
import 'package:ashil_school/data/repositories/local/question_local_repository.dart';
import 'package:ashil_school/data/repositories/local/unit_local_repository.dart';
import 'package:get/get.dart';

/// متحكم صغير وخفيف، وظيفته فقط حساب الإحصائيات
/// (عدد الوحدات، الدروس، الأسئلة) لمادة معينة.
class SubjectStatsController extends GetxController {
  final String subjectId;

  // Repositories
  late final UnitLocalRepository _unitRepo;
  late final LessonLocalRepository _lessonRepo;
  late final QuestionLocalRepository _questionRepo;

  // State
  final RxBool isLoading = true.obs;
  final RxInt unitCount = 0.obs;
  final RxInt lessonCount = 0.obs;
  final RxInt questionCount = 0.obs;

  SubjectStatsController({required this.subjectId});

  @override
  void onInit() {
    super.onInit();
    // تهيئة الـ Repositories (بافتراض أنها قابلة للإنشاء مباشرة)
    _unitRepo = UnitLocalRepository();
    _lessonRepo = LessonLocalRepository();
    _questionRepo = QuestionLocalRepository();

    // بدء جلب الإحصائيات
    _fetchStats();
  }

  /// دالة لجلب الإحصائيات من قاعدة البيانات المحلية
  Future<void> _fetchStats() async {
    isLoading.value = true;
    try {
      int tempLessonCount = 0;
      int tempQuestionCount = 0;

      // 1. جلب الوحدات
      final units = await _unitRepo.getUnitsBySubjectId(subjectId);
      unitCount.value = units.length;

      // 2. جلب الدروس لكل وحدة
      for (final unit in units) {
        final lessons = await _lessonRepo.getAllLessonsByUnitId(unit.id);
        tempLessonCount += lessons.length;

        // 3. جلب الأسئلة لكل درس
        for (final lesson in lessons) {
          final questions =
              await _questionRepo.getAllQuestionsByLessonId(lesson.id);
          // (نضيف ? [] كاحتياط)
          tempQuestionCount += (questions ?? []).length;
        }
      }

      // 4. تحديث القيم النهائية
      lessonCount.value = tempLessonCount;
      questionCount.value = tempQuestionCount;
    } catch (e) {
      print("Error fetching stats for subject $subjectId: $e");
      // في حال حدوث خطأ، نعرض صفر
      unitCount.value = 0;
      lessonCount.value = 0;
      questionCount.value = 0;
    } finally {
      isLoading.value = false;
    }
  }
}
