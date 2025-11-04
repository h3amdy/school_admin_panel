import 'package:ashil_school/features/grade/controllers/grade_controller.dart';
import 'package:ashil_school/features/grade/models/grade.dart';
import 'package:ashil_school/features/semester/controllers/semester_controller.dart';
import 'package:ashil_school/features/semester/models/semester.dart';
import 'package:ashil_school/features/subject/controllers/subject_controller.dart';
import 'package:ashil_school/features/subject/models/subject.dart';
import 'package:get/get.dart';

// --- هذا هو المتحكم الجديد الخاص بالصفحة ---

class CurriculumController extends GetxController {
  // 1. المتحكمات التي تعتمد عليها
  //    (يجب أن يكون GradeController موجوداً في الذاكرة)
  final GradeController _gradeController = Get.find<GradeController>();

  // 2. حالة الصفحة (State)
  final Rx<GradeModel> currentGrade;
  final Rx<SemesterModel?> selectedSemester = Rxn<SemesterModel>();
  final RxList<SemesterModel> semesters = <SemesterModel>[].obs;
  final RxList<SubjectModel> subjects = <SubjectModel>[].obs;
  final RxBool isLoadingSemesters = true.obs;
  final RxBool isLoadingSubjects = true.obs;

  // 3. المتحكمات الفرعية (للفصول والمواد)
  //    سنقوم بإنشائها وحذفها ديناميكياً
  late SemesterController semesterController;
  late SubjectController subjectController;

  // قائمة لحفظ "المستمعين" ليتم إزالتهم عند التغيير
  final List<Function> _listenerDisposers = [];

  CurriculumController({required GradeModel initialGrade})
      : currentGrade = initialGrade.obs;

  @override
  void onInit() {
    super.onInit();
    // 1. تهيئة المتحكمات الفرعية لأول مرة
    _initializeChildControllers(currentGrade.value.id);
    // 2. إعداد المستمعين (Listeners)
    _setupListeners();
  }

  // دالة لتهيئة المتحكمات الفرعية
  void _initializeChildControllers(String gradeId) {
    // نستخدم الـ gradeId كـ tag لضمان العثور على النسخة الصحيحة
    semesterController = Get.put(SemesterController(gradeId), tag: gradeId);
    subjectController = Get.put(
        SubjectController(gradeId: gradeId, semesterId: null),
        tag: gradeId);
  }

  // دالة لإعداد المستمعين على المتحكمات الفرعية
  void _setupListeners() {
    // التأكد من إزالة أي مستمعين قدامى
    _disposeListeners();

    // الاستماع لقائمة الفصول
    _listenerDisposers.add(
      ever(semesterController.semesters, (List<SemesterModel> newSemesters) {
        semesters.assignAll(newSemesters);
        semesters.sort((a, b) => a.order.compareTo(b.order));
        isLoadingSemesters.value = false;

        if (newSemesters.isNotEmpty && selectedSemester.value == null) {
          // إذا كانت القائمة غير فارغة ولا يوجد فصل مختار، اختر الأول
          selectSemester(newSemesters.first);
        } else if (newSemesters.isEmpty) {
          // إذا أصبحت القائمة فارغة، قم بتنظيف الحالة
          selectedSemester.value = null;
          subjects.clear();
          isLoadingSubjects.value = false;
        }
      }).call,
    );

    // الاستماع لقائمة المواد
    _listenerDisposers.add(
      ever(subjectController.subjects, (List<SubjectModel> newSubjects) {
        subjects.assignAll(newSubjects);
        isLoadingSubjects.value = false;
      }).call,
    );

    // الاستماع لحالة تحميل الفصول
    _listenerDisposers.add(
      ever(semesterController.isLoading, (bool loading) {
        isLoadingSemesters.value = loading;
      }).call,
    );

    // الاستماع لحالة تحميل المواد
    _listenerDisposers.add(
      ever(subjectController.isLoading, (bool loading) {
        isLoadingSubjects.value = loading;
      }).call,
    );
  }

  // دالة لإزالة المستمعين (لتجنب استدعائهم على متحكمات قديمة)
  void _disposeListeners() {
    for (var dispose in _listenerDisposers) {
      dispose();
    }
    _listenerDisposers.clear();
  }

  // 4. الدالة الأهم: تغيير الصف
  void changeGrade(GradeModel newGrade) {
    if (newGrade.id == currentGrade.value.id) return; // نفس الصف، لا تفعل شيئاً

    final oldGradeId = currentGrade.value.id;

    // 1. إيقاف وإزالة المستمعين
    _disposeListeners();

    // 2. حذف المتحكمات الفرعية القديمة (مهم جداً لمنع تسرب الذاكرة)
    Get.delete<SemesterController>(tag: oldGradeId);
    Get.delete<SubjectController>(tag: oldGradeId);

    // 3. تحديث بيانات الصف الحالية
    currentGrade.value = newGrade;

    // 4. تصفير الحالات
    selectedSemester.value = null;
    semesters.clear();
    subjects.clear();
    isLoadingSemesters.value = true;
    isLoadingSubjects.value = true;

    // 5. تهيئة متحكمات جديدة للصف الجديد
    _initializeChildControllers(newGrade.id);

    // 6. إعادة إعداد المستمعين للمتحكمات الجديدة
    _setupListeners();
  }

  // 5. باقي دوال إدارة الحالة (State Management Functions)
  void selectSemester(SemesterModel semester) {
    if (selectedSemester.value?.id != semester.id) {
      selectedSemester.value = semester;
      // تحديث متحكم المواد ليجلب المواد الخاصة بهذا الفصل
      subjectController.updateSemesterId(semester.id);
    }
  }

  // (يمكنك إضافة دوال الحذف والإضافة هنا كما في GradeDetailsController القديم)
  // ...
}
