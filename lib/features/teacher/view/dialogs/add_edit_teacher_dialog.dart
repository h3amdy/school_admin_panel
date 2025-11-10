import 'package:ashil_school/Utils/constants/colors.dart';
import 'package:ashil_school/Utils/constants/sizes.dart';
import 'package:ashil_school/Utils/custom_dilog/custom_dialog.dart';
import 'package:ashil_school/Utils/validators/validation.dart';
import 'package:ashil_school/common/widgets/coustom_text_field.dart';
import 'package:ashil_school/features/teacher/controllers/teacher_controller.dart';
import 'package:ashil_school/features/teacher/view/permissions_screen.dart';
import 'package:ashil_school/features/teacher/view/subjects_assignment_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ashil_school/models/user_model/user.dart';

void showAddEditTeacherDialog(BuildContext context,
    {User? teacher, required TeacherController controller}) {
  final formKey = GlobalKey<FormState>();
  final fullNameController =
      TextEditingController(text: teacher?.fullName ?? '');
  // ✅ إعادة حقل اسم المستخدم
  final usernameController =
      TextEditingController(text: teacher?.username ?? '');
  final phoneController = TextEditingController(text: teacher?.phone ?? '');
  final specializationController =
      TextEditingController(text: teacher?.specialization ?? '');
  final passwordController = TextEditingController();
  final selectedSubjects = RxList<String>();
  selectedSubjects.addAll(teacher?.assignedSubjects ?? []);

  Get.dialog(
    CustomDialog(
      title: teacher == null ? "إضافة معلم جديد" : "تعديل بيانات المعلم",
      body: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              fit: FlexFit.loose,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ✅ حقل "اسم المعلم" (اختياري)
                    CustomTextField(
                        controller: fullNameController,
                        label: "اسم المعلم (اجباري)",
                        validator: (value) => KValidator.validateEmptyText(
                            fieldName: "اسم المعلم", value: value)),
                    const SizedBox(height: KSizes.spaceBewItems),

                    // ✅ حقل "اسم المستخدم" (إجباري)
                    CustomTextField(
                      controller: usernameController,
                      label: "اسم المستخدم (إجباري)",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "يجب إدخال اسم المستخدم.";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: KSizes.spaceBewItems),

                    // ✅ حقل كلمة السر
                    CustomTextField(
                      controller: passwordController,
                      label: teacher == null
                          ? "كلمة السر (إجباري)"
                          : "كلمة السر الجديدة (اختياري)",
                      isPassword: true,
                      validator: (value) {
                        if (teacher == null &&
                            (value == null || value.isEmpty)) {
                          return "يجب إدخال كلمة السر.";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: KSizes.spaceBewItems),

                    // ✅ حقل رقم الهاتف
                    CustomTextField(
                      controller: phoneController,
                      label: "رقم الهاتف (اختياري)",
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: KSizes.spaceBewItems),

                    // ✅ حقل التخصص
                    CustomTextField(
                      controller: specializationController,
                      label: "التخصص (اختياري)",
                    ),
                    const SizedBox(height: KSizes.spaceBewItems),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "المواد المسندة:",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(() => OutlinedButton.icon(
                          onPressed: () async {
                            await Get.dialog(
                              SubjectsAssignmentDialog(
                                initialSelectedSubjectIds:
                                    selectedSubjects.toList(),
                                onSave: (newSelectedIds) {
                                  selectedSubjects.assignAll(newSelectedIds);
                                },
                              ),
                            );
                          },
                          icon: const Icon(Icons.edit_note),
                          label: Text(
                            selectedSubjects.isEmpty
                                ? "اختر المواد"
                                : "${selectedSubjects.length} مادة مختارة",
                          ),
                        )),

                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                        onPressed: () => showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              useSafeArea: true,
                              builder: (context) =>
                                  const TeacherPermissionsModal(
                                teacherName: "أحمد علي",
                              ),
                            ),
                        label: Text("منح الصلاحيات"),
                        icon: const Icon(Icons.perm_identity))
                  ],
                ),
              ),
            ),
            const SizedBox(height: KSizes.spaceBewItems),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      side: BorderSide(color: KColors.warning)),
                  onPressed: () => Get.back(),
                  child: const Text("إلغاء"),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      final fullName = fullNameController.text.trim();
                      final username = usernameController.text.trim();
                      final phone = phoneController.text.trim();
                      final specialization =
                          specializationController.text.trim();
                      final password = passwordController.text.trim();

                      if (teacher == null) {
                        controller.addTeacher(
                          username: username,
                          password: password,
                          fullName: fullName,
                          phone: phone,
                          specialization: specialization,
                          assignedSubjects: selectedSubjects.toList(),
                        );
                      } else {
                        controller.updateTeacher(
                          teacher.id,
                          username: username,
                          fullName: fullName,
                          phone: phone,
                          specialization: specialization,
                          assignedSubjects: selectedSubjects.toList(),
                          password: password.isNotEmpty ? password : null,
                        );
                      }
                      Get.back();
                    }
                  },
                  child: Text(teacher == null ? "إضافة" : "حفظ"),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
