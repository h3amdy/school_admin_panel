import 'package:ashil_school/Utils/custom_dilog/show_add_dialog_options.dart';
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

class SubjectDetailsController extends GetxController {
  final SubjectModel subject;

  late final UnitController unitController;
  // lessonController سيتم تهيئته عند اختيار الوحدة
  // لا نحتاج لتعريفه هنا مباشرة كـ late final لأنه يتم Get.put/Get.find بناءً على الوحدة المختارة.

  final RxBool isLoadingUnits = true.obs;
  final RxBool isLoadingLessons = true.obs;
  final RxList<UnitModel> units = <UnitModel>[].obs;
  final Rx<UnitModel?> selectedUnit = Rxn<UnitModel>();
  final RxList<LessonModel> lessons = <LessonModel>[].obs;
  final Rx<LessonModel?> selectedLesson = Rxn<LessonModel>();

  SubjectDetailsController(this.subject);

  @override
  void onInit() {
    super.onInit();

    unitController =
        Get.put(UnitController(subjectId: subject.id!), tag: subject.id);

    ever(unitController.units, (List<UnitModel> newUnits) {
      units.assignAll(newUnits);
      units.sort((a, b) => a.order?.compareTo(b.order ?? 9999) ?? -1);
      isLoadingUnits.value = false;

      // تحديث الوحدة المختارة من unitController.selectedUnit.value
      // هذا يضمن أن يكون selectedUnit.value في SubjectDetailsController
      // متوافقًا مع selectedUnit في UnitController
      if (unitController.selectedUnit.value != null &&
          selectedUnit.value?.id != unitController.selectedUnit.value!.id) {
        selectUnit(unitController.selectedUnit.value!);
      } else if (newUnits.isEmpty) {
        // إذا لم تكن هناك وحدات، امسح الوحدة المختارة والدروس
        selectedUnit.value = null;
        lessons.clear();
        selectedLesson.value = null;
      }
      // إذا كانت newUnits غير فارغة وselectedUnit.value لا يزال null،
      // فإن المنطق داخل selectUnit (إذا تم استدعاؤها مع newUnits.first) سيعتني بذلك.
    });

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
      if (unit != null) {
        final currentLessonController =
            Get.put(LessonController(unitId: unit.id), tag: unit.id);

        lessons.clear();
        selectedLesson.value = null;

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
        });

        // استمع مباشرة لتغييرات selectedLesson في LessonController
        ever(currentLessonController.selectedLesson, (LessonModel? lesson) {
          if (selectedLesson.value?.id != lesson?.id) {
            // تجنب التحديث المزدوج
            selectedLesson.value = lesson;
          }
        });

        ever(currentLessonController.isLoading, (bool loading) {
          isLoadingLessons.value = loading;
        });

        currentLessonController.fetchLessons();
      } else {
        lessons.clear();
        selectedLesson.value = null;
        isLoadingLessons.value = false;
      }
    });

    // ✅ التعديل هنا ليتوافق مع اسم الدالة في UnitController
    unitController.fetchUnits();
  }

  @override
  void onClose() {
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
    }
  }

  void selectLesson(LessonModel lesson) {
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
    unitController.deleteUnit(unitId);
  }

  void deleteLesson(String lessonId) {
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

  void showAddDialogOptions(BuildContext context) {
    showTwoOptionDialog(
      context: context,
      firstIcon: Icons.library_books,
      firstLabel: "إضافة وحدة",
      firstOnTap: () {
        _showAddEditUnitDialog(context);
      },
      secondIcon: Icons.menu_book,
      secondLabel: "إضافة درس",
      secondOnTap: () {
        showAddEditLessonDialog(null);
      },
      isShowingAdd: RxBool(false),
    );
  }

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

  void _showAddEditUnitDialog(BuildContext context, {UnitModel? unit}) {
    Get.dialog(UnitDialog(
      unitController: unitController,
      unitToEdit: unit,
    ));
  }
}
