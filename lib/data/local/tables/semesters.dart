// lib/data/local/tables/semesters.dart
import 'package:ashil_school/data/local/tables/grades.dart';
import 'package:drift/drift.dart';

class Semesters extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get order => integer()(); // ✅ تم إضافة حقل الترتيب
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

