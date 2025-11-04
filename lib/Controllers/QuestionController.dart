// import 'dart:convert';

// import '../Utils/RandomIdGenerator.dart';
// import '../Utils/ServerUtils.dart';
// import '../models/QuestionModels/QuestionBase.dart';

// class QuestionController {
//   // إضافة سؤال جديد مرتبط بدرس معين
//   static Future<bool> addQuestion({
//     required String lessonId,
//     required QuestionBase question,

//   }) async {

//     String methodName = "questions/add";
//     Map<String, dynamic> params = question.toJson();

//     final response = await Server.post(methodName, params: params);

//     if (response.statusCode == 201) {
//       print('Question added: ${response.body}');
//       return true;
//     } else {
//       print('Failed to add question: ${response.body}');
//       return false;
//     }
//   }

//   // تعديل سؤال موجود
//   static Future<bool> editQuestion(QuestionBase question) async {
//     Map<String, dynamic> params = question.toJson();
//     String methodName = "questions/edit/${question.id}";

//     final response = await Server.post(methodName, params: params);

//     if (response.statusCode == 200) {
//       print('Question updated: ${response.body}');
//       return true;
//     } else {
//       print('Failed to update question: ${response.body}');
//       return false;
//     }
//   }

//   // جلب كل الأسئلة لدرس معين
//   static Future<List<QuestionBase>> getQuestionsByLesson(String lessonId) async {
//     String methodName = "questions/byLesson/$lessonId";

//     final response = await Server.get(methodName);

//     if (response.statusCode == 200) {
//       List<dynamic> data = jsonDecode(response.body);
//       return data.map((json) => QuestionBase.fromJson(json)).toList();
//     } else {
//       print('Failed to load questions: ${response.body}');
//       return [];
//     }
//   }

//   // حذف سؤال بواسطة ID
//   static Future<bool> deleteQuestion(String id) async {
//     String methodName = "questions/delete/$id";

//     final response = await Server.delete(methodName);

//     if (response.statusCode == 200) {
//       print('Question deleted');
//       return true;
//     } else {
//       print('Failed to delete question: ${response.body}');
//       return false;
//     }
//   }
// }
