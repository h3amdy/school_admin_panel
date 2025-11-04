import 'package:ashil_school/data/local/app_database.dart';
import 'package:ashil_school/features/subject/models/subject.dart';

class SemesterModel {
  final String id;
  final String name;
  final int order; // ✅ تم إضافة حقل الترتيب
  final String gradeId;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? isSynced;
  final bool deleted;
  List<SubjectModel>? subjects;

  SemesterModel(
      {required this.id,
      required this.name,
      required this.order,
      required this.gradeId,
      this.description,
      this.createdAt,
      this.updatedAt,
      this.isSynced,
      required this.deleted,
      this.subjects});

  factory SemesterModel.fromMap(Map<String, dynamic> map) {
    return SemesterModel(
      id: map['_id'] as String,
      name: map['name'] as String,
      order: map['order'] as int, // ✅ قراءة حقل الترتيب من الخادم
      gradeId: map['gradeId'] as String,
      description: map['description'],
      createdAt:
          map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      updatedAt:
          map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
      isSynced: map['isSynced'] ?? true,
      deleted: map['deleted'] ?? false,
    );
  }

  factory SemesterModel.fromLocalSemester(Semester localSemester) {
    return SemesterModel(
      id: localSemester.id,
      name: localSemester.name,
      order: localSemester.order, // ✅ قراءة حقل الترتيب من القاعدة المحلية
      gradeId: localSemester.gradeId,
      description: localSemester.description,
      createdAt: localSemester.createdAt,
      updatedAt: localSemester.updatedAt,
      isSynced: localSemester.isSynced,
      deleted: localSemester.deleted,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'order': order,
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

  // ------------------------------------------------------------------
  // ✅ FIX: Override == and hashCode for structural equality
  // هذا يضمن أن الدروبداون يعتبر كائنين متطابقين إذا كان لهما نفس الـ ID
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SemesterModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
  // ------------------------------------------------------------------
}
