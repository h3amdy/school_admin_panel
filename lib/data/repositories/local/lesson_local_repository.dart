import 'package:ashil_school/data/local/app_database.dart';
import 'package:ashil_school/features/lesson/models/lesson.dart';
import 'package:drift/drift.dart';
import 'package:get/get.dart' hide Value;
import 'package:uuid/uuid.dart';

class LessonLocalRepository {
  final AppDatabase db = Get.find<AppDatabase>();
  final _uuid = const Uuid();

  LessonLocalRepository();

  LessonModel _fromRow(LessonTable row) {
    return LessonModel(
      id: row.id,
      title: row.title,
      content: row.content,
      unitId: row.unitId,
      order: row.order,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      isSynced: row.isSynced,
      deleted: row.deleted,
    );
  }

  Future<List<LessonModel>> getAllLessonsByUnitId(String unitId, {bool includeDeleted = false}) async {
    final query = db.select(db.lessons)..where((tbl) => tbl.unitId.equals(unitId));
    if (!includeDeleted) {
      query.where((tbl) => tbl.deleted.equals(false));
    }
    final rows = await query.get();
    return rows.map(_fromRow).toList();
  }

  Future<LessonModel> createLocalLesson({
    required String title,
    required String content,
    required String unitId,
    int? order,
  }) async {
    final id = _uuid.v4();
    final now = DateTime.now();
    final lesson = LessonModel(
      id: id,
      title: title,
      content: content,
      unitId: unitId,
      order: order,
      createdAt: now,
      updatedAt: now,
    );
    await db.into(db.lessons).insert(
          LessonsCompanion.insert(
            id: lesson.id,
            title: lesson.title,
            content: lesson.content,
            unitId: lesson.unitId,
            order: Value(lesson.order),
            createdAt: Value(lesson.createdAt!),
            updatedAt: Value(lesson.updatedAt!),
            isSynced: const Value(false),
            deleted: const Value(false),
          ),
        );
    return lesson;
  }

  Future<void> updateLessonLocal(LessonModel lesson) async {
    final now = DateTime.now();
    await (db.update(db.lessons)..where((t) => t.id.equals(lesson.id))).write(
          LessonsCompanion(
            title: Value(lesson.title),
            content: Value(lesson.content),
            unitId: Value(lesson.unitId),
            order: Value(lesson.order),
            updatedAt: Value(now),
            isSynced: const Value(false),
            deleted: Value(lesson.deleted),
          ),
        );
  }

  Future<void> markAsDeleted(String id) async {
    await (db.update(db.lessons)..where((t) => t.id.equals(id))).write(
          const LessonsCompanion(deleted: Value(true), isSynced: Value(false)),
        );
  }

  Future<void> deleteLessonPermanently(String id) async {
    await (db.delete(db.lessons)..where((t) => t.id.equals(id))).go();
  }

  Future<List<LessonModel>> getPendingSync() async {
    final rows = await (db.select(db.lessons)..where((t) => t.isSynced.equals(false))).get();
    return rows.map(_fromRow).toList();
  }

  Future<void> updateLessonSynced(String id, {DateTime? updatedAt}) async {
    await (db.update(db.lessons)..where((t) => t.id.equals(id))).write(
          LessonsCompanion(
            isSynced: const Value(true),
            updatedAt: Value(updatedAt ?? DateTime.now()),
          ),
        );
  }

  Future<void> upsertLesson(LessonModel lessonFromServer) async {
    await db.into(db.lessons).insertOnConflictUpdate(
          LessonsCompanion.insert(
            id: lessonFromServer.id,
            title: lessonFromServer.title,
            content: lessonFromServer.content,
            unitId: lessonFromServer.unitId,
            order: Value(lessonFromServer.order),
            createdAt: Value(lessonFromServer.createdAt!),
            updatedAt: Value(lessonFromServer.updatedAt!),
            isSynced: const Value(true),
            deleted: Value(lessonFromServer.deleted),
          ),
        );
  }
}
