// import 'package:ashil_school/Utils/custom_dilog/confert_dilog.dart';
// import 'package:ashil_school/features/grade/views/dialog/add_edit_dialog.dart';
// import 'package:ashil_school/features/grade/views/grade_details_page.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:ashil_school/features/grade/controllers/grade_controller.dart';

// class GradesPage extends StatelessWidget {
//   final GradeController controller = Get.put(GradeController());

//   GradesPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("إدارة الصفوف"),
//         centerTitle: true,
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value && controller.grades.isEmpty) {
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

//         final grades = controller.grades;

//         if (grades.isEmpty) {
//           return const Center(child: Text("لا يوجد صفوف بعد"));
//         }

//         return ListView.builder(
//           itemCount: grades.length,
//           itemBuilder: (context, index) {
//             final grade = grades[index];
//             return Card(
//               child: ListTile(
//                 onTap: () {
//                   Get.to(() => GradeDetailsPage(
//                       gradeId: grade.id, gradeName: grade.name));
//                 },
//                 onLongPress: () {
//                   showEditDeleteOptions(
//                     itemName: grade.name,
//                     onEdit: () => showAddEditGradeDialog(context,controller, grade: grade),
//                     onDelete: () => controller.deleteGrade(grade.id),
//                   );
//                 },
//                 title: Text(grade.name),
//                 subtitle: Text("المستوى: ${grade.order}"),
//               ),
//             );
//           },
//         );
//       }),
//       floatingActionButton: Obx(() {
//         return FloatingActionButton.extended(
//           onPressed: controller.isLoading.value
//               ? null
//               : () => showAddEditGradeDialog(context,controller, grade: null),
//           icon: const Icon(Icons.add),
//           label: const Text("إضافة صف"),
//         );
//       }),
//     );
//   }
// }
