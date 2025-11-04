// lib/data/repositories/remote/semester_remote_repository.dart
import 'dart:convert';
import 'package:ashil_school/data/services/server.dart';
import 'package:ashil_school/features/semester/models/semester.dart';

class SemesterRemoteRepository {
  /// ✅ جلب كل الفصول المحدثة
  Future<List<SemesterModel>> fetchUpdatedSemesters(DateTime? lastSyncAt) async {
    final response = await Server.get(
      "semesters",
      params: {
        if (lastSyncAt != null) "lastSyncAt": lastSyncAt.toIso8601String(),
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => SemesterModel.fromMap(e)).toList();
    } else {
      throw Exception(
          "Failed to fetch semesters (Status: ${response.statusCode}): ${response.body}");
    }
  }

  /// ✅ جلب الفصول التابعة لصف معين
  Future<List<SemesterModel>> fetchSemestersByGradeId(String gradeId) async {
    final response = await Server.get(
      "semesters/by-grade/$gradeId",
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => SemesterModel.fromMap(e)).toList();
    } else {
      throw Exception(
          "Failed to fetch semesters by grade (Status: ${response.statusCode}): ${response.body}");
    }
  }

  Future<void> pushSemesters(List<SemesterModel> semesters) async {
    final response = await Server.post(
      "semesters/sync",
      params: { // ✅ تم تغيير params إلى body ليتناسب مع POST
        "semesters": semesters.map((s) => s.toMap()).toList(),
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    } else {
      throw Exception(
          "Failed to push semesters (Status: ${response.statusCode}): ${response.body}");
    }
  }
}