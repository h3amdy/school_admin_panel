// lib/data/repositories/local/unit_local_repository.dart
import 'package:ashil_school/data/local/app_database.dart';
import 'package:ashil_school/features/unit/models/unit.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:get/get.dart' hide Value;
import 'package:uuid/uuid.dart';

class UnitLocalRepository {
  final AppDatabase db = Get.find<AppDatabase>();
  final _uuid = const Uuid();

  UnitModel _fromRow(Unit row) {
    return UnitModel.fromLocalUnit(row);
  }

  Future<List<UnitModel>> getAll({bool includeDeleted = false}) async {
    final query = db.select(db.units)
      ..orderBy([(t) => OrderingTerm.asc(t.order)]);
    if (!includeDeleted) {
      query.where((tbl) => tbl.deleted.equals(false));
    }
    final rows = await query.get();
    return rows.map(_fromRow).toList();
  }

  Future<List<UnitModel>> getUnitsBySubjectId(String subjectId,
      {bool includeDeleted = false}) async {
    final query = db.select(db.units)
      ..where((t) => t.subjectId.equals(subjectId))
      ..orderBy([(t) => OrderingTerm.asc(t.order)]);
    if (!includeDeleted) {
      query.where((tbl) => tbl.deleted.equals(false));
    }
    final rows = await query.get();
    return rows.map(_fromRow).toList();
  }

  Future<UnitModel?> getById(String id) async {
    final row = await (db.select(db.units)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row != null ? _fromRow(row) : null;
  }

  Future<void> insertUnitModel(UnitModel unitModel) async {
    await db.into(db.units).insert(
          UnitsCompanion.insert(
            id: unitModel.id,
            name: unitModel.name,
            order: Value(unitModel.order),
            subjectId: unitModel.subjectId,
            description: Value(unitModel.description),
            createdAt: Value(unitModel.createdAt ?? DateTime.now()),
            updatedAt: Value(unitModel.updatedAt ?? DateTime.now()),
            isSynced: const Value(false),
            deleted: const Value(false),
          ),
        );
  }

  Future<UnitModel> createLocalUnit({
    required String name,
    int? order,
    required String subjectId,
    String? description,
  }) async {
    final id = _uuid.v4();
    final now = DateTime.now();
    final newUnit = UnitModel(
      id: id,
      name: name,
      order: order,
      subjectId: subjectId,
      description: description,
      createdAt: now,
      updatedAt: now,
      isSynced: false,
      deleted: false,
    );
    await insertUnitModel(newUnit);
    return newUnit;
  }

  Future<void> updateUnitLocal(UnitModel unitModel) async {
    final now = DateTime.now();
    await (db.update(db.units)..where((t) => t.id.equals(unitModel.id))).write(
      UnitsCompanion(
        name: Value(unitModel.name),
        order: Value(unitModel.order),
        subjectId: Value(unitModel.subjectId),
        description: Value(unitModel.description),
        updatedAt: Value(now),
        isSynced: const Value(false),
        deleted: Value(unitModel.deleted),
      ),
    );
  }

  Future<void> markAsDeleted(String id) async {
    await (db.update(db.units)..where((t) => t.id.equals(id))).write(
      UnitsCompanion(
          deleted: const Value(true),
          isSynced: const Value(false),
          updatedAt: Value(DateTime.now())),
    );
  }

  Future<void> deleteUnitPermanently(String id) async {
    await (db.delete(db.units)..where((t) => t.id.equals(id))).go();
  }

  Future<List<UnitModel>> getPendingSync() async {
    final rows = await (db.select(db.units)
          ..where((t) => t.isSynced.equals(false)))
        .get();
    return rows.map(_fromRow).toList();
  }

  Future<void> updateUnitSynced(String id, {DateTime? updatedAt}) async {
    await (db.update(db.units)..where((t) => t.id.equals(id))).write(
      UnitsCompanion(
        isSynced: const Value(true),
        updatedAt: Value(updatedAt ?? DateTime.now()),
      ),
    );
  }

  Future<void> upsertUnit(UnitModel unitFromServer) async {
    await db.into(db.units).insertOnConflictUpdate(
          UnitsCompanion(
            id: Value(unitFromServer.id),
            name: Value(unitFromServer.name),
            order: Value(unitFromServer.order),
            subjectId: Value(unitFromServer.subjectId),
            description: Value(unitFromServer.description),
            createdAt: Value(unitFromServer.createdAt ?? DateTime.now()),
            updatedAt: Value(unitFromServer.updatedAt ?? DateTime.now()),
            isSynced: const Value(true),
            deleted: Value(unitFromServer.deleted),
          ),
        );
  }
}
