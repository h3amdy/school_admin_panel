// هذا الكود يبقى كما هو لأن وظيفته صحيحة
import 'dart:convert';
import 'package:ashil_school/data/services/server.dart';
import 'package:ashil_school/Utils/constants/database_constant.dart';
import 'package:ashil_school/Utils/helpers/loaders/loaders.dart';
import 'package:ashil_school/Utils/helpers/popups/full_screen_loader.dart';
import 'package:ashil_school/features/auth/view/login/login_page.dart';
import 'package:ashil_school/features/home/view/home_page.dart';
import 'package:ashil_school/models/user_model/user.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  Rx<User?> currentUser = Rx<User?>(null);

  RxString token = "".obs;

  @override
  void onReady() {
    screenRedirect();
  }

  /// دالة إعادة التوجيه عند فتح التطبيق
  Future<void> screenRedirect() async {
    final user = await getUserFromPrefs();
    if (user != null) {
      currentUser.value = user;
      Get.offAll(() => const HomePage()); // هنا ضع الصفحة الرئيسية
    } else {
      Get.offAll(() => HomePage());
    }
  }

  /// حفظ المستخدم في SharedPreferences
  Future<void> saveUserToPrefs(User user, String userToken) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        DBConstants.currentUser,
        jsonEncode(user.toMap()),
      );
      await prefs.setString("token", userToken);

      currentUser.value = user;
      token.value = userToken;
      currentUser.refresh();
    } catch (e) {
      debugPrint("❌ Error saving user to prefs: $e");
    }
  }

  /// جلب المستخدم من SharedPreferences
  Future<User?> getUserFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userString = prefs.getString(DBConstants.currentUser);
      token.value = prefs.getString("token") ?? "";

      if (userString != null) {
        final userJson = jsonDecode(userString);
        return User.fromMap(userJson);
      }
    } catch (e) {
      debugPrint("❌ Error reading user from prefs: $e");
    }
    return null;
  }

  /// تسجيل الدخول
  Future<void> login(String username, String password) async {
    KFullScreenLoader.openLoadingDialog(text: "جاري تسجيل الدخول...");
    try {
      final response = await Server.post(
        "auth/login",
        params: {
          "username": username,
          "password": password,
        },
      );
      print("محتويات ال${response.body}");
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // التعديل هنا: اقرأ التوكن من كائن `data` مباشرة
        final String userToken = data["token"];

        final Map<String, dynamic> userMap = data["user"];
        final user = User.fromMap(userMap);
        await saveUserToPrefs(user, userToken);
        Get.offAll(() => HomePage());
      } else {
        throw Exception("خطأ: ${response.body}");
      }
    } catch (e) {
      print("$e");
      throw Exception("فشل الاتصال بالسيرفر: $e");
    } finally {
      KFullScreenLoader.stopLoading();
    }
  }

  /// تسجيل الخروج
  Future<void> signOut() async {
    KFullScreenLoader.openLoadingDialog(text: "جاري تسجيل الخروج...");
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(DBConstants.currentUser);
      await prefs.remove("token");

      currentUser.value = null;
      token.value = "";

      await Get.offAll(() => LoginPage());
      KFullScreenLoader.stopLoading();
    } catch (e) {
      KFullScreenLoader.stopLoading();
      KLoaders.error(title: "$e");
    }
  }

  bool get isLoggedIn => currentUser.value != null && token.isNotEmpty;
}
