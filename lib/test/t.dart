// import 'package:ashil_school/Utils/custom_dilog/confert_dilog.dart';
// import 'package:ashil_school/Utils/helpers/loaders/loaders.dart';
// import 'package:ashil_school/common/widgets/section_heading.dart';
// import 'package:ashil_school/features/grade/controllers/grade_controller.dart';
// import 'package:ashil_school/features/grade/controllers/grade_details_controller.dart';
// import 'package:ashil_school/features/grade/models/grade.dart';
// import 'package:ashil_school/features/grade/views/dialog/add_edit_dialog.dart';
// import 'package:ashil_school/features/semester/models/semester.dart';
// import 'package:ashil_school/features/semester/views/dialogs/add_edit_semester_dialog.dart';
// import 'package:ashil_school/features/subject/controllers/subject_controller.dart';
// import 'package:ashil_school/features/subject/models/subject.dart';
// import 'package:ashil_school/features/subject/views/dialogs/add_edit_subject_dialog.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// // --------------------------------------------------------------------------
// // 5. REDESIGNED UI COMPONENTS (مكونات الواجهة المعاد تصميمها)
// // --------------------------------------------------------------------------

// /// المكون المخصص للقوائم المنسدلة للصفوف والفصول (المطابق للتصميم)
// class CurriculumFilterDropdowns extends StatelessWidget {
//   final GradeDetailsController controller;
//   final List<GradeModel> allGrades; // قائمة الصفوف الكاملة لاختيار الصف
//   final GradeModel selectedGrade;
//   final Function(GradeModel) onGradeSelected;
//   final VoidCallback onAddGrade;

//   const CurriculumFilterDropdowns({
//     super.key,
//     required this.controller,
//     required this.allGrades,
//     required this.selectedGrade,
//     required this.onGradeSelected,
//     required this.onAddGrade,
//   });

//   // ويدجت بناء القائمة المنسدلة المخصصة
//   Widget _buildDropdown({
//     required BuildContext context,
//     required String label,
//     required Widget dropdown,
//     required VoidCallback onAddPressed,
//   }) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 2),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: Colors.grey.shade200, width: 1),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.1),
//               spreadRadius: 1,
//               blurRadius: 3,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             // أيقونة الفلترة
//             const Icon(Icons.sort, color: Color(0xFF00A591), size: 20),
//             const SizedBox(width: 8),

//             // Dropdown (القائمة المنسدلة)
//             Expanded(child: dropdown),

//             // زر الإضافة
//             InkWell(
//               onTap: onAddPressed,
//               child: Container(
//                 padding: const EdgeInsets.all(4),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFE0E0E0).withOpacity(0.5),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: const Icon(Icons.add, color: Colors.black54, size: 18),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//       child: Row(
//         children: [
//           // 1. قائمة الصفوف المنسدلة (Grade Dropdown)
//           _buildDropdown(
//             context: context,
//             label: 'الصف',
//             onAddPressed: onAddGrade, // زر إضافة صف
//             dropdown: DropdownButtonHideUnderline(
//               child: DropdownButton<GradeModel>(
//                 isExpanded: true,
//                 value: selectedGrade,
//                 icon: const Icon(Icons.keyboard_arrow_down,
//                     color: Colors.black54),
//                 style: const TextStyle(color: Colors.black, fontSize: 14),
//                 onChanged: (newValue) {
//                   if (newValue != null) {
//                     onGradeSelected(newValue);
//                   }
//                 },
//                 items: allGrades
//                     .map<DropdownMenuItem<GradeModel>>((GradeModel grade) {
//                   return DropdownMenuItem<GradeModel>(
//                     value: grade,
//                     child: Text(
//                       grade.name,
//                       textAlign: TextAlign.right,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ),
//           ),
//           const SizedBox(width: 12),

//           // 2. قائمة الفصول المنسدلة (Semester Dropdown)
//           Obx(() {
//             final semesters = controller.semesters;
//             final selectedSemester = controller.selectedSemester.value;

