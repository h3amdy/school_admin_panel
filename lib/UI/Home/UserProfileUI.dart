// import 'package:flutter/material.dart';


// import '../../AppResources.dart';
// import '../../Utils/Styles.dart';
// import '../../models/User.dart';
// import 'HomeUI.dart';

// class UserProfileUI extends StatelessWidget {
//    User user;
//    UserProfileUI(this.user,{super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         body: SingleChildScrollView(
//           child: Column(
//             children: [
//               // الهيدر مع صورة البروفايل وزر الرجوع
//               Stack(
//                 clipBehavior: Clip.none,
//                 children: [
//                   _Header(),
//                    _profileImage(),
//                 ],
//               ),
//               const SizedBox(height: 16),
//               // البيانات الشخصية
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 24),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                      Text(
//                       "البيانات الشخصية",
//                       style: normalStyle(fontWeight: FontWeight.bold, fontSize: 18),
//                     ),
//                     Divider(color: primaryColor,),
//                     const SizedBox(height: 8),
//                     _InfoField(label: "الاسم", value: user.username),
//                     const SizedBox(height: 8),
//                     _InfoField(label: "رقم الهاتف", value: user.phone),
//                     const SizedBox(height: 8),
//                     _InfoField(label: "المدرسة", value: user.school),
//                     const SizedBox(height: 8),
//                     _InfoField(label: "الصف الدراسي", value: user.className),
//                     const SizedBox(height: 8),
//                     _InfoField(label: "المدينة", value: user.city),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _profileImage() {
//     return  Positioned(
//       top: 60,
//       left: 0,
//       right: 0,
//       child: Center(
//         child: Stack(
//           alignment: Alignment.bottomLeft,
//           children: [
//             CircleAvatar(
//               radius: 52,
//               backgroundColor: Colors.white,
//               child: CircleAvatar(
//                 radius: 48,
//                 backgroundColor: const Color(0xFFFF9800),
//                 child: const Icon(Icons.person, color: Colors.white, size: 60),
//               ),
//             ),
//             Visibility(
//               visible: false,
//               child: Positioned(
//                 bottom: 4,
//                 left: 4,
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Colors.black,
//                     borderRadius: BorderRadius.circular(6),
//                   ),
//                   padding: const EdgeInsets.all(2),
//                   child: const Icon(Icons.edit, color: Colors.white, size: 16),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ويدجت الهيدر المتدرج
// class _Header extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 24),
//       child: Container(
//         height: 120,
//         width: double.infinity,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(8),
//           gradient: LinearGradient(
//             colors: [secondaryColor, primaryColor],
//             begin: Alignment.centerRight,
//             end: Alignment.centerLeft,
//           ),
//         ),
//         child: Stack(
//           children: [
//             Align(
//               alignment: Alignment.centerRight,
//               child: IconButton(
//                 icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 32),
//                 onPressed: () =>Navigator.pop(context),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ويدجت حقل المعلومات
// class _InfoField extends StatelessWidget {
//   final String label;
//   final String value;
//   const _InfoField({required this.label, required this.value});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: normalStyle(fontSize: 14, color: Colors.black54)),
//         const SizedBox(height: 4),
//         Container(
//           width: double.infinity,
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//           decoration: BoxDecoration(
//             color: Colors.grey.shade200,
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Text(
//             value,
//             style: normalStyle(fontSize: 14, color: Colors.black87),
//             textAlign: TextAlign.right,
//           ),
//         ),
//       ],
//     );
//   }
// }
