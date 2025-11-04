import 'package:ashil_school/UI/Signing/SignUpUI.dart';
import 'package:ashil_school/Utils/GoToUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../AppResources.dart';
import '../../Controllers/LoginController.dart';

class LoginUI extends StatefulWidget {
  const LoginUI({super.key});

  @override
  State<LoginUI> createState() => _LoginUIState();
}

class _LoginUIState extends State<LoginUI> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg_login.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Opacity(
            opacity: 0.8,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    headW(),
                    const SizedBox(height: 10),
                    head2W(),
                    const SizedBox(height: 20),
                    usernameTextField(),
                    const SizedBox(height: 15),
                    passwordTextField(),
                    // const SizedBox(height: 10),
                    // forgotW(),
                    const SizedBox(height: 20),
                    loginBtn(),
                    const Spacer(),
                    // createAccBtn(),
                    // const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget forgotW() {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        'نسيت كلمة المرور؟',
        textDirection: TextDirection.rtl,
        style: TextStyle(color: secondaryColor, fontSize: 14),
      ),
    );
  }

  loginBtn() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: _submitForm,
      child: const Text(
        'تسجيل الدخول',
        textDirection: TextDirection.rtl,
        style: TextStyle(fontSize: 14, color: Colors.white),
      ),
    );
  }

  createAccBtn() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: RichText(
          textDirection: TextDirection.rtl,
          text: TextSpan(
            style: const TextStyle(
                color: Colors.black, fontSize: 14, fontFamily: appFont),
            children: [
              TextSpan(text: 'ليس لديك حساب؟ '),
              WidgetSpan(
                child: InkWell(
                  splashColor: primaryColor,
                  onTap: _goSignUp,
                  child: Text(
                    'إنشاء حساب',
                    style: TextStyle(
                        color: secondaryColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: appFont),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  headW() {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        'ابدأ',
        textDirection: TextDirection.rtl,
        style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
      ),
    );
  }

  head2W() {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        'قم بتسجيل الدخول للوصول الى حسابك',
        textDirection: TextDirection.rtl,
        style: TextStyle(fontSize: 14, color: secondaryColor),
      ),
    );
  }

  usernameTextField() {
    return TextFormField(
      textDirection: TextDirection.rtl,
      controller: _usernameController,
      obscureText: false,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'الرجاء إدخال اسم المستخدم';
        }

        return null;
      },
      decoration: InputDecoration(
        labelText: "اسم المستخدم",
        labelStyle: TextStyle(color: secondaryColor),
        filled: true,
        fillColor: primaryColor,
        prefixIcon: Icon(Icons.person, color: secondaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  passwordTextField() {
    return TextFormField(
      textDirection: TextDirection.rtl,
      controller: _passwordController,
      obscureText: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'الرجاء إدخال كلمة المرور';
        }
        if (value.length < 6) {
          return 'يجب أن تكون كلمة المرور 6 أحرف على الأقل';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "كلمة المرور",
        labelStyle: TextStyle(color: secondaryColor),
        filled: true,
        fillColor: primaryColor,
        prefixIcon: Icon(Icons.lock, color: secondaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  _submitForm() async {
    if (_formKey.currentState!.validate()) {
      await loginMethod(
          username: _usernameController.text,
          password: _passwordController.text);
    }
  }

  _goSignUp() {
    goTo(context, SignUpUI());
  }
}
