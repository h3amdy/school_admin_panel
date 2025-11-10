import 'dart:convert';
import 'package:ashil_school/data/local/app_database.dart';
import 'package:ashil_school/features/lesson/models/content_block.dart';
import 'package:ashil_school/features/lesson/models/lesson.dart';
import 'package:drift/drift.dart';
import 'package:get/get.dart' hide Value;
import 'package:uuid/uuid.dart';

class LessonLocalRepository {
  final AppDatabase db = Get.find<AppDatabase>();
  final _uuid = const Uuid();

  LessonLocalRepository();

  // [تعديل] 1. تحديث _fromRow ليقرأ الحقول الجديدة
  LessonModel _fromRow(LessonTable row) {
    List<ContentBlock> blocks = [];
    try {
      final List<dynamic> decoded = jsonDecode(row.content);
      blocks = decoded
          .map((item) => ContentBlock.fromMap(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      blocks = [];
    }

    return LessonModel(
      id: row.id,
      title: row.title,
      unitId: row.unitId,
      order: row.order,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      isSynced: row.isSynced,
      deleted: row.deleted,
      profileImageUrl: row.profileImageUrl,
      audioUrl: row.audioUrl,
      contentBlocks: blocks,
    );
  }
  
  Future<LessonModel?> getLessonById(String id) async {
    final query = db.select(db.lessons)..where((tbl) => tbl.id.equals(id));
    final row = await query.getSingleOrNull();
    if (row != null) {
      return _fromRow(row);
    }
    return null;
  }

  Future<List<LessonModel>> getAllLessonsByUnitId(String unitId, {bool includeDeleted = false}) async {
    final query = db.select(db.lessons)..where((tbl) => tbl.unitId.equals(unitId));
    if (!includeDeleted) {
      query.where((tbl) => tbl.deleted.equals(false));
    }
    final rows = await query.get();
    return rows.map(_fromRow).toList();
  }

  // [تعديل] 2. تحديث createLocalLesson ليأخذ LessonModel كاملاً
  Future<LessonModel> createLocalLesson(LessonModel lesson) async {
    // نضمن أن له ID و timestamps
    final now = DateTime.now();
    final lessonToInsert = lesson.copyWith(
      id: lesson.id.isEmpty ? _uuid.v4() : lesson.id,
      createdAt: lesson.createdAt ?? now,
      updatedAt: now,
      isSynced: false,
      deleted: false,
    );

    await db.into(db.lessons).insert(
          LessonsCompanion.insert(
            id: lessonToInsert.id,
            title: lessonToInsert.title,
            unitId: lessonToInsert.unitId,
            order: Value(lessonToInsert.order),
            createdAt: Value(lessonToInsert.createdAt!),
            updatedAt: Value(lessonToInsert.updatedAt!),
            isSynced: const Value(false),
            deleted: const Value(false),
            // [جديد]
            profileImageUrl: Value(lessonToInsert.profileImageUrl),
            audioUrl: Value(lessonToInsert.audioUrl),
            // [إصلاح الخطأ 1] تغليف الناتج بـ Value()
            content: Value(jsonEncode(lessonToInsert.contentBlocks.map((b) => b.toMap()).toList())),
          ),
        );
    return lessonToInsert;
  }

  // [تعديل] 3. تحديث updateLessonLocal
  Future<void> updateLessonLocal(LessonModel lesson) async {
    final now = DateTime.now();
    final jsonContent = jsonEncode(lesson.contentBlocks.map((b) => b.toMap()).toList());

    await (db.update(db.lessons)..where((t) => t.id.equals(lesson.id))).write(
          LessonsCompanion(
            title: Value(lesson.title),
            unitId: Value(lesson.unitId),
            order: Value(lesson.order),
            updatedAt: Value(now),
            isSynced: const Value(false),
            deleted: Value(lesson.deleted),
            // [جديد]
            profileImageUrl: Value(lesson.profileImageUrl),
            audioUrl: Value(lesson.audioUrl),
            // [إصلاح الخطأ 1] تغليف الناتج بـ Value()
            content: Value(jsonContent),
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

  // [تعديل] 4. تحديث upsertLesson
  Future<void> upsertLesson(LessonModel lessonFromServer) async {
    final jsonContent = jsonEncode(lessonFromServer.contentBlocks.map((b) => b.toMap()).toList());

    await db.into(db.lessons).insertOnConflictUpdate(
          LessonsCompanion.insert(
            id: lessonFromServer.id,
            title: lessonFromServer.title,
            unitId: lessonFromServer.unitId,
            order: Value(lessonFromServer.order),
            createdAt: Value(lessonFromServer.createdAt ?? DateTime.now()), // التأكد من عدم إرسال null
            updatedAt: Value(lessonFromServer.updatedAt ?? DateTime.now()), // التأكد من عدم إرسال null
            isSynced: const Value(true),
            deleted: Value(lessonFromServer.deleted),
            // [جديد]
            profileImageUrl: Value(lessonFromServer.profileImageUrl),
            audioUrl: Value(lessonFromServer.audioUrl),
            // [إصلاح الخطأ 1] تغليف الناتج بـ Value()
            content: Value(jsonContent),
          ),
        );
  }
}