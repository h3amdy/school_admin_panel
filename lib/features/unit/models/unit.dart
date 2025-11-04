
// lib/features/unit/models/unit.dart
import 'package:ashil_school/data/local/app_database.dart';

class UnitModel {
    final String id;
    final String name;
    final int? order;
    final String subjectId;
    final String? description;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final bool? isSynced;
    final bool deleted;

    UnitModel({
        required this.id,
        required this.name,
        this.order,
        required this.subjectId,
        this.description,
        this.createdAt,
        this.updatedAt,
        this.deleted = false,
        this.isSynced = true,
    });

    factory UnitModel.fromMap(Map<String, dynamic> map) {
        return UnitModel(
            id: map['_id'] as String,
            name: map['name'] as String,
            order: map['order'] as int?,
            subjectId: map['subjectId'] as String,
            description: map['description'],
            createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
            updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
            isSynced: map['isSynced'] ?? true,
            deleted: map['deleted'] ?? false,
        );
    }

    factory UnitModel.fromLocalUnit(Unit localUnit) {
        return UnitModel(
            id: localUnit.id,
            name: localUnit.name,
            order: localUnit.order,
            subjectId: localUnit.subjectId,
            description: localUnit.description,
            createdAt: localUnit.createdAt,
            updatedAt: localUnit.updatedAt,
            isSynced: localUnit.isSynced,
            deleted: localUnit.deleted,
        );
    }

    Map<String, dynamic> toMap() {
        return {
            '_id': id,
            'name': name,
            'order': order,
            'subjectId': subjectId,
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