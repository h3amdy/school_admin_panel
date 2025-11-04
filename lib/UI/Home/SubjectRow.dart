// import 'package:ashil_school/AppResources.dart';
// import 'package:ashil_school/UI/SubjectDetails/SubjectDetailsUI.dart';
// import 'package:ashil_school/Utils/GoToUtils.dart';
// import 'package:ashil_school/Utils/MySnackBar.dart';
// import 'package:ashil_school/Utils/Styles.dart';
// import 'package:ashil_school/features/subject/controllers/subject_controller.dart';
// import 'package:flutter/material.dart';

// import '../../Controllers/SubjectController.dart';
// import '../../models/subject.dart';

// class SubjectRow extends StatefulWidget {
//   final Subject subject;
//   final Function(Subject) onDelete;

//   const SubjectRow({
//     Key? key,
//     required this.subject,
//     required this.onDelete,
//   }) : super(key: key);

//   @override
//   State<SubjectRow> createState() => _SubjectRowState();
// }

// class _SubjectRowState extends State<SubjectRow> {
//   bool _isDeleting = false;

//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Card(
//         elevation: 4,
//         color: Colors.white,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Row(
//             children: [
//               _buildSubjectInfo(),
//               _buildActionButtons(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSubjectInfo() {
//     return Expanded(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         textDirection: TextDirection.rtl,
//         children: [
//           _buildSubjectName(),
//           const SizedBox(height: 12),
//         //  _buildStatsRow(),
//         ],
//       ),
//     );
//   }

//   Widget _buildSubjectName() {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Text(
//         widget.subject.name,
//         style: TextStyle(
//           fontSize: 20,
//           fontWeight: FontWeight.bold,
//           color: secondaryColor,
//         ),
//         textAlign: TextAlign.right,
//       ),
//     );
//   }

//   // Widget _buildStatsRow() {
//   //   return Row(
//   //     mainAxisAlignment: MainAxisAlignment.start,
//   //     children: [
//   //       _infoBox('الدروس', widget.subject.lessonsCount),
//   //       _infoBox('الوحدات', widget.subject.unitsCount),
//   //       _infoBox('الأسئلة', widget.subject.questionsCount),
//   //     ],
//   //   );
//   // }

//   Widget _infoBox(String label, int value) {
//     return Container(
//       decoration: BoxDecoration(
//         color: primaryColor,
//         borderRadius: BorderRadius.circular(4),
//       ),
//       margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
//       padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
//       child: Text(
//         '$value $label',
//         style: normalStyle(fontSize: 12),
//       ),
//     );
//   }

//   Widget _buildActionButtons() {
//     return Align(
//       alignment: Alignment.centerLeft,
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           _isDeleting ? _buildLoadingIndicator() : _buildDeleteButton(),
//           _buildNavigateButton(),
//         ],
//       ),
//     );
//   }

//   Widget _buildDeleteButton() {
//     return IconButton(
//       icon: const Icon(Icons.delete, color: Colors.red),
//       tooltip: 'حذف المادة',
//       onPressed: () => _showDeleteConfirmationDialog(),
//     );
//   }

//   Widget _buildLoadingIndicator() {
//     return const SizedBox(
//       width: 24,
//       height: 24,
//       child: CircularProgressIndicator(strokeWidth: 2),
//     );
//   }

//   Widget _buildNavigateButton() {
//     return IconButton(
//       icon: Icon(Icons.arrow_forward_ios, color: secondaryColor),
//       tooltip: 'تفاصيل المادة',
//       onPressed: (){},
//      // onPressed: () => goTo(context, SubjectDetailsUI(widget.subject)),
//     );
//   }

//   void _showDeleteConfirmationDialog() {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: const Text('تأكيد الحذف'),
//         content: Text('هل أنت متأكد من حذف المادة "${widget.subject.name}"؟'),
//         actions: [
//           TextButton(
//             child: const Text('إلغاء'),
//             onPressed: () => Navigator.of(ctx).pop(),
//           ),
//           TextButton(
//             child: const Text('حذف', style: TextStyle(color: Colors.red)),
//             onPressed: () {
//               Navigator.of(ctx).pop();
//               _deleteSubject();
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _deleteSubject() async {
//     setState(() => _isDeleting = true);

//     try {
//       // TODO: استبدل هذا الجزء باستدعاء API الحذف الفعلي
//       // await Future.delayed(const Duration(seconds: 1));
//      await  SubjectController.deleteSubject(widget.subject.id);
//       widget.onDelete(widget.subject);

//       if (mounted) {
//         showSnackBar('تم حذف المادة بنجاح');

//       }
//     } catch (e) {
//       if (mounted) {
//         showSnackBar('حدث خطأ أثناء الحذف');

//       }
//     } finally {
//       if (mounted) {
//         setState(() => _isDeleting = false);
//       }
//     }
//   }
// }
