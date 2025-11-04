// permission_controller.dart

import 'package:ashil_school/features/teacher/models/permission_model.dart';
import 'package:get/get.dart';

class PermissionController extends GetxController {
  // 1. إدارة المعلمين
  var teacherPermissions = <PermissionItem>[
    PermissionItem(
        key: 'teacher_view',
        title: 'معاينة',
        description: 'عرض قائمة المعلمين وكامل تفاصيلهم.'),
    PermissionItem(
        key: 'teacher_add',
        title: 'إضافة',
        description: 'إضافة معلمين جدد إلى النظام.'),
    PermissionItem(
        key: 'teacher_delete',
        title: 'حذف',
        description: 'إزالة حسابات المعلمين بشكل دائم.'),
  ].obs;

  // 2. إدارة الطلاب العامة
  var studentPermissions = <PermissionItem>[
    PermissionItem(
        key: 'student_view',
        title: 'معاينة',
        description: 'عرض قائمة الطلاب وتفاصيلهم (عام).'),
    PermissionItem(
        key: 'student_crud',
        title: 'إضافة/تعديل/حذف',
        description: 'صلاحية التعديل على بيانات الطلاب وحذفهم وإضافة جديد.'),
  ].obs;

  // 3. إدارة المنهج (مفصّل حسب طلبك)
  // كل مكون من المنهج لديه صلاحيتان: معاينة، و (إضافة وتعديل وحذف)
  var curriculumPermissions = <String, RxList<PermissionItem>>{
    'الصفوف': <PermissionItem>[
      PermissionItem(
          key: 'class_view',
          title: 'معاينة',
          description: 'عرض الصفوف (مثلاً: الصف الأول).'),
      PermissionItem(
          key: 'class_crud',
          title: 'إضافة/تعديل/حذف',
          description: 'إدارة إنشاء وحذف وتعديل الصفوف.'),
    ].obs,
    'الفصول': <PermissionItem>[
      PermissionItem(
          key: 'section_view',
          title: 'معاينة',
          description: 'عرض الفصول (الشعب) التابعة للصفوف.'),
      PermissionItem(
          key: 'section_crud',
          title: 'إضافة/تعديل/حذف',
          description: 'إدارة الفصول (الشعب).'),
    ].obs,
    'المواد والوحدات والدروس': <PermissionItem>[
      PermissionItem(
          key: 'content_view',
          title: 'معاينة',
          description: 'عرض محتوى المنهج (المواد، الوحدات، الدروس).'),
      PermissionItem(
          key: 'content_crud',
          title: 'إضافة/تعديل/حذف',
          description: 'إدارة محتوى المنهج بالكامل.'),
    ].obs,
  }.obs;

  // 4. صلاحية الإشراف على الصفوف
  var hasClassSupervision = false.obs;
  var selectedClasses = <String>[].obs;
  final List<String> availableClasses = [
    'الصف الأول (أ)',
    'الصف الأول (ب)',
    'الصف الثاني (ج)',
  ];

  // دالة لتحديث حالة صلاحية معينة
  void togglePermission(List<PermissionItem> list, int index, bool? value) {
    if (value != null) {
      list[index].isEnabled = value;
      //list.refresh(); // إجبار GetX على إعادة بناء الـ UI
    }
  }

  // دالة لتحديث صلاحية الإشراف
  void toggleSupervision(bool? value) {
    if (value != null) {
      hasClassSupervision.value = value;
      if (!value) {
        selectedClasses.clear(); // مسح الاختيار عند التعطيل
      }
    }
  }

  // دالة لتحديث الصفوف المختارة
  void toggleClassSelection(String className, bool? value) {
    if (value == true) {
      selectedClasses.add(className);
    } else {
      selectedClasses.remove(className);
    }
  }

  // دالة الحفظ الرئيسية
  void savePermissions() {
    // يمكنك هنا إرسال البيانات إلى API أو قاعدة البيانات
    Get.snackbar(
      'نجاح',
      'تم حفظ صلاحيات المعلم بنجاح!',
    );
    Get.back(); // إغلاق الـ modal
  }
}
