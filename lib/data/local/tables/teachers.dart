// lib/data/local/tables/teachers.dart
import 'package:ashil_school/data/local/app_database.dart';
import 'package:drift/drift.dart';

class Teachers extends Table {
  // الحقول الأساسية
  TextColumn get id => text().named('id')();
  TextColumn get username => text().named('username')();
  TextColumn get phone => text().named('phone').nullable()();
  TextColumn get fullName => text().named('fullName').nullable()();
  TextColumn get password => text().named('password')();
  TextColumn get role => text().named('role').withDefault(const Constant('teacher'))();

  // حقول خاصة بالمعلمين
  TextColumn get specialization => text().named('specialization').nullable()();
  TextColumn get assignedSubjects => text().named('assignedSubjects').map(const StringListConverter()).nullable()();

  // حقول المزامنة
  BoolColumn get isSynced => boolean().named('isSynced').withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().named('createdAt').nullable()();
  DateTimeColumn get updatedAt => dateTime().named('updatedAt').nullable()();
  BoolColumn get deleted => boolean().named('deleted').withDefault(const Constant(false))();
  DateTimeColumn get deletedAt => dateTime().named('deletedAt').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// ⚠️ ملاحظة: يجب أن يكون لديك StringListConverter في ملف app_database.dart
// كما فعلنا في السابق.