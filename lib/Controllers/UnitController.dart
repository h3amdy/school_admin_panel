// import 'dart:convert';

// import 'package:ashil_school/models/Unit.dart';  // تأكد من مسار استيراد الوحدة
// import '../Utils/RandomIdGenerator.dart';
// import '../Utils/ServerUtils.dart';

// class UnitController {
//   // إضافة وحدة جديدة مرتبطة بمادة معينة
//   static Future<bool> addUnit(String subjectId, String name, {String? id}) async {
//     Unit unit = Unit(
//       id: id ?? generateId(),
//       subjectId: subjectId,
//       name: name,
//     );

//     String methodName = "units/add";
//     Map<String, dynamic> params = unit.toJson();

//     final response = await Server.post(methodName, params: params);

//     if (response.statusCode == 201) {
//       print('Unit added: ${response.body}');
//       return true;
//     } else {
//       print('Failed to add unit: ${response.body}');
//       return false;
//     }
//   }

//   // تعديل وحدة موجودة
//   static Future<bool> editUnit(Unit unit) async {
//     Map<String, dynamic> params = unit.toJson();
//     String methodName = "units/edit/${unit.id}";

//     final response = await Server.post(methodName, params: params);

//     if (response.statusCode == 200) {
//       print('Unit updated: ${response.body}');
//       return true;
//     } else {
//       print('Failed to update unit: ${response.body}');
//       return false;
//     }
//   }

//   // جلب كل الوحدات لمادة معينة
//   static Future<List<Unit>> getUnitsBySubject(String subjectId) async {
//     String methodName = "units/bySubject/$subjectId";

//     final response = await Server.get(methodName);

//     if (response.statusCode == 200) {
//       List<dynamic> data = jsonDecode(response.body);
//       return data.map((unitJson) => Unit.fromJson(unitJson)).toList();
//     } else {
//       print('Failed to load units: ${response.body}');
//       return [];
//     }
//   }

//   // حذف وحدة بواسطة ID
//   static Future<bool> deleteUnit(String id) async {
//     String methodName = "units/delete/$id";

//     final response = await Server.get(methodName);

//     if (response.statusCode == 200) {
//       print('Unit deleted');
//       return true;
//     } else {
//       print('Failed to delete unit: ${response.body}');
//       return false;
//     }
//   }
// }
