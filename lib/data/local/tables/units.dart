// lib/data/local/tables/units.dart
import 'package:ashil_school/data/local/tables/subjects.dart';
import 'package:drift/drift.dart';

@DataClassName('Unit')
class Units extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get order => integer().nullable()();
  TextColumn get subjectId => text().references(Subjects, #id)();
  TextColumn get description => text().nullable()();

  // التواريخ
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  // للمزامنة
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
