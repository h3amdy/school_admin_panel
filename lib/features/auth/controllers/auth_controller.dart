// هذا الكود هو التعديل على ملف AuthController.dart
import 'package:ashil_school/data/repositories/authentication_repository.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = "".obs;

  final AuthenticationRepository _authRepo = AuthenticationRepository.instance;

  /// تسجيل الدخول
  Future<void> login(String username, String password) async {
    isLoading.value = true;
    errorMessage.value = "";
    try {
      await _authRepo.login(username, password);
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst("Exception: ", "");
    } finally {
      isLoading.value = false;
    }
  }

  /// تسجيل الخروج
  Future<void> logout() async {
    await _authRepo.signOut();
  }

  /// التأكد إذا المستخدم مسجل دخول
  bool get isLoggedIn => _authRepo.isLoggedIn;
}
