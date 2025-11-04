// import 'dart:convert';

// import 'package:ashil_school/Utils/ModelSaver.dart';
// import 'package:ashil_school/models/User.dart';

// import '../Utils/ServerUtils.dart';

// const USER = "user";
// late User currentUser;

// Future<void> saveUser(User user) async {
//   await saveJson(key: USER, jsonData: user.toJson());
// }

// User? loadUser() {
//   var jsonData = loadJson(key: USER);
//   if (jsonData == null) return null;
//   currentUser = User.fromJson(jsonData);
//   return currentUser;
// }

// updateUser(User user) async {
//   await saveUser(user);
//   loadUser();
// }

// Future<List<User>> getAllUsers() async {
//   String methodName = "auth/users";
//   final response = await Server.get(methodName);

//   if (response.statusCode == 200) {
//     List<dynamic> data = jsonDecode(response.body);
//     print(data.length);
//     return data.map((userJson) => User.fromJson(userJson)).toList();
//   } else {
//     print('Failed to load users: ${response.body}');
//     return [];
//   }
// }
// class UserController{

// // دالة حذف مستخدم بناءً على id
//   static Future<bool> deleteUser(String userId) async {
//     String methodName = "auth/users/$userId"; // مسار الحذف
//     final response = await Server.get(methodName);

//     if (response.statusCode == 200) {
//       print('User deleted successfully');
//       return true;
//     } else {
//       print('Failed to delete user: ${response.body}');
//       return false;
//     }
//   }

// }
