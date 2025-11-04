import 'package:ashil_school/Utils/helpers/loaders/loaders.dart';
import 'package:ashil_school/data/repositories/local/grade_local_repository.dart';
import 'package:ashil_school/data/repositories/local/semester_local_repository.dart';
import 'package:ashil_school/data/repositories/local/subject_local_repository.dart';
import 'package:ashil_school/features/grade/models/grade.dart';
import 'package:ashil_school/features/semester/models/semester.dart';
import 'package:ashil_school/features/subject/models/subject.dart';
import 'package:get/get.dart';

class SubjectAssignmentController extends GetxController {
  final RxList<GradeModel> allGrades = <GradeModel>[].obs;
  final RxSet<String> selectedSubjectIds = <String>{}.obs;
  final RxBool isLoading = false.obs;
  final RxnString error = RxnString();

  final Set<String> _initialSubjectIds = {};

  late final GradeLocalRepository gradesRepo;
  late final SemesterLocalRepository semestersRepo;
  late final SubjectLocalRepository subjectsRepo;

  final RxMap<String, Map<String, dynamic>> _allSubjectsWithContext =
      <String, Map<String, dynamic>>{}.obs;

  SubjectAssignmentController(
      {required List<String> initialSelectedSubjectIds}) {
    selectedSubjectIds.addAll(initialSelectedSubjectIds);
    _initialSubjectIds.addAll(initialSelectedSubjectIds);
    gradesRepo = GradeLocalRepository();
    semestersRepo = SemesterLocalRepository();
    subjectsRepo = SubjectLocalRepository();
  }

  @override
  void onInit() {
    super.onInit();
    fetchGradesWithDetailsFromLocal();
  }

  Future<void> fetchGradesWithDetailsFromLocal() async {
    try {
      isLoading.value = true;
      error.value = null;

      final fetchedGrades = await gradesRepo.getAll();
      allGrades.assignAll(fetchedGrades);

      final Map<String, Map<String, dynamic>> tempSubjectsWithContext = {};

      for (var grade in allGrades) {
        if (grade.id.isEmpty) {
          continue;
        }

        final fetchedSemesters =
            await semestersRepo.getSemestersByGradeId(grade.id);
        grade.semesters = fetchedSemesters;

        for (var semester in grade.semesters!) {
          if (semester.id.isEmpty) {
            continue;
          }

          final fetchedSubjects =
              await subjectsRepo.getSubjectsBySemesterId(semester.id);
          semester.subjects = fetchedSubjects;

          for (var subject in fetchedSubjects) {
            tempSubjectsWithContext[subject.id] = {
              'subject': subject,
              'grade': grade,
              'semester': semester,
            };
          }
        }
      }
      _allSubjectsWithContext.assignAll(tempSubjectsWithContext);
    } catch (e) {
      error.value = "خطأ في تحميل البيانات المحلية: $e";
      KLoaders.error(title: "خطأ", message: error.value);
    } finally {
      isLoading.value = false;
    }
  }

  // --- الدوال الجديدة هنا ---
  bool hasSubjectsForGrade(GradeModel grade) {
    if (grade.semesters == null || grade.semesters!.isEmpty) {
      return false;
    }
    for (var semester in grade.semesters!) {
      if (hasSubjectsForSemester(semester)) {
        return true;
      }
    }
    return false;
  }

  bool hasSubjectsForSemester(SemesterModel semester) {
    return semester.subjects != null && semester.subjects!.isNotEmpty;
  }

  // --- باقي الدوال ---
  List<Map<String, dynamic>> getSelectedSubjectModelsWithContext() {
    return selectedSubjectIds
        .map((id) => _allSubjectsWithContext[id])
        .whereType<Map<String, dynamic>>()
        .toList();
  }

  void toggleGradeSelection(GradeModel grade, bool isSelected) {
    if (!hasSubjectsForGrade(grade)) return;
    for (var semester in grade.semesters ?? []) {
      if (!hasSubjectsForSemester(semester)) continue;
      for (var subject in semester.subjects ?? []) {
        if (isSelected) {
          if (subject.id.isNotEmpty) {
            selectedSubjectIds.add(subject.id);
          }
        } else {
          selectedSubjectIds.remove(subject.id);
        }
      }
    }
  }

  void toggleSemesterSelection(SemesterModel semester, bool isSelected) {
    if (!hasSubjectsForSemester(semester)) return;
    for (var subject in semester.subjects ?? []) {
      if (isSelected) {
        if (subject.id.isNotEmpty) {
          selectedSubjectIds.add(subject.id);
        }
      } else {
        selectedSubjectIds.remove(subject.id);
      }
    }
  }

  void toggleSubjectSelection(SubjectModel subject, bool isSelected) {
    if (isSelected) {
      selectedSubjectIds.add(subject.id);
    } else {
      selectedSubjectIds.remove(subject.id);
    }
  }

  bool isGradeFullySelected(GradeModel grade) {
    if (!hasSubjectsForGrade(grade)) return false;
    for (var semester in grade.semesters!) {
      for (var subject in semester.subjects!) {
        if (!selectedSubjectIds.contains(subject.id)) {
          return false;
        }
      }
    }
    return true;
  }

  bool isSemesterFullySelected(SemesterModel semester) {
    if (!hasSubjectsForSemester(semester)) return false;
    for (var subject in semester.subjects!) {
      if (!selectedSubjectIds.contains(subject.id)) {
        return false;
      }
    }
    return true;
  }

  bool isSubjectSelected(SubjectModel subject) {
    return selectedSubjectIds.contains(subject.id);
  }
}
