import 'package:ashil_school/Controllers/SignUpController.dart';
import 'package:ashil_school/UI/Signing/LoginUI.dart';
import 'package:ashil_school/UI/Signing/SignUpUI.dart';
import 'package:ashil_school/Utils/GoToUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../AppResources.dart';
import '../../Controllers/LoginController.dart';
import '../../Utils/phoneUtils.dart';

class SignUpUI extends StatefulWidget {
  const SignUpUI({super.key});

  @override
  State<SignUpUI> createState() => _SignUpUIState();
}

class _SignUpUIState extends State<SignUpUI> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

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
                    phoneTextField(),
                    const SizedBox(height: 15),
                    passwordTextField(),
                    const SizedBox(height: 15),
                    confirmPasswordTextField(),
                    const SizedBox(height: 20),
                    signUpBtn(),
                    const Spacer(),
                    goLoginUIBtn(),
                    const SizedBox(height: 20),
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

  signUpBtn() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: isLoading?null:_submitForm,
      child: isLoading?progressBar():createAccTxt(),
    );
  }
  Widget progressBar(){
    return CircularProgressIndicator(color: accenntColor2,);
  }
  Widget createAccTxt(){
    return const Text(
      'إنشاء حساب',
      textDirection: TextDirection.rtl,
      style: TextStyle(fontSize: 14, color: Colors.white),
    );
  }
  goLoginUIBtn() {
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
              TextSpan(text: 'لديك حساب؟ '),
              WidgetSpan(
                child: InkWell(
                  splashColor: primaryColor,
                  onTap: _goLoginUI,
                  child: Text(
                    'تسجيل دخول',
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
        'إنشاء حساب',
        textDirection: TextDirection.rtl,
        style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
      ),
    );
  }

  head2W() {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        'قم بإنشاء حساب جديد للوصول لخدماتنا',
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
        }else if(value.length<5)
          return 'اسم المستخدم قصير جداً';

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

  phoneTextField() {
    return TextFormField(
      textDirection: TextDirection.rtl,
      keyboardType: TextInputType.phone,
      controller: _phoneController,
      obscureText: false,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'الرجاء إدخال رقم الهاتف';
        }
        else if(!isValidPhoneNumber(value))
          return 'يرجى إدخال رقم صحيح';

        return null;
      },
      decoration: InputDecoration(
        labelText: "رقم الهاتف",
        labelStyle: TextStyle(color: secondaryColor),
        filled: true,
        fillColor: primaryColor,
        prefixIcon: Icon(Icons.phone, color: secondaryColor),
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

  confirmPasswordTextField() {
    return TextFormField(
      textDirection: TextDirection.rtl,
      controller: _confirmPasswordController,
      obscureText: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'الرجاء إدخال تأكيد كلمة المرور';
        } else if (_confirmPasswordController.text !=
            _passwordController.text) {
          return 'كلمة المرور وتأكيدها غير متطابقان';
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
      setState(() { isLoading= !isLoading;});
      await signUpMethod(
          username: _usernameController.text,
          phone: _phoneController.text,
          password: _passwordController.text);
      setState(() { isLoading= !isLoading;});

    }
  }

  _goLoginUI() {
    goToAndRemove(context, LoginUI());
  }
}
