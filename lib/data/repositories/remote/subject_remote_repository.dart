// lib/data/repositories/remote/subject_remote_repository.dart
// ... لا تغيير في هذا الملف
import 'dart:convert';
import 'package:ashil_school/data/services/server.dart';
import 'package:ashil_school/features/subject/models/subject.dart';

class SubjectRemoteRepository {
  Future<List<SubjectModel>> fetchUpdatedSubjects(DateTime? lastSyncAt) async {
    final response = await Server.get(
      "subjects",
      params: {
        if (lastSyncAt != null) "lastSyncAt": lastSyncAt.toIso8601String(),
      },
    );

    if (response.statusCode == 200) {
      print(response.body);
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => SubjectModel.fromMap(e)).toList();
    } else {
      throw Exception(
          "Failed to fetch subjects (Status: ${response.statusCode}): ${response.body}");
    }
  }

  Future<List<SubjectModel>> fetchSubjectsBySemesterId(
      String semesterId) async {
    final response = await Server.get(
      "subjects/by-semester/$semesterId",
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => SubjectModel.fromMap(e)).toList();
    } else {
      throw Exception(
          "Failed to fetch subjects by semester (Status: ${response.statusCode}): ${response.body}");
    }
  }

  Future<void> pushSubjects(List<SubjectModel> subjects) async {
    final response = await Server.post(
      "subjects/sync",
      params: {
        "subjects": subjects.map((s) => s.toMap()).toList(),
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    } else {
      throw Exception(
          "Failed to push subjects (Status: ${response.statusCode}): ${response.body}");
    }
  }
}
