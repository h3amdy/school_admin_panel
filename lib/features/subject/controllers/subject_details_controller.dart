import 'package:ashil_school/Utils/helpers/loaders/loaders.dart';
import 'package:ashil_school/features/lesson/controller/lesson_controller.dart';
import 'package:ashil_school/features/lesson/models/lesson.dart';
import 'package:ashil_school/features/lesson/view/dialogs/lesson_dialog.dart';
import 'package:ashil_school/features/subject/models/subject.dart';
import 'package:ashil_school/features/unit/controllers/unit_controller.dart'; // تأكد من المسار
import 'package:ashil_school/features/unit/models/unit.dart';
import 'package:ashil_school/features/unit/view/dialog/unit_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart'; // [NEW] 1. إضافة GetStorage

class SubjectDetailsController extends GetxController {
  final SubjectModel subject;

  late final UnitController unitController;
  // ... (باقي المتغيرات)

  final RxBool isLoadingUnits = true.obs;
  final RxBool isLoadingLessons = true.obs;
  final RxList<UnitModel> units = <UnitModel>[].obs;
  final Rx<UnitModel?> selectedUnit = Rxn<UnitModel>();
  final RxList<LessonModel> lessons = <LessonModel>[].obs;
  final Rx<LessonModel?> selectedLesson = Rxn<LessonModel>();

  final List<Worker> _lessonListeners = [];
  
  // [NEW] 2. إضافة GetStorage
  final _storage = GetStorage();
  // دالة مساعدة للحصول على مفتاح تخزين فريد لهذه المادة
  String get _storageKey => 'selected_unit_${subject.id}';


  SubjectDetailsController(this.subject);

  @override
  void onInit() {
    super.onInit();

    unitController =
        Get.put(UnitController(subjectId: subject.id), tag: subject.id);

    ever(unitController.units, (List<UnitModel> newUnits) {
      units.assignAll(newUnits);
      units.sort((a, b) => a.order?.compareTo(b.order ?? 9999) ?? -1);
      isLoadingUnits.value = false;

      // [MODIFIED] 3. استدعاء دالة الاختيار التلقائي بدلاً من المنطق القديم
      _loadAndSetDefaultUnit(newUnits);
    });

    // ... (باقي المستمعين كما هم) ...
    // استمع مباشرة لتغييرات selectedUnit في UnitController
    ever(unitController.selectedUnit, (UnitModel? unit) {
      if (selectedUnit.value?.id != unit?.id) {
        // تجنب التحديث المزدوج إذا كان هو نفسه
        selectedUnit.value = unit;
      }
    });

    ever(unitController.isLoading, (bool loading) {
      isLoadingUnits.value = loading;
    });

    ever(selectedUnit, (UnitModel? unit) {
      // [FIX] 2. حذف المستمعين القدامى قبل إضافة مستمعين جدد
      _disposeLessonListeners();

      if (unit != null) {
        final currentLessonController =
            Get.put(LessonController(unitId: unit.id), tag: unit.id);

        lessons.clear();
        selectedLesson.value = null;
        
        // [FIX] 3. إضافة المستمعين الجدد إلى القائمة ليتم تتبعهم
        _lessonListeners.add(
          ever(currentLessonController.lessons, (List<LessonModel> newLessons) {
            lessons.assignAll(newLessons);
            lessons.sort((a, b) => a.order?.compareTo(b.order ?? 9999) ?? -1);
            isLoadingLessons.value = false;

            // تحديث الدرس المختار من currentLessonController.selectedLesson.value
            if (currentLessonController.selectedLesson.value != null &&
                selectedLesson.value?.id !=
                    currentLessonController.selectedLesson.value!.id) {
              selectLesson(currentLessonController.selectedLesson.value!);
            } else if (newLessons.isEmpty) {
              selectedLesson.value = null;
            }
          }),
        );
        
        // [FIX] 4. إضافة المستمعين الجدد إلى القائمة
        _lessonListeners.add(
          // استمع مباشرة لتغييرات selectedLesson في LessonController
          ever(currentLessonController.selectedLesson, (LessonModel? lesson) {
            if (selectedLesson.value?.id != lesson?.id) {
              // تجنب التحديث المزدوج
              selectedLesson.value = lesson;
            }
          }),
        );
        
        // [FIX] 5. إضافة المستمعين الجدد إلى القائمة
        _lessonListeners.add(
          ever(currentLessonController.isLoading, (bool loading) {
            isLoadingLessons.value = loading;
          }),
        );
        
        // [FIX] 6. التأكد من أن LessonController لا يجلب البيانات في onInit
        // إذا كان يجلبها في onInit، احذف هذا السطر.
        // إذا كان لا يجلبها في onInit، فهذا السطر ضروري.
        // بناءً على الكود الذي أرسلته، LessonController لا يجلب البيانات في onInit
        // لذا هذا السطر ضروري.
        currentLessonController.fetchLessons(); 
      } else {
        lessons.clear();
        selectedLesson.value = null;
        isLoadingLessons.value = false;
      }
    });


    unitController.fetchUnits();
  }
  
