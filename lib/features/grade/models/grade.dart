// lib/features/grade/models/grade.dart
import 'package:ashil_school/features/semester/models/semester.dart';

class GradeModel {
  final String id;
  final String name;
  final int order;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // ✅ إضافات للمزامنة
  final bool deleted; // هل تم حذفه؟
  final bool isSynced; // هل تم رفعه للسيرفر؟

  List<SemesterModel>? semesters;

  GradeModel({
    required this.id,
    required this.name,
    required this.order,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.semesters,
    this.deleted = false,
    this.isSynced = true,
  });

  factory GradeModel.fromMap(Map<String, dynamic> json) {
    return GradeModel(
      id: json['id'],
      name: json['name'],
      order: json['order'],
      description: json['description'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      deleted: json['deleted'] ?? false,
      isSynced: true, // القادم من السيرفر اعتبره متزامن
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'order': order,
      'description': description,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'deleted': deleted,
    };
  }
}
