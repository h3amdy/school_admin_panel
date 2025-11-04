
// import 'package:ashil_school/AppResources.dart';
// import 'package:ashil_school/Utils/Styles.dart';
// import 'package:ashil_school/Utils/emptyWidget.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../../Dialogs/NewSubjectDialog.dart';
// import '../../Providers/SubjectProvider.dart';
// import '../../constants.dart';
// import '../../models/subject.dart';
// import 'SubjectRow.dart';

// class SubjectsUI extends StatefulWidget {
//   const SubjectsUI({super.key});

//   @override
//   State<SubjectsUI> createState() => _SubjectsUIState();
// }

// class _SubjectsUIState extends State<SubjectsUI> {
//   String className = ClassNames.first;
//   String term = Terms.first;

//   @override
//   void initState() {
//     super.initState();
//     _getItems();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         headerW(),
//         subjectsListW(),
//       ]

//     );
//   }
//   Widget _buildClassDropdown() {
//     return Container(
//       width: 248,
//       padding: EdgeInsets.symmetric(horizontal: 8),
//       child: DropdownButtonFormField<String>(
//         decoration: InputDecoration(

//           prefixIcon: const Icon(
//             Icons.class_,
//             color: secondaryColor,
//           ),
//           filled: true,
//           fillColor: primaryColor,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//             borderSide: BorderSide.none,
//           ),
//         ),
//         value: className,
//         items: ClassNames
//             .map((cls) => DropdownMenuItem(
//           value: cls,
//           child: Text(
//             cls,
//             style: normalStyle(
//               color: secondaryColor,
//             ),
//           ),
//         ))
//             .toList(),
//         onChanged: (value) {
//           // setState(() {
//             className = value??className;
//           // });
//             _getItems();
//         },
//         validator: (v) => v == null ? 'الرجاء اختيار الصف' : null,
//       ),
//     );
//   }
//   Widget _buildTermDropdown() {
//     return Container(
//       width: 248,
//       padding: EdgeInsets.symmetric(horizontal: 8),

//       child: DropdownButtonFormField<String>(
//         decoration: InputDecoration(

//           prefixIcon: const Icon(
//             Icons.class_sharp,
//             color: secondaryColor,
//           ),
//           filled: true,
//           fillColor: primaryColor,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//             borderSide: BorderSide.none,
//           ),
//         ),
//         value: term,
//         items: Terms
//             .map((trm) => DropdownMenuItem(
//           value: trm,
//           child: Text(
//             trm,
//             style: normalStyle(
//               color: secondaryColor,
//             ),
//           ),
//         ))
//             .toList(),
//         onChanged: (value) {
//           // setState(() {
//             term = value??term;
//           // });
//             _getItems();
//         },
//         validator: (v) => v == null ? 'الرجاء اختيار الصف' : null,
//       ),
//     );
//   }

//  Widget headerW() {
//     return Container(
//       color: secondaryColor,
//       padding: EdgeInsets.all(12),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         textDirection: TextDirection.rtl,
//         children: [
//           Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               _buildClassDropdown(),
//               _buildTermDropdown()
//             ],
//           ),
//           addSubjectBtn(),
//         ],
//       ),
//     );
//  }

//   // Widget userW() {
//   //   return Row(
//   //     mainAxisSize: MainAxisSize.min,
//   //     textDirection: TextDirection.rtl,
//   //     children: [
//   //       userImageW(),
//   //       userNameW(),
//   //     ],
//   //   );
//   // }

//   userImageW() {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: SizedBox(
//         width: 24,
//         height: 24,
//         child: CircleAvatar(
//             backgroundColor: primaryColor,
//             child: Icon(Icons.account_circle,color: secondaryColor,size: 24,)),
//       ),
//     );
//   }

//   userNameW() {
//     String username = "مستخدم";
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Text("مرحباً، "+username,style: normalStyle(color: primaryColor),),
//     );
//   }

//   Widget addSubjectBtn() {
//     return InkWell(
//       onTap: addSubject,
//       child: Material(
//         elevation: 2,
//         borderRadius: BorderRadius.circular(4),
//         color: primaryColor,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 4),
//           child: Row(
//             textDirection: TextDirection.rtl,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text("إضافة مادة",style: normalStyle(),),
//               SizedBox(width: 12),
//               Icon(Icons.add,color: secondaryColor,size: 24,)
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   subjectsListW() {
//     final provider = context.watch<SubjectProvider>();

//     if (provider.isLoading) {
//       return Center(child: CircularProgressIndicator());
//     }

//     if (provider.errorMessage != null) {
//       return Center(child: Text(provider.errorMessage!));
//     }
//     if(provider.subjects.isEmpty)
//       return emptyWidget("لا يوجد مواد لهذا الصف حالياً");

//     return Expanded(child: ListView(
//       children: [
//         ...provider.subjects.map((item)=>SubjectRow(subject: item,onDelete: (it)=>_getItems(),))
//       ],
//     ));
//   }

//   addSubject() async{
//    await showNewSubjectDialog(context,className,term);
//    _getItems();
//   }

//   void _getItems() {
//     context.read<SubjectProvider>().getItems(className:className,term:term);

//   }
// }
