// lib/features/subject/models/subject.dart

import 'package:ashil_school/data/local/app_database.dart';

class SubjectModel {
  final String id;
  final String name;
  final int? order;
  final String semesterId;
  final String gradeId;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? isSynced;
  final bool deleted;

  SubjectModel({
    required this.id,
    required this.name,
    this.order,
    required this.semesterId,
    required this.gradeId,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.deleted = false,
    this.isSynced = true,
  });

  factory SubjectModel.fromMap(Map<String, dynamic> map) {
    // ✅ الحل: التعامل مع أسماء الحقول المختلفة
    final nameValue = map['name'] ?? map['Name'];

    return SubjectModel(
      id: map['_id'] as String,
      // ✅ استخدام القيمة التي تم الحصول عليها
      name: (nameValue as String?) ?? '',
      order: map['order'] as int?,
      semesterId: (map['semesterId'] as String?) ?? '',
      gradeId: (map['gradeId'] as String?) ?? '',
      description: map['description'],
      createdAt:
          map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      updatedAt:
          map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
      isSynced: map['isSynced'] ?? true,
      deleted: map['deleted'] ?? false,
    );
  }

  factory SubjectModel.fromLocalSubject(Subject localSubject) {
    return SubjectModel(
      id: localSubject.id,
      name: localSubject.name,
      order: localSubject.order,
      semesterId: localSubject.semesterId,
      gradeId: localSubject.gradeId,
      description: localSubject.description,
      createdAt: localSubject.createdAt,
      updatedAt: localSubject.updatedAt,
      isSynced: localSubject.isSynced,
      deleted: localSubject.deleted,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'order': order,
      'semesterId': semesterId,
      'gradeId': gradeId,
      'description': description,
      'isSynced': isSynced,
      'deleted': deleted,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  bool get isNew => isSynced != true;
  bool get isDeleted => deleted == true;
}
