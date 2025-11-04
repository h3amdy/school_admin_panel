

import 'package:ashil_school/Utils/MySnackBar.dart';
import 'package:ashil_school/data/services/server.dart';
import 'dart:convert';

import 'package:http/http.dart';


loginMethod({required String username, required String password}) async{
  Map<String,dynamic> params = {'username': username, 'password': password};
  String methodName = "auth/login";
 Response response = await Server.post(methodName, params: params);
 _handleLoginResponse(response);

}

void _handleLoginResponse(Response response) {
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    String token = data['token']; // احفظ التوكن لاستخدامه لاحقًا
    print('تم تسجيل الدخول بنجاح. التوكن: $token');
  } else {
    print('خطأ في تسجيل الدخول: ${response.body}');
  }
}