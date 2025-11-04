import 'dart:convert';
import 'package:ashil_school/data/services/server.dart';
import 'package:ashil_school/features/grade/models/grade.dart';

class GradeRemoteRepository {
  Future<List<GradeModel>> fetchUpdatedGrades(DateTime? lastSyncAt) async {
    final response = await Server.get(
      "grades",
      params: {
        if (lastSyncAt != null) "lastSyncAt": lastSyncAt.toIso8601String(),
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => GradeModel.fromMap(e)).toList();
    } else {
      throw Exception(
          "Failed to fetch grades (Status: ${response.statusCode}): ${response.body}");
    }
  }

  Future<void> pushGrades(List<GradeModel> grades) async {
    final response = await Server.post(
      "grades/sync",
      params: {
        "grades": grades.map((g) => g.toMap()).toList(),
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    } else {
      throw Exception(
          "Failed to push grades (Status: ${response.statusCode}): ${response.body}");
    }
  }
}