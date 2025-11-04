// import 'package:ashil_school/AppResources.dart';
// import 'package:ashil_school/Controllers/UnitController.dart';
// import 'package:ashil_school/Providers/SubjectProvider.dart';
// import 'package:ashil_school/Utils/MySnackBar.dart';
// import 'package:ashil_school/Utils/Styles.dart';
// import 'package:ashil_school/models/subject.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../../Dialogs/NewSubjectDialog.dart';
// import '../../Dialogs/NewUnitDialog.dart';
// import '../../Providers/UnitProvider.dart';
// import '../../models/Unit.dart';

// class UnitListWddget extends StatefulWidget {
//   Function onSelected;
//   Subject subject;
//   UnitListWddget(this.subject, {Key? key, required this.onSelected})
//       : super(key: key);

//   @override
//   State<UnitListWddget> createState() => _UnitListWddgetState();
// }

// class _UnitListWddgetState extends State<UnitListWddget> {
//   late UnitProvider unitProvider = context.read<UnitProvider>();
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Expanded(child: unitListWidget()),
//         IconButton(
//           icon: const Icon(Icons.edit, color: secondaryColor),
//           tooltip: 'تعديل  الوحدات',
//           onPressed: () => _showEditUnitsDialog(),
//         ),
//       ],
//     );
//   }

//   Widget unitListWidget() {
//     List units = context.watch<UnitProvider>().units;
//     return SizedBox(
//       height: 52,
//       child: ListView.separated(
//         scrollDirection: Axis.horizontal,
//         itemCount: units.length + 1,
//         separatorBuilder: (_, __) => const SizedBox(width: 8),
//         itemBuilder: (context, index) {
//           if (index == units.length) {
//             return addUnitBtn();
//           }
//           final unit = units[index];
//           final isSelected = unitProvider.selectedUnit?.id == unit.id;
//           return ChoiceChip(
//             label: Text(
//               unit.name,
//               style: normalStyle(
//                 color: isSelected ? Colors.white : Colors.black87,
//               ),
//             ),
//             selected: isSelected,
//             selectedColor: secondaryColor,
//             backgroundColor: Colors.grey.shade200,
//             onSelected: (val) {
//               if (val) {
//                 setState(() {
//                   unitProvider.selectUnit(unit);
//                   widget.onSelected();
//                 });
//               }
//             },
//             padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//           );
//         },
//       ),
//     );
//   }

//   Widget addUnitBtn() {
//     return ActionChip(
//       label: Text(
//         'إضافة  وحدة',
//         style: normalStyle(),
//       ),
//       avatar: const Icon(Icons.add),
//       onPressed: () async {
//         //  bool?  success  =    await  showCustomDialog(context,  NewUnitDialog(widget.subject.id));
//         //  if(success==true)  {
//         //      context.read<UnitProvider>().fetchUnits(widget.subject.id);
//         //  }
//       },
//     );
//   }

//   void _showEditUnitsDialog() {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('تعديل  الوحدات'),
//           content: SizedBox(
//             width: double.maxFinite,
//             child: ListView.separated(
//               shrinkWrap: true,
//               itemCount: unitProvider.units.length,
//               separatorBuilder: (_, __) => const Divider(),
//               itemBuilder: (context, index) {
//                 final unit = unitProvider.units[index];
//                 return ListTile(
//                   title: Text(unit.name),
//                   trailing: IconButton(
//                     icon: const Icon(Icons.delete, color: Colors.red),
//                     tooltip: 'حذف  الوحدة',
//                     onPressed: () => _confirmDeleteUnit(unit),
//                   ),
//                 );
//               },
//             ),
//           ),
//           actions: [
//             TextButton(
//               child: const Text('إغلاق'),
//               onPressed: () => Navigator.of(context).pop(),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _confirmDeleteUnit(Unit unit) {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: const Text('تأكيد  الحذف'),
//         content: Text('هل  أنت  متأكد  من  حذف  الوحدة  "${unit.name}"؟'),
//         actions: [
//           TextButton(
//             child: const Text('إلغاء'),
//             onPressed: () => Navigator.of(ctx).pop(),
//           ),
//           TextButton(
//             child: const Text('حذف', style: TextStyle(color: Colors.red)),
//             onPressed: () async {
//               Navigator.of(ctx).pop(); //  إغلاق  مربع  التأكيد
//               Navigator.of(context).pop(); //  إغلاق  مربع  التعديل
//           //    await UnitController.deleteUnit(unit.id);
//               unitProvider.fetchUnits(widget.subject.id);
//               showSnackBar('تم  حذف  الوحدة  "${unit.name}"');
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
