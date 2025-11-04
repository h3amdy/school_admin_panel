// lib/data/local/tables/subjects.dart
import 'package:ashil_school/data/local/tables/grades.dart';
import 'package:ashil_school/data/local/tables/semesters.dart';
import 'package:drift/drift.dart';

@DataClassName('Subject')
class Subjects extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get order => integer().nullable()(); // ✅ تم جعله اختياري
  TextColumn get semesterId => text().references(Semesters, #id)();
  TextColumn get gradeId => text().references(Grades, #id)();
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

