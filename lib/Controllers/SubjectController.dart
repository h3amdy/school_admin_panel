// import 'dart:convert';
// import 'dart:math';

// import 'package:ashil_school/models/subject.dart';

// import '../Utils/RandomIdGenerator.dart';
// import '../Utils/ServerUtils.dart';
// class SubjectController {
//  static Future<bool> addSubject(String name,int number, String className,String term) async {
//     Subject subject = Subject(
//         name: name,
//         number:number,
//         className: className,
//         term: term,
//         id: generateId());
//     String methodName = "subjects/add";
//     Map<String, dynamic> params = subject.toJson();

//     final response = await Server.post(methodName, params: params);

//     if (response.statusCode == 201) {
//       print('Subject added: ${response.body}');
//     } else {
//       print('Failed to add subject: ${response.body}');
//     }
//     return response.statusCode==201;
//   }

//  static Future<void> editSubject(Subject subject) async {
//     Map<String, dynamic> params = subject.toJson();
//     String methodName = "subjects/edit/${subject.id}";
//     final response = await Server.post(
//       methodName,
//       params: params,
//     );

//     if (response.statusCode == 200) {
//       print('Subject updated: ${response.body}');
//     } else {
//       print('Failed to update subject: ${response.body}');
//     }
//   }

//   static Future<List<Subject>> getSubjectsByClass(String className,String term) async {
//     String methodName = "subjects/byClass?className=$className&term=$term";
//     final response = await Server.get(methodName);

//     if (response.statusCode == 200) {
//       List<dynamic> data = jsonDecode(
//           response.body); // تحويل البيانات إلى قائمة من الـ JSON
//       return data.map((subjectJson) => Subject.fromJson(subjectJson))
//           .toList(); // تحويل كل عنصر إلى Subject
//     } else {
//       print('Failed to load subjects: ${response.body}');
//       return []; // إرجاع قائمة فارغة في حال الفشل
//     }
//   }

//   static Future<void> deleteSubject(String id) async {
//     String methodName = "subjects/delete/$id";
//     final response = await Server.get(methodName);

//     if (response.statusCode == 200) {
//       print('Subject deleted');
//     } else {
//       print('Failed to delete subject: ${response.body}');
//     }
//   }
// }