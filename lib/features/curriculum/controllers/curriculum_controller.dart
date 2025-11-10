import 'package:ashil_school/features/grade/controllers/grade_controller.dart';
import 'package:ashil_school/features/grade/models/grade.dart';
import 'package:ashil_school/features/semester/controllers/semester_controller.dart';
import 'package:ashil_school/features/semester/models/semester.dart';
import 'package:ashil_school/features/subject/controllers/subject_controller.dart';
import 'package:ashil_school/features/subject/models/subject.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CurriculumController extends GetxController {
  
  late final GradeController gradeController;

  // [MODIFIED] 1. يجب أن يبدأ كـ null لأنه يعتمد على تحميل غير متزامن
  final Rx<GradeModel?> currentGrade = Rxn<GradeModel>();

  final Rx<SemesterModel?> selectedSemester = Rxn<SemesterModel>();
  final RxList<SemesterModel> semesters = <SemesterModel>[].obs;
  final RxList<SubjectModel> subjects = <SubjectModel>[].obs;
  final RxBool isLoadingSemesters = true.obs;
  final RxBool isLoadingSubjects = true.obs;

  late SemesterController semesterController;
  late SubjectController subjectController;
  final List<Function> _listenerDisposers = [];
  final List<Worker> _gradeListeners = []; // قائمة لتخزين مستمعي الصفوف

  final _storage = GetStorage();
  final String _globalGradeStorageKey = 'last_selected_grade_id';
  
  // [MODIFIED] 2. جعله آمناً ضد Null
  String get _semesterStorageKey =>
      'selected_semester_${currentGrade.value?.id ?? 'none'}';

  CurriculumController() {
    // [FIX] 3. الإصلاح لـ "GradeController not found"
    // نستخدم Get.put() لضمان إنشاء المتحكم إذا لم يكن موجوداً
    gradeController = Get.put(GradeController());
  }

  @override
  void onInit() {
    super.onInit();
    
    // [NEW] 4. الاستماع إلى حالة تحميل الصفوف
    // هذا المستمع يضمن أننا لا نحاول القراءة من gradeController.grades
    // إلا بعد انتهاء تحميلها (أي عندما تكون isLoading false)
    _gradeListeners.add(
      ever(gradeController.isLoading, (bool isLoading) {
        if (!isLoading && currentGrade.value == null) {
          _loadInitialGrade();
        }
      }),
    );
    
    // استدعاء الدالة يدوياً في حال كانت البيانات محملة مسبقاً
    if (!gradeController.isLoading.value) {
      _loadInitialGrade();
    }
  }
  
  @override
  void onClose() {
    // إزالة المستمعين عند إغلاق المتحكم
    for (var listener in _gradeListeners) {
      listener.dispose();
    }
    _disposeListeners();
    // يجب حذف المتحكمات الفرعية النشطة
    if (currentGrade.value != null && currentGrade.value!.id != 'none') {
        final oldGradeId = currentGrade.value!.id;
        Get.delete<SemesterController>(tag: oldGradeId);
        Get.delete<SubjectController>(tag: oldGradeId);
    }
    super.onClose();
  }


  /// [NEW] 5. دالة يتم استدعاؤها *فقط* بعد انتهاء تحميل الصفوف
  void _loadInitialGrade() {
    
    final String? savedGradeId = _storage.read(_globalGradeStorageKey);
    GradeModel? initialGrade;

    if (savedGradeId != null) {
      initialGrade =
          gradeController.grades.firstWhereOrNull((g) => g.id == savedGradeId);
    }

    // إذا لم يوجد محفوظ، اختر الأول
    initialGrade ??= gradeController.grades.firstOrNull;

    if (initialGrade == null) {
      // لا توجد صفوف في النظام (حالة طارئة)
      currentGrade.value = GradeModel(id: 'none', name: 'لا توجد صفوف', order: 0);
    } else {
      // نجاح: تم العثور على الصف (المحفوظ أو الأول)
      currentGrade.value = initialGrade;
      // الآن فقط يمكننا تهيئة المتحكمات الفرعية
      _initializeChildControllers(currentGrade.value!.id);
      _setupListeners();
      _storage.write(_globalGradeStorageKey, currentGrade.value!.id);
    }
  }


  // ... (دالة _initializeChildControllers كما هي) ...
  void _initializeChildControllers(String gradeId) {
    semesterController =
        Get.put(SemesterController(gradeId), tag: gradeId);
    subjectController = Get.put(
        SubjectController(gradeId: gradeId, semesterId: null),
        tag: gradeId);
  }


  // [MODIFIED] 3. دوال مساعدة لتخزين *الفصل*
  Future<void> _saveSelectedSemester(SemesterModel semester) async {
    await _storage.write(_semesterStorageKey, semester.id);
  }

  String? _loadSelectedSemesterId() {
    return _storage.read(_semesterStorageKey);
  }

  // [MODIFIED] 4. دالة لاختيار الفصل المخزن أو الافتراضي (تستخدم المفتاح الجديد)
  void _loadAndSetDefaultSemester(List<SemesterModel> newSemesters) {
    if (newSemesters.isEmpty) {
      selectedSemester.value = null; // لا توجد فصول
      isLoadingSubjects.value = false; // [FIX] إيقاف الدوران إذا لا توجد فصول
      return;
    }

    final savedSemesterId = _loadSelectedSemesterId();
    SemesterModel? semesterToSelect;

    if (savedSemesterId != null) {
      // 1. حاول العثور على الفصل المخزن
      semesterToSelect = newSemesters.firstWhereOrNull((s) => s.id == savedSemesterId);
    }

    // 2. إذا لم تجده، اختر الأول
    semesterToSelect ??= newSemesters.first;
    
    selectSemester(semesterToSelect);
  }


  void _setupListeners() {
    _disposeListeners();

    // الاستماع لقائمة الفصول
    _listenerDisposers.add(
      ever(semesterController.semesters, (List<SemesterModel> newSemesters) {
        semesters.assignAll(newSemesters);
        // [FIX] التأكد من أن الترتيب يعمل حتى لو كانت القيمة null
        semesters.sort((a, b) => (a.order ?? 0).compareTo(b.order ?? 0));
        isLoadingSemesters.value = false;

        // [MODIFIED] 5. استدعاء دالة الاختيار التلقائي
        _loadAndSetDefaultSemester(newSemesters);
      }).call,
    );

    // ... (باقي المستمعين كما هم) ...
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

  // ... (دالة _disposeListeners كما هي) ...
  void _disposeListeners() {
    for (var dispose in _listenerDisposers) {
      dispose();
    }
    _listenerDisposers.clear();
  }


  // [MODIFIED] 6. تعديل دالة changeGrade لتصبح async وتحفظ الصف
  void changeGrade(GradeModel newGrade) async {
    if (newGrade.id == currentGrade.value?.id) return; 

    // [MODIFIED] 6b. التأكد من وجود صف قديم لحذف متحكماته
    if (currentGrade.value != null && currentGrade.value!.id != 'none') {
      final oldGradeId = currentGrade.value!.id;
      _disposeListeners();
      Get.delete<SemesterController>(tag: oldGradeId);
      Get.delete<SubjectController>(tag: oldGradeId);
    }
    
    currentGrade.value = newGrade;
    selectedSemester.value = null;
    semesters.clear();
    subjects.clear();
    isLoadingSemesters.value = true;
    isLoadingSubjects.value = true;
    _initializeChildControllers(newGrade.id);
    _setupListeners(); 
    
    // [NEW] 7. حفظ الصف المختار الجديد في التخزين العام
    await _storage.write(_globalGradeStorageKey, newGrade.id);
  }

  void selectSemester(SemesterModel semester) {
    if (selectedSemester.value?.id != semester.id) {
      selectedSemester.value = semester;
      subjectController.updateSemesterId(semester.id);
      
      // [MODIFIED] 8. حفظ الاختيار الجديد (باستخدام الدالة المساعدة)
      _saveSelectedSemester(semester);
    }
  }
  
  // [MODIFIED] 9. تعديل دالة الحذف
  void deleteSemester(SemesterModel semester) {
    if (_loadSelectedSemesterId() == semester.id) {
      _storage.remove(_semesterStorageKey); // استخدام المفتاح الصحيح
    }
    // ... (الكود الخاص بحذف الفصل فعلياً)
    semesterController.deleteSemester(semester.id); // بافتراض وجود هذه الدالة
  }
}