import 'package:drift/drift.dart';

class SyncLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get entity => text()(); // نوع الكيان: Teacher, Subject, Class, ...
  TextColumn get parentId => text().nullable()(); // الكيان الأب (مثلاً gradeId للفصول)
  DateTimeColumn get lastSyncAt => dateTime()(); // آخر وقت مزامنة
}
