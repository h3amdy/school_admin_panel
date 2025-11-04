// lib/data/repositories/remote/teacher_remote_repository.dart
import 'dart:convert';
import 'package:ashil_school/data/repositories/sync_repository.dart';
import 'package:ashil_school/data/services/server.dart';
import 'package:ashil_school/models/user_model/user.dart';

class TeacherRemoteRepository {
  final SyncRepository _syncRepo = SyncRepository();
  static const _teacherEndpoint = 'teachers'; // ⚠️ استخدم اسم نقطة النهاية فقط

  /// 1. جلب التغييرات من السيرفر
  Future<List<User>> fetchTeachersFromRemote() async {
    final lastSyncDate = await _syncRepo.getLastSync('teachers');
    final response = await Server.get(
      _teacherEndpoint,
      params: {'lastSyncedAt': lastSyncDate?.toIso8601String()},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => User.fromMap(json)).toList();
    } else {
      throw Exception('فشل في جلب التغييرات من السيرفر: ${response.body}');
    }
  }

  /// 2. إرسال التغييرات المحلية إلى السيرفر
  Future<User> pushChangesToServer(User teacher) async {
    final Map<String, dynamic> teacherMap = teacher.toMap();
    // إزالة الحقول التي لا نحتاجها في طلبات الـ API
    teacherMap.remove('isSynced');
    teacherMap.remove('deleted');
    teacherMap.remove('deletedAt');

    final String endpoint = '$_teacherEndpoint/${teacher.id}';
    dynamic response;

    if (teacher.deleted == true) {
      response = await Server.delete(endpoint);
    } else if (teacher.isNew) { // نفترض أن لديك getter `isNew` في موديل User
      response = await Server.post(_teacherEndpoint, params: teacherMap);
    } else {
      response = await Server.put(endpoint, params: teacherMap);
    }

    if (response.statusCode == 200 || response.statusCode == 201) {
      return User.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('فشل في مزامنة المعلم مع السيرفر: ${response.body}');
    }
  }
}