// lib/data/local/repository sync_repository.dart
import 'package:ashil_school/data/local/app_database.dart';
import 'package:drift/drift.dart';
import 'package:get/get.dart' hide Value;

class SyncRepository {
  final AppDatabase db= Get.find<AppDatabase>() ;
  SyncRepository();

  // ✅ جلب آخر وقت مزامنة لكيان
  Future<DateTime?> getLastSync(String entity, {String? parentId}) async {
    final query = await (db.select(db.syncLogs)
          ..where((tbl) =>
              tbl.entity.equals(entity) &
              (parentId != null
                  ? tbl.parentId.equals(parentId)
                  : const Constant(true))))
        .getSingleOrNull();

    return query?.lastSyncAt;
  }

  // ✅ تحديث أو إدخال وقت المزامنة
  Future<void> updateSync(String entity,
      {String? parentId, DateTime? time}) async {
    final existing = await (db.select(db.syncLogs)
          ..where((tbl) =>
              tbl.entity.equals(entity) &
              (parentId != null
                  ? tbl.parentId.equals(parentId)
                  : const Constant(true))))
        .getSingleOrNull();

    final now = time ?? DateTime.now();

    if (existing == null) {
      await db.into(db.syncLogs).insert(SyncLogsCompanion.insert(
            entity: entity,
            parentId: Value(parentId),
            lastSyncAt: now,
          ));
    } else {
      await (db.update(db.syncLogs)
            ..where((tbl) => tbl.id.equals(existing.id)))
          .write(SyncLogsCompanion(lastSyncAt: Value(now)));
    }
  }

  // ✅ هل نحتاج مزامنة؟
  Future<bool> needsSync(String entity,
      {String? parentId, Duration? duration}) async {
    final lastSync = await getLastSync(entity, parentId: parentId);

    if (lastSync == null) return true; // أول مرة
    if (duration == null) return false; // إذا ما فيه شرط مدة

    return DateTime.now().difference(lastSync) > duration;
  }
}
