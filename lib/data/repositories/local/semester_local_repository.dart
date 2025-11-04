// lib/data/repositories/local/semester_local_repository.dart
import 'package:ashil_school/data/local/app_database.dart';
import 'package:ashil_school/features/semester/models/semester.dart';
import 'package:drift/drift.dart';
import 'package:get/get.dart' hide Value;
import 'package:uuid/uuid.dart';

class SemesterLocalRepository {
  final AppDatabase db = Get.find<AppDatabase>();
  final _uuid = const Uuid();

  SemesterModel _fromRow(Semester row) {
    return SemesterModel.fromLocalSemester(row);
  }

  /// ✅ جلب كل الفصول محلياً، مرتبة حسب order وتجاهل المحذوفة
  Future<List<SemesterModel>> getAll({bool includeDeleted = false}) async {
    final query = db.select(db.semesters)..orderBy([(t) => OrderingTerm(expression: t.order)]);
    if (!includeDeleted) {
      query.where((tbl) => tbl.deleted.equals(false));
    }
    final rows = await query.get();
    return rows.map(_fromRow).toList();
  }

  /// ✅ جلب فصول صف معين
  Future<List<SemesterModel>> getSemestersByGradeId(String gradeId, {bool includeDeleted = false}) async {
    final query = db.select(db.semesters)..where((t) => t.gradeId.equals(gradeId));
    if (!includeDeleted) {
      query.where((tbl) => tbl.deleted.equals(false));
    }
    final rows = await query.get();
    return rows.map(_fromRow).toList();
  }

  Future<SemesterModel?> getById(String id) async {
    final row = await (db.select(db.semesters)..where((t) => t.id.equals(id))).getSingleOrNull();
    return row != null ? _fromRow(row) : null;
  }

  Future<void> insertSemesterModel(SemesterModel semesterModel) async {
    await db.into(db.semesters).insert(
      SemestersCompanion.insert(
        id: semesterModel.id,
        name: semesterModel.name,
        order: semesterModel.order, // ✅ استخدام حقل الترتيب
        gradeId: semesterModel.gradeId,
        description: Value(semesterModel.description),
        createdAt: Value(semesterModel.createdAt ?? DateTime.now()),
        updatedAt: Value(semesterModel.updatedAt ?? DateTime.now()),
        isSynced: const Value(false),
        deleted: const Value(false),
      ),
    );
  }

  Future<SemesterModel> createLocalSemester({
    required String name,
    required int order, // ✅ يتطلب الترتيب
    required String gradeId,
    String? description,
  }) async {
    final id = _uuid.v4();
    final now = DateTime.now();
    final newSemester = SemesterModel(
      id: id,
      name: name,
      order: order,
      gradeId: gradeId,
      description: description,
      createdAt: now,
      updatedAt: now,
      isSynced: false,
      deleted: false,
    );
    await insertSemesterModel(newSemester);
    return newSemester;
  }

  Future<void> updateSemesterLocal(SemesterModel semesterModel) async {
    final now = DateTime.now();
    await (db.update(db.semesters)..where((t) => t.id.equals(semesterModel.id))).write(
      SemestersCompanion(
        name: Value(semesterModel.name),
        order: Value(semesterModel.order), // ✅ استخدام حقل الترتيب
        gradeId: Value(semesterModel.gradeId),
        description: Value(semesterModel.description),
        updatedAt: Value(now),
        isSynced: const Value(false),
        deleted: Value(semesterModel.deleted),
      ),
    );
  }

  Future<void> markAsDeleted(String id) async {
    await (db.update(db.semesters)..where((t) => t.id.equals(id))).write(
      SemestersCompanion(deleted: const Value(true), isSynced: const Value(false), updatedAt: Value(DateTime.now())),
    );
  }

  Future<void> deleteSemesterPermanently(String id) async {
    await (db.delete(db.semesters)..where((t) => t.id.equals(id))).go();
  }

  Future<List<SemesterModel>> getPendingSync() async {
    final rows = await (db.select(db.semesters)..where((t) => t.isSynced.equals(false))).get();
    return rows.map(_fromRow).toList();
  }

  Future<void> updateSemesterSynced(String id, {DateTime? updatedAt}) async {
    await (db.update(db.semesters)..where((t) => t.id.equals(id))).write(
      SemestersCompanion(
        isSynced: const Value(true),
        updatedAt: Value(updatedAt ?? DateTime.now()),
      ),
    );
  }

  Future<void> upsertSemester(SemesterModel semesterFromServer) async {
    await db.into(db.semesters).insertOnConflictUpdate(
      SemestersCompanion(
        id: Value(semesterFromServer.id),
        name: Value(semesterFromServer.name),
        order: Value(semesterFromServer.order), // ✅ استخدام حقل الترتيب
        gradeId: Value(semesterFromServer.gradeId),
        description: Value(semesterFromServer.description),
        createdAt: Value(semesterFromServer.createdAt ?? DateTime.now()),
        updatedAt: Value(semesterFromServer.updatedAt ?? DateTime.now()),
        isSynced: const Value(true),
        deleted: Value(semesterFromServer.deleted),
      ),
    );
  }
}