  // [NEW] 4. دوال مساعدة للتخزين
  Future<void> _saveSelectedUnit(UnitModel unit) async {
    await _storage.write(_storageKey, unit.id);
  }

  String? _loadSelectedUnitId() {
    return _storage.read(_storageKey);
  }

  // [NEW] 5. دالة لاختيار الوحدة المخزنة أو الافتراضية
  void _loadAndSetDefaultUnit(List<UnitModel> newUnits) {
    if (newUnits.isEmpty) {
      selectedUnit.value = null; // لا توجد وحدات
      return;
    }

    final savedUnitId = _loadSelectedUnitId();
    UnitModel? unitToSelect;

    if (savedUnitId != null) {
      // 1. حاول العثور على الوحدة المخزنة
      unitToSelect = newUnits.firstWhereOrNull((u) => u.id == savedUnitId);
    }

    // 2. إذا لم تجدها (أو لم تكن مخزنة)، اختر الأولى
    unitToSelect ??= newUnits.first;
    
    // استدعاء selectUnit ليقوم بتشغيل باقي المنطق (تحميل الدروس، الخ)
    selectUnit(unitToSelect);
  }


  // ... (دالة _disposeLessonListeners كما هي) ...
  // [FIX] 7. دالة لحذف وإفراغ قائمة المستمعين
  void _disposeLessonListeners() {
    for (var listener in _lessonListeners) {
      listener.dispose();
    }
    _lessonListeners.clear();
  }


  @override
  void onClose() {
    // [FIX] 8. التأكد من حذف المستمعين عند إغلاق الصفحة
    _disposeLessonListeners(); 
    Get.delete<UnitController>(tag: subject.id);
    if (selectedUnit.value != null &&
        Get.isRegistered<LessonController>(tag: selectedUnit.value!.id)) {
      Get.delete<LessonController>(tag: selectedUnit.value!.id);
    }
    super.onClose();
  }

  void selectUnit(UnitModel unit) {
    if (selectedUnit.value?.id != unit.id) {
      if (selectedUnit.value != null &&
          Get.isRegistered<LessonController>(tag: selectedUnit.value!.id)) {
        Get.delete<LessonController>(tag: selectedUnit.value!.id);
      }
      selectedUnit.value = unit;
      selectedLesson.value = null; // إعادة تعيين الدرس المختار عند تغيير الوحدة
      // يجب أيضًا تحديث selectedUnit في UnitController لتظل متزامنة
      unitController.selectedUnit.value = unit;
      
      // [NEW] 6. حفظ الاختيار الجديد عند تغييره يدوياً
      _saveSelectedUnit(unit);
    }
  }

  void selectLesson(LessonModel lesson) {
    // ... (الكود كما هو) ...
    selectedLesson.value = lesson;
    // يجب أيضًا تحديث selectedLesson في LessonController لتظل متزامنة
    if (selectedUnit.value != null &&
        Get.isRegistered<LessonController>(tag: selectedUnit.value!.id)) {
      Get.find<LessonController>(tag: selectedUnit.value!.id)
          .selectedLesson
          .value = lesson;
    }
  }

  void deleteUnit(String unitId) {
    // [NEW] 7. حذف المفتاح من التخزين إذا تم حذف الوحدة
    if (_loadSelectedUnitId() == unitId) {
      _storage.remove(_storageKey);
    }
    unitController.deleteUnit(unitId);
  }

  void deleteLesson(String lessonId) {
    // ... (الكود كما هو) ...
    if (selectedUnit.value != null &&
        Get.isRegistered<LessonController>(tag: selectedUnit.value!.id)) {
      Get.find<LessonController>(tag: selectedUnit.value!.id)
          .deleteLesson(lessonId);
    } else {
      KLoaders.error(
          title: "خطأ",
          message: "لا يمكن حذف الدرس. الوحدة غير محددة أو المتحكم غير موجود.");
    }
  }

  // ... (باقي الدوال كما هي) ...
  
  void showAddEditLessonDialog(LessonModel? lesson) {
    if (selectedUnit.value == null) {
      KLoaders.error(
          title: "خطأ", message: "يجب تحديد وحدة دراسية أولاً لإضافة درس.");
      return;
    }

    if (!Get.isRegistered<LessonController>(tag: selectedUnit.value!.id)) {
      KLoaders.error(
          title: "خطأ",
          message:
              "لا يوجد متحكم للدروس للوحدة المختارة. يرجى إعادة تحديد الوحدة.");
      return;
    }

    final currentLessonController =
        Get.find<LessonController>(tag: selectedUnit.value!.id);
    Get.dialog(LessonDialog(
        lessonController: currentLessonController,
        lessonToEdit: lesson,
        unitName:selectedUnit.value?.name??""
    ));
  }

  // [MODIFIED] - تم جعل هذه الدالة عامة (public)
  void showAddEditUnitDialog(BuildContext context, {UnitModel? unit}) {
    Get.dialog(UnitDialog(
      unitController: unitController,
      unitToEdit: unit,
    ));
  }
}