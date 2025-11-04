import 'dart:convert';

import 'package:ashil_school/constants.dart';
import 'package:http/http.dart' as http;

class Server {
  static Future<http.Response> post(String methodName,
      {required Map<String, dynamic> params}) async {
    final url = Uri.parse(SERVER_URL + methodName);
    http.Response response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(params),
    );
    if (response.statusCode == 200) {
      print('Success  $methodName');
    } else {
      print('Error:  ${response.body}');
    }
    return response;
  }

  //  ✅  دالة  جديدة  لإرسال  طلب  PUT
  static Future<http.Response> put(String methodName,
      {required Map<String, dynamic> params}) async {
    final url = Uri.parse(SERVER_URL + methodName);
    http.Response response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(params),
    );
    if (response.statusCode == 200) {
      print('Success  $methodName');
    } else {
      print('Error:  ${response.body}');
    }
    return response;
  }

  static Future<http.Response> get(String methodName,
      {Map<String, dynamic>? params}) async {
    final uri =
        Uri.parse(SERVER_URL + methodName).replace(queryParameters: params);

    final response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      print('Success  $methodName');
    } else {
      print('Error:  ${response.body}');
    }

    return response;
  }

  static Future<http.Response> delete(String methodName) async {
    final uri = Uri.parse(SERVER_URL + methodName);

    final response = await http.delete(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      print('Success  $methodName');
    } else {
      print('Error:  ${response.body}');
    }

    return response;
  }
}
