// // lib/UI/lesson/lessons_ui.dart
// import 'package:ashil_school/features/lesson/controller/lesson_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:ashil_school/features/lesson/models/lesson.dart';

// class LessonsPage extends StatelessWidget {
//   final String unitId;
//   final String unitName;
//   final LessonController controller;

//   LessonsPage({
//     super.key,
//     required this.unitId,
//     required this.unitName,
//   }) : controller = Get.put(LessonController(unitId: unitId));

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("دروس وحدة: $unitName"),
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

//         final lessons = controller.lessons;
//         if (lessons.isEmpty) {
//           return const Center(child: Text("لا يوجد دروس لهذه الوحدة."));
//         }

//         return ListView.builder(
//           itemCount: lessons.length,
//           itemBuilder: (context, index) {
//             final lesson = lessons[index];
//             return Card(
//               child: ListTile(
//                 title: Text(lesson.title),
//                 subtitle: Text("الترتيب: ${lesson.order}"),
//                 trailing: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     IconButton(
//                       icon: const Icon(Icons.edit),
//                       onPressed: () => _showAddEditDialog(context, lesson),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.delete, color: Colors.red),
//                       onPressed: () => controller.deleteLesson(lesson.id),
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
//         tooltip: "إضافة درس جديد",
//         child: const Icon(Icons.add),
//       ),
//     );
//   }

//   void _showAddEditDialog(BuildContext context, LessonModel? lesson) {
//     final titleController = TextEditingController(text: lesson?.title ?? "");
//     final orderController =
//         TextEditingController(text: lesson?.order.toString() ?? "");
//     Get.dialog(
//       AlertDialog(
//         title: Text(lesson == null ? "إضافة درس جديد" : "تعديل الدرس"),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: titleController,
//               decoration: const InputDecoration(labelText: "عنوان الدرس"),
//             ),
//             TextField(
//               controller: orderController,
//               decoration: const InputDecoration(labelText: "ترتيب الدرس"),
//               keyboardType: TextInputType.number,
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             child: const Text("إلغاء"),
//             onPressed: () => Get.back(),
//           ),
//           ElevatedButton(
//             child: Text(lesson == null ? "إضافة" : "حفظ"),
//             onPressed: () {
//               final title = titleController.text.trim();
//               final order = int.tryParse(orderController.text.trim()) ?? 0;
//               if (title.isNotEmpty && order > 0) {
//                 if (lesson == null) {
//                   controller.addLesson(title: title, order: order);
//                 } else {
//                   // TODO: أضف دالة تعديل الدرس في الكنترولر والمسار
//                   // controller.updateLesson(lesson.id, title: title, order: order);
//                 }
//                 Get.back();
//               } else {
//                 Get.snackbar("خطأ", "الرجاء إدخال عنوان وترتيب صحيح للدرس.");
//               }
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