//             return _buildDropdown(
//               context: context,
//               label: 'الفصل الدراسي',
//               onAddPressed: () => showAddEditSemesterDialog(
//                 // زر إضافة فصل
//                 controller: controller.semesterController,
//                 gradeName: "",
//               ),
//               dropdown: DropdownButtonHideUnderline(
//                 child: DropdownButton<SemesterModel>(
//                   isExpanded: true,
//                   value: selectedSemester,
//                   icon: const Icon(Icons.keyboard_arrow_down,
//                       color: Color(0xFF00A591)),
//                   style: const TextStyle(color: Colors.black, fontSize: 14),
//                   hint: const Text('اختر فصلاً', textAlign: TextAlign.right),
//                   onChanged: (newValue) {
//                     if (newValue != null) {
//                       controller.selectSemester(newValue);
//                     }
//                   },
//                   items: semesters.map<DropdownMenuItem<SemesterModel>>(
//                       (SemesterModel semester) {
//                     return DropdownMenuItem<SemesterModel>(
//                       value: semester,
//                       child: Text(semester.name,
//                           textAlign: TextAlign.right,
//                           overflow: TextOverflow.ellipsis),
//                     );
//                   }).toList(),
//                 ),
//               ),
//             );
//           }),
//         ],
//       ),
//     );
//   }
// }

// /// ويدجت لعرض المادة بشكل بطاقة
// class SubjectCard extends StatelessWidget {
//   final SubjectModel subject;
//   final VoidCallback onTap;
//   final VoidCallback onEdit;
//   final VoidCallback onDelete;

//   const SubjectCard(
//       {super.key,
//       required this.subject,
//       required this.onTap,
//       required this.onEdit,
//       required this.onDelete});

