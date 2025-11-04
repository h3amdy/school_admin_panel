// // lib/UI/subject/subjects_ui.dart
// import 'package:ashil_school/features/subject/controllers/subject_controller.dart';
// import 'package:ashil_school/features/subject/views/subject_details_ui.dart';
// import 'package:ashil_school/features/unit/view/units_page.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:ashil_school/features/subject/models/subject.dart';

// class SubjectsPage extends StatelessWidget {
//   final String gradeId;
//   final String semesterId;
//   final String semesterName;
//   final SubjectController controller;

//   SubjectsPage({
//     super.key,
//     required this.gradeId,
//     required this.semesterId,
//     required this.semesterName,
//   })  : controller = Get.put(
//             SubjectController(gradeId: gradeId, semesterId: semesterId));

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("مواد فصل: $semesterName"),
//         centerTitle: true,
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }
//         if (controller.error.value != null) {
//           return Center(
//             child: Text(
//               controller.error.value!,
//               style: theme.textTheme.titleMedium?.copyWith(
//                 color: theme.colorScheme.error,
//               ),
//             ),
//           );
//         }

//         final subjects = controller.subjects;
//         if (subjects.isEmpty) {
//           return const Center(child: Text("لا يوجد مواد لهذا الفصل."));
//         }

//         return ListView.builder(
//           itemCount: subjects.length,
//           itemBuilder: (context, index) {
//             final subject = subjects[index];
//             return Card(
//               child: ListTile(
//                 onTap: () => Get.to(SubjectDetailsPage(
//                   subject: subject,
//                 )),
//                 title: Text(subject.name),
//                 trailing: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     IconButton(
//                       icon:
//                           const Icon(Icons.class_outlined, color: Colors.blue),
//                       onPressed: () {
//                         // الانتقال إلى صفحة الوحدات
//                         Get.to(() => UnitsPage(
//                             subjectId: subject.id!, subjectName: subject.name));
//                       },
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.edit),
//                       onPressed: () => _showAddEditDialog(context, subject),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.delete, color: Colors.red),
//                       onPressed: () => controller.deleteSubject(subject.id!),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       }),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => _showAddEditDialog(context, null),
//         tooltip: "إضافة مادة جديدة",
//         child: const Icon(Icons.add),
//       ),
//     );
//   }

//   void _showAddEditDialog(BuildContext context, SubjectModel? subject) {
//     final nameController = TextEditingController(text: subject?.name ?? "");
//     Get.dialog(
//       AlertDialog(
//         title: Text(subject == null ? "إضافة مادة جديدة" : "تعديل المادة"),
//         content: TextField(
//           controller: nameController,
//           decoration: const InputDecoration(labelText: "اسم المادة"),
//         ),
//         actions: [
//           TextButton(
//             child: const Text("إلغاء"),
//             onPressed: () => Get.back(),
//           ),
//           ElevatedButton(
//             child: Text(subject == null ? "إضافة" : "حفظ"),
//             onPressed: () {
//               final name = nameController.text.trim();
//               if (name.isNotEmpty) {
//                 if (subject == null) {
//                   controller.addSubject(name: name);
//                 } else {
//                   controller.updateSubject(subject.id!, name: name);
//                 }
//                 Get.back();
//               } else {
//                 Get.snackbar("خطأ", "الرجاء إدخال اسم المادة.");
//               }
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
