// lib/data/repositories/local/subject_local_repository.dart
import 'package:ashil_school/data/local/app_database.dart';
import 'package:ashil_school/features/subject/models/subject.dart';
import 'package:drift/drift.dart' hide Column; // ✅ إضافة hide Column لتجنب التعارض
import 'package:get/get.dart' hide Value;
import 'package:uuid/uuid.dart';

class SubjectLocalRepository {
  final AppDatabase db = Get.find<AppDatabase>();
  final _uuid = const Uuid();

  SubjectModel _fromRow(Subject row) {
    return SubjectModel.fromLocalSubject(row);
  }

  /// ✅ جلب كل المواد محلياً، مرتبة حسب order وتجاهل المحذوفة
  Future<List<SubjectModel>> getAll({bool includeDeleted = false}) async {
    final query = db.select(db.subjects)..orderBy([(t) => OrderingTerm.asc(t.order)]);
    if (!includeDeleted) {
      query.where((tbl) => tbl.deleted.equals(false));
    }
    final rows = await query.get();
    return rows.map(_fromRow).toList();
  }

  /// ✅ جلب مواد فصل دراسي معين
  Future<List<SubjectModel>> getSubjectsBySemesterId(String semesterId, {bool includeDeleted = false}) async {
    final query = db.select(db.subjects)..where((t) => t.semesterId.equals(semesterId))..orderBy([(t) => OrderingTerm.asc(t.order)]);
    if (!includeDeleted) {
      query.where((tbl) => tbl.deleted.equals(false));
    }
    
    final rows = await query.get();
    return rows.map(_fromRow).toList();
  }

  Future<SubjectModel?> getById(String id) async {
    final row = await (db.select(db.subjects)..where((t) => t.id.equals(id))).getSingleOrNull();
    return row != null ? _fromRow(row) : null;
  }

  Future<void> insertSubjectModel(SubjectModel subjectModel) async {
    await db.into(db.subjects).insert(
      SubjectsCompanion.insert(
        id: subjectModel.id,
        name: subjectModel.name,
        order: Value(subjectModel.order), // ✅ استخدام Value
        semesterId: subjectModel.semesterId,
        gradeId: subjectModel.gradeId,
        description: Value(subjectModel.description),
        createdAt: Value(subjectModel.createdAt ?? DateTime.now()),
        updatedAt: Value(subjectModel.updatedAt ?? DateTime.now()),
        isSynced: const Value(false),
        deleted: const Value(false),
      ),
    );
  }

  Future<SubjectModel> createLocalSubject({
    required String name,
    int? order, // ✅ أصبح اختياري
    required String semesterId,
    required String gradeId,
    String? description,
  }) async {
    final id = _uuid.v4();
    final now = DateTime.now();
    final newSubject = SubjectModel(
      id: id,
      name: name,
      order: order,
      semesterId: semesterId,
      gradeId: gradeId,
      description: description,
      createdAt: now,
      updatedAt: now,
      isSynced: false,
      deleted: false,
    );
    await insertSubjectModel(newSubject);
    return newSubject;
  }

  Future<void> updateSubjectLocal(SubjectModel subjectModel) async {
    final now = DateTime.now();
    await (db.update(db.subjects)..where((t) => t.id.equals(subjectModel.id))).write(
      SubjectsCompanion(
        name: Value(subjectModel.name),
        order: Value(subjectModel.order), // ✅ استخدام Value
        semesterId: Value(subjectModel.semesterId),
        gradeId: Value(subjectModel.gradeId),
        description: Value(subjectModel.description),
        updatedAt: Value(now),
        isSynced: const Value(false),
        deleted: Value(subjectModel.deleted),
      ),
    );
  }

  Future<void> markAsDeleted(String id) async {
    await (db.update(db.subjects)..where((t) => t.id.equals(id))).write(
      SubjectsCompanion(deleted: const Value(true), isSynced: const Value(false), updatedAt: Value(DateTime.now())),
    );
  }

  Future<void> deleteSubjectPermanently(String id) async {
    await (db.delete(db.subjects)..where((t) => t.id.equals(id))).go();
  }

  Future<List<SubjectModel>> getPendingSync() async {
    final rows = await (db.select(db.subjects)..where((t) => t.isSynced.equals(false))).get();
    return rows.map(_fromRow).toList();
  }

  Future<void> updateSubjectSynced(String id, {DateTime? updatedAt}) async {
    await (db.update(db.subjects)..where((t) => t.id.equals(id))).write(
      SubjectsCompanion(
        isSynced: const Value(true),
        updatedAt: Value(updatedAt ?? DateTime.now()),
      ),
    );
  }

  Future<void> upsertSubject(SubjectModel subjectFromServer) async {
    await db.into(db.subjects).insertOnConflictUpdate(
      SubjectsCompanion(
        id: Value(subjectFromServer.id),
        name: Value(subjectFromServer.name),
        order: Value(subjectFromServer.order),
        semesterId: Value(subjectFromServer.semesterId),
        gradeId: Value(subjectFromServer.gradeId),
        description: Value(subjectFromServer.description),
        createdAt: Value(subjectFromServer.createdAt ?? DateTime.now()),
        updatedAt: Value(subjectFromServer.updatedAt ?? DateTime.now()),
        isSynced: const Value(true),
        deleted: Value(subjectFromServer.deleted),
      ),
    );
  }
}