//   // دالة وهمية للحصول على لون عشوائي لبطاقة الكتاب (لتشابه التصميم)
//   Color _getRandomColor() {
//     final colors = [
//       0xFFD0E9E6,
//       0xFFB5D8B4,
//       0xFFE0C7E0,
//       0xFFE9D0D0,
//       0xFFC7E0E9,
//       0xFFA0C0D0
//     ];
//     return Color(colors[subject.order ?? 0 % colors.length]);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       onLongPress: onEdit, // محاكاة لظهور خيارات التعديل عند الضغط المطول
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(15),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.15),
//               spreadRadius: 2,
//               blurRadius: 5,
//               offset: const Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             // غلاف الكتاب (محاكاة)
//             Expanded(
//               child: Container(
//                 margin: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: _getRandomColor(),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Center(
//                   child: Text(
//                     subject.name.split(' ').first,
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(
//                       color: Colors.black87,
//                       fontSize: 14,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             // عنوان الكتاب
//             Padding(
//               padding:
//                   const EdgeInsets.only(right: 8.0, left: 8.0, bottom: 8.0),
//               child: Text(
//                 subject.name,
//                 textAlign: TextAlign.right,
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//                 style: const TextStyle(
//                   fontSize: 12,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// /// شبكة عرض المواد (SubjectGrid)
// class SubjectGrid extends StatelessWidget {
//   final SubjectController controller;
//   final String? gradeName;
//   final Rx<SemesterModel?> selectedSemester;

//   const SubjectGrid(
//       {super.key,
//       required this.controller,
//       this.gradeName,
//       required this.selectedSemester});

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       final semesterName = selectedSemester.value?.name ?? 'اختر فصلاً';

//       if (controller.semesterId.value == null) {
//         return Expanded(
//           child: Center(
//               child: Text("الرجاء اختيار فصل لعرض المواد في $gradeName")),
//         );
//       }

//       if (controller.isLoading.value) {
//         return const Expanded(
//           child: Center(child: CircularProgressIndicator()),
//         );
//       }

//       if (controller.subjects.isEmpty) {
//         return Expanded(
//           child: Center(child: Text("لا يوجد مواد في فصل $semesterName.")),
//         );
//       }

//       return Expanded(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             KSectionHeading(
//                 title: "مواد الفصل: ${selectedSemester.value?.name ?? ''}"),
//             Expanded(
//               child: GridView.builder(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 3, // تم تغييرها لـ 3 أعمدة لتطابق التصميم
//                   crossAxisSpacing: 10,
//                   mainAxisSpacing: 10,
//                   childAspectRatio: 0.65, // شكل الكتاب
//                 ),
//                 itemCount: controller.subjects.length,
//                 itemBuilder: (context, index) {
//                   final subject = controller.subjects[index];
//                   return SubjectCard(
//                     subject: subject,
//                     onTap: () {
//                       KLoaders.success(
//                           title: "تصفح",
//                           message:
//                               "انتقال لصفحة تفاصيل المادة: ${subject.name}");
//                     },
//                     onEdit: () {
//                       showAddEditSubjectDialog(
//                         controller: controller,
//                         selectedSemester: selectedSemester,
//                         subject: subject,
//                         gradeName: gradeName,
//                       );
//                     },
//                     onDelete: () => showConfirmationDialog(
//                       onCancel: () => Get.back(),
//                       title: "حذف المادة",
//                       message: "هل أنت متأكد من حذف مادة ${subject.name}؟",
//                       onConfirm: () => controller.deleteSubject(subject.id),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       );
//     });
//   }
// }

// // --------------------------------------------------------------------------
// // 6. MAIN VIEWS (الصفحات الرئيسية المعاد تصميمها)
// // --------------------------------------------------------------------------

// /// الواجهة الجديدة المعاد تصميمها (بديلة GradeDetailsPage)
// class CurriculumDetailsView extends StatelessWidget {
//   final String gradeId;
//   final String gradeName;

//   CurriculumDetailsView({
//     super.key,
//     required this.gradeId,
//     required this.gradeName,
//   }) {
//     // يجب وضع Controller هنا لضمان الحصول على البيانات بمجرد الدخول للصفحة
//     Get.put(GradeDetailsController(gradeId), tag: gradeId);
//     Get.put(
//         GradeController()); // للتأكد من وجود GradeController لاستخدام قائمة Grades في Dropdown
//   }

//   @override
//   Widget build(BuildContext context) {
//     // نستخدم الـ tag للوصول إلى وحدة التحكم الخاصة بهذا الصف تحديداً
//     final controller = Get.find<GradeDetailsController>(tag: gradeId);
//     final gradeController =
//         Get.find<GradeController>(); // للوصول لقائمة الصفوف الكاملة

//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         // لا يوجد AppBar تقليدي، سيتم بناء شريط رأسي مخصص داخل Body
//         body: SafeArea(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // الشريط العلوي المخصص (يشبه الصورة)
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Row(
//                   children: [
//                     IconButton(
//                       icon: const Icon(Icons.arrow_back_ios,
//                           color: Colors.black54),
//                       onPressed: () => Get.back(),
//                     ),
//                     Expanded(
//                       child: Text(
//                         'المنهج',
//                         style: Theme.of(context)
//                             .textTheme
//                             .headlineMedium
//                             ?.copyWith(
//                               fontWeight: FontWeight.bold,
//                               color: Colors.black,
//                             ),
//                         textAlign: TextAlign.right,
//                       ),
//                     ),
//                     const Icon(Icons.search, color: Colors.black54),
//                     const SizedBox(width: 8),
//                     const Icon(Icons.apps, color: Colors.black54),
//                   ],
//                 ),
//               ),

//               // منطقة الفلاتر والقوائم المنسدلة (مطابقة للتصميم)
//               Obx(() {
//                 // نستخدم هنا قائمة الصفوف المحملة في GradeController
//                 final allGrades = gradeController.grades;
                
//                 // يتم البحث عن الصف المحدد حالياً
//                 final currentGrade = allGrades
//                     .firstWhereOrNull((g) => g.id == gradeId);
                
//                 // في حال عدم وجود صفوف أو عدم العثور على الصف المحدد
//                 if (allGrades.isEmpty || currentGrade == null) {
//                   return const Center(child: LinearProgressIndicator());
//                 }

//                 return CurriculumFilterDropdowns(
//                   controller: controller,
//                   allGrades: allGrades,
//                   selectedGrade: currentGrade,
//                   onGradeSelected: (newGrade) {
//                     // محاكاة الانتقال إلى صفحة الصف الجديد
//                     // نستخدم Get.off للانتقال وإزالة الصفحة الحالية من الستاك
//                     Get.off(() => CurriculumDetailsView(
//                           gradeId: newGrade.id,
//                           gradeName: newGrade.name,
//                         ));
//                   },
//                   onAddGrade: () => showAddEditGradeDialog(
//                       context, gradeController,
//                       grade: null),
//                 );
//               }),

//               const SizedBox(height: 16),

//               // شبكة عرض المواد (Subject Grid)
//               SubjectGrid(
//                 controller: controller.subjectController,
//                 gradeName: gradeName,
//                 selectedSemester: controller.selectedSemester,
//               ),
//             ],
//           ),
//         ),

//         // زر عائم لإضافة مادة (كما طلبت)
//         floatingActionButton: Obx(() {
//           // عرض زر الإضافة فقط إذا تم اختيار فصل
//           if (controller.selectedSemester.value == null) {
//             return const SizedBox.shrink();
//           }
//           return FloatingActionButton.extended(
//             onPressed: () => showAddEditSubjectDialog(
//               controller: controller.subjectController,
//               selectedSemester: controller.selectedSemester,
//               gradeName: gradeName,
//             ),
//             label:
//                 const Text("إضافة مادة", style: TextStyle(color: Colors.white)),
//             icon: const Icon(Icons.add, color: Colors.white),
//           );
//         }),
//       ),
//     );
//   }
// }
