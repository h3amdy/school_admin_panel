import 'dart:convert';
import 'package:ashil_school/data/services/server.dart';
import 'package:ashil_school/features/lesson/models/lesson.dart';

class LessonRemoteRepository {
  Future<List<LessonModel>> fetchUpdatedLessons(DateTime? lastSyncAt) async {
    final response = await Server.get(
      "lessons",
      params: {
        if (lastSyncAt != null) "lastSyncAt": lastSyncAt.toIso8601String(),
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => LessonModel.fromMap(e)).toList();
    } else {
      throw Exception("Failed to fetch lessons: ${response.statusCode}");
    }
  }

  Future<void> pushLessons(List<LessonModel> lessons) async {
    final response = await Server.post(
      "lessons/sync",
      params: {
        "lessons": lessons.map((g) => g.toMap()).toList(),
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    } else {
      throw Exception("Failed to push lessons: ${response.statusCode}");
    }
  }
}
