// lib/data/repositories/remote/unit_remote_repository.dart
import 'dart:convert';
import 'package:ashil_school/data/services/server.dart';
import 'package:ashil_school/features/unit/models/unit.dart';

class UnitRemoteRepository {
  Future<List<UnitModel>> fetchUpdatedUnits(DateTime? lastSyncAt) async {
    final response = await Server.get(
      "units",
      params: {
        if (lastSyncAt != null) "lastSyncAt": lastSyncAt.toIso8601String(),
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => UnitModel.fromMap(e)).toList();
    } else {
      throw Exception(
          "Failed to fetch units (Status: ${response.statusCode}): ${response.body}");
    }
  }

  Future<List<UnitModel>> fetchUnitsBySubjectId(String subjectId) async {
    final response = await Server.get(
      "units/by-subject/$subjectId",
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => UnitModel.fromMap(e)).toList();
    } else {
      throw Exception(
          "Failed to fetch units by subject (Status: ${response.statusCode}): ${response.body}");
    }
  }

  Future<void> pushUnits(List<UnitModel> units) async {
    final response = await Server.post(
      "units/sync",
      params: {
        "units": units.map((s) => s.toMap()).toList(),
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    } else {
      throw Exception(
          "Failed to push units (Status: ${response.statusCode}): ${response.body}");
    }
  }
}
