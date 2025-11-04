// import 'dart:convert';

// import 'package:ashil_school/models/lesson.dart';  // تأكد من مسار استيراد الدرس
// import '../Utils/RandomIdGenerator.dart';
// import '../Utils/ServerUtils.dart';

// class LessonController {
//   // إضافة درس جديد مرتبط بوحدة معينة
//   static Future<bool> addLesson(String unitId, String name, String explanation) async {
//     Lesson lesson = Lesson(
//       id: generateId(),
//       name: name,
//       explanation: explanation,
//     );

//     String methodName = "lessons/add";
//     Map<String, dynamic> params = lesson.toJson();
//     params['unitId'] = unitId;

//     final response = await Server.post(methodName, params: params);

//     if (response.statusCode == 201) {
//       print('Lesson added: ${response.body}');
//       return true;
//     } else {
//       print('Failed to add lesson: ${response.body}');
//       return false;
//     }
//   }


//   // تعديل درس موجود
//   static Future<bool> editLesson(Lesson lesson) async {
//     Map<String, dynamic> params = lesson.toJson();
//     String methodName = "lessons/edit/${lesson.id}";

//     final response = await Server.post(methodName, params: params);

//     if (response.statusCode == 200) {
//       print('Lesson updated: ${response.body}');
//       return true;
//     } else {
//       print('Failed to update lesson: ${response.body}');
//       return false;
//     }
//   }

//   // جلب كل الدروس لوحدة معينة
//   static Future<List<Lesson>> getLessonsByUnit(String unitId) async {
//     String methodName = "lessons/byUnit/$unitId";

//     final response = await Server.get(methodName);

//     if (response.statusCode == 200) {
//       List<dynamic> data = jsonDecode(response.body);
//       return data.map((lessonJson) => Lesson.fromJson(lessonJson)).toList();
//     } else {
//       print('Failed to load lessons: ${response.body}');
//       return [];
//     }
//   }

//   // حذف درس بواسطة ID
//   static Future<bool> deleteLesson(String id) async {
//     String methodName = "lessons/delete/$id";

//     final response = await Server.delete(methodName);

//     if (response.statusCode == 200) {
//       print('Lesson deleted');
//       return true;
//     } else {
//       print('Failed to delete lesson: ${response.body}');
//       return false;
//     }
//   }
// }
