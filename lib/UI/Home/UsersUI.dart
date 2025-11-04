// import 'package:ashil_school/UI/Home/UserProfileUI.dart';
// import 'package:ashil_school/Utils/GoToUtils.dart';
// import 'package:ashil_school/Utils/MySnackBar.dart';
// import 'package:ashil_school/Utils/Styles.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../Controllers/UserController.dart';
// import '../../Providers/UserProvider.dart';
// import '../../models/User.dart';
// class UsersUI extends StatefulWidget {
//   const UsersUI({Key? key}) : super(key: key);

//   @override
//   State<UsersUI> createState() => _UsersUIState();
// }

// class _UsersUIState extends State<UsersUI> {
//   final TextEditingController _searchController = TextEditingController();
//   String _searchText = '';

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _getUsers();
//     });


//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('قائمة المستخدمين'),
//         ),
//         body: Consumer<UserProvider>(
//           builder: (context, userProvider, child) {
//             if (userProvider.isLoading) {
//               return const Center(child: CircularProgressIndicator());
//             }
//             if (userProvider.error != null) {
//               return Center(
//                 child: Text(
//                   userProvider.error!,
//                   style: const TextStyle(color: Colors.red, fontSize: 16),
//                 ),
//               );
//             }

//             // تصفية المستخدمين حسب نص البحث
//             final filteredUsers = _searchText.isEmpty
//                 ? userProvider.users
//                 : userProvider.users.where((user) {
//               final lowerSearch = _searchText.toLowerCase();
//               return user.username.toLowerCase().contains(lowerSearch) ||
//                   user.phone.toLowerCase().contains(lowerSearch) ||
//                   user.school.toLowerCase().contains(lowerSearch) ||
//                   user.city.toLowerCase().contains(lowerSearch) ||
//                   user.className.toLowerCase().contains(lowerSearch);
//             }).toList();

//             if (filteredUsers.isEmpty) {
//               return Column(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(12),
//                     child: _buildSearchField(),
//                   ),
//                   const Expanded(
//                     child: Center(
//                       child: Text(
//                         'لا يوجد مستخدمين مطابقين للبحث',
//                         style: TextStyle(fontSize: 16),
//                       ),
//                     ),
//                   ),
//                 ],
//               );
//             }

//             return Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(12),
//                   child: _buildSearchField(),
//                 ),
//                 Expanded(
//                   child: ListView.separated(
//                     padding: const EdgeInsets.all(12),
//                     itemCount: filteredUsers.length,
//                     separatorBuilder: (_, __) => const Divider(),
//                     itemBuilder: (context, index) {
//                       final user = filteredUsers[index];
//                       return _UserListItem(user: user,onDelete: ()=>_confirmDelete(context, user),);
//                     },
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildSearchField() {
//     return TextField(
//       controller: _searchController,
//       onChanged: (val){
//         setState(() {
//           _searchText = _searchController.text.trim();
//         });
//       },
//       decoration: InputDecoration(
//         labelText: 'بحث',
//         prefixIcon: const Icon(Icons.search),
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//       ),
//     );
//   }

//   void _getUsers() {
//     Provider.of<UserProvider>(context, listen: false).fetchUsers();
//   }
//   Future<void> _confirmDelete(BuildContext context, User user) async {
//     final confirmed = await showDialog<bool>(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: const Text('تأكيد الحذف'),
//         content: Text('هل أنت متأكد من حذف المستخدم "${user.username}"؟'),
//         actions: [
//           TextButton(
//             child:  Text('إلغاء',style: normalStyle(),),
//             onPressed: () => Navigator.of(ctx).pop(false),
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             onPressed: () => Navigator.of(ctx).pop(true),
//             child:  Text('حذف',style: normalStyle(color: Colors.white )),
//           ),
//         ],
//       ),
//     );

//     if (confirmed == true) {
//       await _deleteUser(user,context);
//       _getUsers();
//     }
//   }

//   Future<void> _deleteUser(User user,context) async {
//     try {
//       await UserController.deleteUser(user.id);
//       showSnackBar('تم حذف المستخدم "${user.username}" بنجاح');

//     } catch (e) {
//       showSnackBar('حدث خطأ أثناء حذف المستخدم: $e');

//     }
//   }


// }

// class _UserListItem extends StatelessWidget {
//   final User user;
//   final VoidCallback onDelete;

//   const _UserListItem({
//     required this.user,
//     required this.onDelete,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       leading: CircleAvatar(
//         backgroundColor: Colors.teal,
//         child: Text(
//           user.username.isNotEmpty ? user.username[0] : '?',
//           style: const TextStyle(color: Colors.white),
//         ),
//       ),
//       title: Text(user.username),
//       subtitle: Text(user.phone),
//       trailing: IconButton(
//         icon: const Icon(Icons.delete, color: Colors.red),
//         onPressed: onDelete,
//         tooltip: 'حذف المستخدم',
//       ),
//       onTap: () {
//         goTo(context, UserProfileUI(user));
//       },
//     );
//   }
// }
