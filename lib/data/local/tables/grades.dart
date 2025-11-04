// lib/data/local/tables/grades.dart
import 'package:drift/drift.dart';

class Grades extends Table {
  TextColumn get id => text()(); // id من الجهاز (UUID أو NanoId)
  TextColumn get name => text()();
  IntColumn get order => integer()();
  TextColumn get description => text().nullable()();

  // التواريخ
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  // لإدارة المزامنة
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
