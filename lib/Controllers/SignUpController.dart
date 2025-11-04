
import 'dart:convert';
import 'package:ashil_school/Utils/GoToUtils.dart';
import 'package:ashil_school/main.dart';
import 'package:http/http.dart';
import '../UI/Signing/PhoneAuthUI.dart';
import '../Utils/MySnackBar.dart';
import '../data/services/server.dart';

signUpMethod({required String username, required String phone,required String password}) async{
  Map<String,dynamic> params = {'username': username,'phone':phone, 'password': password};
  String methodName = "auth/signup";
  Response response = await Server.post(methodName, params: params);
  _handleSignUpResponse(response);

}

void _handleSignUpResponse(Response response) {
  if (response.statusCode == 200) {
   // goToAndRemove(materialKey.currentContext!, PhoneAuthUI());
  } else {
  //  showSnackBar('خطأ في التسجيل: ${response.body}');
  }
}