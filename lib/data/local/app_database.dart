// lib/data/local/tables/app_database.dart
import 'package:ashil_school/data/local/tables/grades.dart';
import 'package:ashil_school/data/local/tables/lesson_table.dart';
import 'package:ashil_school/data/local/tables/questions.dart';
import 'package:ashil_school/data/local/tables/semesters.dart';
import 'package:ashil_school/data/local/tables/subjects.dart';
import 'package:ashil_school/data/local/tables/sync_logs.dart';
import 'package:ashil_school/data/local/tables/teachers.dart';
import 'package:ashil_school/data/local/tables/units.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';
part 'app_database.g.dart';



@DriftDatabase(tables: [Teachers,SyncLogs,Grades, Semesters,Subjects,Units,Lessons,Questions])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3; 
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'school.sqlite'));
    return NativeDatabase(file);
  });
}

/// لتحويل List<String> إلى نص
class StringListConverter extends TypeConverter<List<String>, String> {
  const StringListConverter();
  @override
  List<String> fromSql(String fromDb) =>
      fromDb.isEmpty ? [] : fromDb.split(',');
  @override
  String toSql(List<String> value) => value.join(',');
}
