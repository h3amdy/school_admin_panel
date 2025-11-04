import 'package:ashil_school/features/auth/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.put(AuthController());

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo or App Title
              Icon(
                Icons.school,
                size: 80,
                color: Get.theme.primaryColor,
              ),
              const SizedBox(height: 16),
              const Text(
                "تسجيل الدخول",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),

              // Username Field
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                    labelText: "اسم المستخدم",
                    prefixIcon: const Icon(Icons.person)),
              ),
              const SizedBox(height: 16),

              // Password Field
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: "كلمة المرور",
                  filled: true,
                  prefixIcon: const Icon(
                    Icons.lock,
                  ),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 24),

              // Login Button and Loading Indicator
              Obx(() {
                return authController.isLoading.value
                    ? const CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                      )
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50)),
                        onPressed: () {
                          authController.login(
                            _usernameController.text.trim(),
                            _passwordController.text.trim(),
                          );
                        },
                        child: const Text(
                          "دخول",
                        ),
                      );
              }),
              const SizedBox(height: 16),

              // Error Message
              Obx(() {
                return authController.errorMessage.isNotEmpty
                    ? Text(
                        authController.errorMessage.value,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : const SizedBox.shrink();
              })
            ],
          ),
        ),
      ),
    );
  }
}
