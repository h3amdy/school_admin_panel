import 'package:drift/drift.dart';

@DataClassName('LessonTable')
class Lessons extends Table {
  TextColumn get id => text()();
  TextColumn get title => text().withLength(min: 3, max: 255)();
  TextColumn get content => text()();
  TextColumn get unitId => text()();
  IntColumn get order => integer().nullable()();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  // لإدارة المزامنة
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
