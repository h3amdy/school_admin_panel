// teacher_permissions_modal.dart

import 'package:ashil_school/features/teacher/controllers/permission_controller.dart';
import 'package:ashil_school/features/teacher/models/permission_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ----------------------------------------------------
// 💡 واجهة منح الصلاحيات المنبثقة (TeacherPermissionsModal)
// ----------------------------------------------------

class TeacherPermissionsModal extends StatelessWidget {
  final String teacherName;
  const TeacherPermissionsModal({super.key, required this.teacherName});

  @override
  Widget build(BuildContext context) {
    // استدعاء المتحكم
    final PermissionController controller = Get.put(PermissionController());

    return Container(
      height: MediaQuery.of(context).size.height * 0.90,
      decoration: const BoxDecoration(
        //  color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildModalHeader(context, teacherName), // العنوان

          Expanded(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Column(
                children: [
                  // 1. إدارة المعلمين
                  _buildGeneralPermissionsTile(
                    controller.teacherPermissions,
                    icon: Icons.people_alt,
                    title: '1. إدارة المعلمين',
                    controller: controller,
                  ),

                  // 2. إدارة الطلاب العامة (معدل)
                  _buildGeneralPermissionsTile(
                    controller.studentPermissions,
                    icon: Icons.school,
                    title: '2. إدارة الطلاب العامة',
                    controller: controller,
                  ),

                  // 3. إدارة المنهج (مفصّل حسب طلبك)
                  _buildCurriculumPermissionsTile(controller),

                  // 4. صلاحية الإشراف على الصفوف
                  _buildClassSupervisionTile(controller),
                ],
              ),
            ),
          ),

          // الأزرار السفلية
          _buildActionButtons(controller),
        ],
      ),
    );
  }

  // 💡 عنوان الواجهة
  Widget _buildModalHeader(BuildContext context, String name) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      decoration: const BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              'منح صلاحيات للمعلم: $name',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  // 💡 قسم الصلاحيات العامة (معلمين وطلاب)
  Widget _buildGeneralPermissionsTile(
    RxList<PermissionItem> permissions, {
    required IconData icon,
    required String title,
    required PermissionController controller,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Obx(() => ExpansionTile(
            // Obx هنا للتفاعل مع تحديث الصلاحيات
            tilePadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
            leading: Icon(icon, color: Colors.blueAccent),
            title: Text(title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                )),
            children: permissions.asMap().entries.map((entry) {
              int index = entry.key;
              PermissionItem item = entry.value;
              return _buildCheckboxListTile(
                title: item.title,
                description: item.description, // توضيح الصلاحية
                value: item.isEnabled,
                onChanged: (val) =>
                    controller.togglePermission(permissions, index, val),
              );
            }).toList(),
          )),
    );
  }

  // 💡 قسم صلاحيات المنهج (مفصّل)
  Widget _buildCurriculumPermissionsTile(PermissionController controller) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ExpansionTile(
        leading: const Icon(Icons.book, color: Colors.teal),
        title: const Text('3. إدارة المنهج العامة',
            style: TextStyle(
              fontWeight: FontWeight.w600,
            )),
        children: controller.curriculumPermissions.keys.map((key) {
          // استخدام ExpansionTile متداخلة (Nested) لتحسين التنظيم
          return Obx(() => ExpansionTile(
                tilePadding: const EdgeInsets.only(left: 10, right: 16),
                leading: const Icon(Icons.subdirectory_arrow_right,
                    size: 20, color: Colors.grey),
                title: Text(key,
                    style: const TextStyle(fontWeight: FontWeight.w500)),
                children: controller.curriculumPermissions[key]!
                    .asMap()
                    .entries
                    .map((entry) {
                  int index = entry.key;
                  PermissionItem item = entry.value;
                  return _buildCheckboxListTile(
                    title: item.title,
                    description: item.description,
                    value: item.isEnabled,
                    onChanged: (val) => controller.togglePermission(
                        controller.curriculumPermissions[key]!, index, val),
                    color: Colors.teal,
                  );
                }).toList(),
              ));
        }).toList(),
      ),
    );
  }

  // 💡 تصميم قسم الإشراف على الصفوف
  Widget _buildClassSupervisionTile(PermissionController controller) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Obx(() => ExpansionTile(
            tilePadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
            leading: const Icon(Icons.class_, color: Colors.orange),
            title: const Text('4. إشراف وإدارة الصفوف الخاصة',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                )),
            children: [
              // مربع اختيار تفعيل الإشراف
              _buildCheckboxListTile(
                title: 'منح صلاحية الإشراف على صفوف محددة',
                description:
                    'الصلاحية في إضافة طلاب لهذه الصفوف والتحكم في المنهج التابع لها.',
                value: controller.hasClassSupervision.value,
                onChanged: controller.toggleSupervision,
                color: Colors.orange,
              ),

              // قائمة اختيار الصفوف المتعددة
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('اختر الصفوف التي يشرف عليها المعلم:',
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 5),
                    // عرض قائمة الاختيار المتعددة بشكل ديناميكي
                    ...controller.availableClasses.map((className) {
                      bool isSelected =
                          controller.selectedClasses.contains(className);
                      return CheckboxListTile(
                        title: Text(className),
                        value: isSelected,
                        onChanged: controller.hasClassSupervision
                                .value // التعطيل بناءً على حالة الإشراف
                            ? (val) =>
                                controller.toggleClassSelection(className, val)
                            : null,
                        activeColor: Colors.orange,
                        tileColor: !controller.hasClassSupervision.value
                            ? Colors.grey[100]
                            : null,
                      );
                    }).toList(),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  // 💡 مربع الاختيار مع التوضيح
  Widget _buildCheckboxListTile({
    required String title,
    required String description,
    required bool value,
    required ValueChanged<bool?> onChanged,
    Color color = Colors.green,
  }) {
    return CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      title: Text(title,
          style: TextStyle(color: color, fontWeight: FontWeight.w600)),
      subtitle: Text(description,
          style: const TextStyle(
              fontSize: 12, color: Colors.black54)), // توضيح الصلاحية
      value: value,
      onChanged: onChanged,
      activeColor: color,
    );
  }

  // 💡 أزرار الإجراءات السفلية
  Widget _buildActionButtons(PermissionController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      decoration: BoxDecoration(
        // color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[300]!, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('إلغاء', style: TextStyle(fontSize: 16)),
          ),
          const SizedBox(width: 15),
          ElevatedButton.icon(
            onPressed: controller.savePermissions,
            icon: const Icon(Icons.save),
            label: const Text('حفظ الصلاحيات'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              textStyle:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
