import 'package:ashil_school/Utils/helpers/loaders/loaders.dart';
import 'package:ashil_school/data/repositories/local/lesson_local_repository.dart';
import 'package:ashil_school/features/lesson/controllers/lesson_controller.dart';
import 'package:ashil_school/features/lesson/models/lesson.dart';
import 'package:ashil_school/features/lesson/view/add_edit_lesson_page.dart';
import 'package:ashil_school/features/subject/controllers/subject_stats_controller.dart'; // [NEW] 1. إضافة الإمبورت
import 'package:ashil_school/features/subject/models/subject.dart';
import 'package:ashil_school/features/unit/controllers/unit_controller.dart';
import 'package:ashil_school/features/unit/models/unit.dart';
import 'package:ashil_school/features/unit/view/dialog/unit_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubjectDetailsController extends GetxController {
  final SubjectModel subject;

  late final UnitController unitController;
  late final LessonLocalRepository _lessonRepo;

  final RxBool isLoadingUnits = true.obs;
  final RxBool isLoadingLessons = true.obs;
  final RxBool isProcessingLesson = false.obs;

  final RxList<UnitModel> units = <UnitModel>[].obs;
  final RxList<LessonModel> allLessons = <LessonModel>[].obs;
  final RxList<LessonModel> filteredLessons = <LessonModel>[].obs;

  final TextEditingController searchController = TextEditingController();
  final RxList<UnitModel> filterUnits = <UnitModel>[].obs;

  final RxBool _isLessonsLoadingLock = false.obs;
// [جديد] 2. إضافة ذاكرة تخزين (cache) لمتحكمات الدروس
  final Map<String, LessonController> _lessonControllers = {};
  SubjectDetailsController(this.subject);

  @override
  void onInit() {
    super.onInit();
    // ... (الكود كما هو) ...
    unitController =
        Get.put(UnitController(subjectId: subject.id), tag: subject.id);
    _lessonRepo = LessonLocalRepository();

    searchController.addListener(_onSearchChanged);
    ever(unitController.units, _onUnitsLoaded);
    ever(filterUnits, (_) => applyFilters());

    unitController.fetchUnits();
  }

  @override
  void onClose() {
    // ... (الكود كما هو) ...
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    Get.delete<UnitController>(tag: subject.id);
     // [جديد] 3. تنظيف جميع متحكمات الدروس عند إغلاق الصفحة
    _lessonControllers.forEach((key, controller) {
      Get.delete<LessonController>(tag: 'lesson_${subject.id}_$key');
    });
    _lessonControllers.clear();
    super.onClose();
  }

  // --- دوال تحميل البيانات ---
  // ... (دوال _onUnitsLoaded, loadAllLessons, _onSearchChanged, applyFilters, toggleUnitFilter, clearUnitFilters كما هي) ...
  void _onUnitsLoaded(List<UnitModel> newUnits) {
    units.assignAll(newUnits);
    units.sort((a, b) => a.order?.compareTo(b.order ?? 9999) ?? -1);
    isLoadingUnits.value = false;
    loadAllLessons(); // استدعاء الدالة
  }

  Future<void> loadAllLessons() async {
    if (_isLessonsLoadingLock.value) return;

    Future.microtask(() => isLoadingLessons.value = true);
    _isLessonsLoadingLock.value = true;
    allLessons.clear();

    try {
      for (final unit in units) {
        final unitLessons = await _lessonRepo.getAllLessonsByUnitId(unit.id);
        allLessons.addAll(unitLessons);
      }
      allLessons.sort((a, b) => (a.order ?? 0).compareTo(b.order ?? 0));
    } catch (e) {
      KLoaders.error(title: "خطأ", message: "فشل تحميل الدروس: $e");
    } finally {
      isLoadingLessons.value = false;
      applyFilters();
      _isLessonsLoadingLock.value = false;
    }
  }

  void _onSearchChanged() {
    applyFilters();
  }

  void applyFilters() {
    List<LessonModel> tempLessons = List.from(allLessons);
    final query = searchController.text.trim().toLowerCase();
    if (query.isNotEmpty) {
      tempLessons = tempLessons.where((lesson) {
        return lesson.title.toLowerCase().contains(query);
      }).toList();
    }
    if (filterUnits.isNotEmpty) {
      final filterIds = filterUnits.map((u) => u.id).toSet();
      tempLessons = tempLessons.where((lesson) {
        return filterIds.contains(lesson.unitId);
      }).toList();
    }
    filteredLessons.assignAll(tempLessons);
  }

  void toggleUnitFilter(UnitModel unit, bool isSelected) {
    if (isSelected) {
      if (!filterUnits.any((u) => u.id == unit.id)) {
        filterUnits.add(unit);
      }
    } else {
      filterUnits.removeWhere((u) => u.id == unit.id);
    }
  }

  void clearUnitFilters() {
    filterUnits.clear();
  }
 // [جديد] 4. دالة مساعدة لجلب أو إنشاء متحكم درس لوحدة معينة
  LessonController getControllerForUnit(String unitId) {
    // التأكد من أن المتحكم ينتمي لهذه المادة
    final tag = 'lesson_${subject.id}_$unitId';
    if (_lessonControllers.containsKey(tag)) {
      return _lessonControllers[tag]!;
    } else {
      final newController = Get.put(
        LessonController(unitId: unitId),
        tag: tag, // وسم فريد يضمن عدم التضارب
      );
      _lessonControllers[tag] = newController;
      return newController;
    }
  }

  // --- [NEW] 2. دالة مساعدة لتحديث الإحصائيات ---
  void refreshStatsOnCurriculumPage() {
    // التحقق مما إذا كان متحكم الإحصائيات لا يزال موجوداً في الذاكرة
    if (Get.isRegistered<SubjectStatsController>(tag: subject.id)) {
      final statsController = Get.find<SubjectStatsController>(tag: subject.id);
      statsController.refreshStats();
    }
  }

  // --- دوال إدارة بيانات الدروس (CRUD) ---


  // [تعديل] 6. استبدال الحوار القديم بالصفحة الجديدة
  void showAddEditLessonDialog(BuildContext context, {LessonModel? lesson}) {
    // int? nextOrder; // لم نعد بحاجة لهذا، المتحكم الجديد يحسبه
    // if (lesson == null) {
    //   nextOrder = allLessons.isEmpty ? 1 : (allLessons.last.order ?? 0) + 1;
    // }

    Get.to(() => AddEditLessonPage(
          subjectController: this,
          lessonToEdit: lesson,
        ));
  }

  // [MODIFIED] 3. تعديل دالة إضافة الوحدة لتستدعي التحديث
  void showAddEditUnitDialog(BuildContext context,
      {VoidCallback? onUnitAdded}) {
    Get.dialog(UnitDialog(
      unitController: unitController,
      unitToEdit: null,
      onUnitAddedCallback: () {
        onUnitAdded?.call();
        refreshStatsOnCurriculumPage(); // [NEW] تحديث الإحصائيات
      },
    ));
  }

  Future<void> deleteLesson(LessonModel lesson) async {
    final lessonController = Get.put(LessonController(unitId: lesson.unitId),
        tag: "delete_${lesson.id}");
    try {
      await lessonController.deleteLesson(lesson.id);
      await loadAllLessons();
      refreshStatsOnCurriculumPage(); // [NEW] تحديث الإحصائيات

      Get.delete<LessonController>(tag: "delete_${lesson.id}");
    } catch (e) {
      KLoaders.error(title: "خطأ", message: "فشل حذف الدرس: $e");
    }
  }
}
