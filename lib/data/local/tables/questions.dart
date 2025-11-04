//lib/data/local/tables/app_database.dart
import 'package:drift/drift.dart';

@DataClassName('QuestionTable')
class Questions extends Table {
  TextColumn get id => text()(); // uuid
  TextColumn get lessonId => text()();
  TextColumn get questionText => text()();
  TextColumn get type => text()();
  TextColumn get data => text()();
  // حقل جديد: شرح الإجابة الصحيحة للتغذية الراجعة
  TextColumn get explanation => text().nullable()(); 

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();
  BoolColumn get deleted =>
      boolean().withDefault(const Constant(false))(); 
  IntColumn get order => integer().nullable()();

  BoolColumn get isSynced =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}