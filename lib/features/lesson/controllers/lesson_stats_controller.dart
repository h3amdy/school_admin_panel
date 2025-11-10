import 'package:ashil_school/data/repositories/local/question_local_repository.dart';
import 'package:get/get.dart';

/// متحكم صغير لجلب عدد الأسئلة الخاصة بدرس معين
class LessonStatsController extends GetxController {
  final String lessonId;

  late final QuestionLocalRepository _questionRepo;

  final RxBool isLoading = true.obs;
  final RxInt questionCount = 0.obs;

  LessonStatsController({required this.lessonId});

  @override
  void onInit() {
    super.onInit();
    _questionRepo = QuestionLocalRepository();
    _fetchStats();
  }

  Future<void> _fetchStats() async {
    isLoading.value = true;
    try {
      final questions =
          await _questionRepo.getAllQuestionsByLessonId(lessonId);
      questionCount.value = (questions ?? []).length;
    } catch (e) {
      print("Error fetching stats for lesson $lessonId: $e");
      questionCount.value = 0;
    } finally {
      isLoading.value = false;
    }
  }
}