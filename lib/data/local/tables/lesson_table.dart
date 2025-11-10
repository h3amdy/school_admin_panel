import 'package:drift/drift.dart';

@DataClassName('LessonTable')
class Lessons extends Table {
  TextColumn get id => text()();
  TextColumn get title => text().withLength(min: 3, max: 255)();
  
  // [تعديل] 1. حقل المحتوى القديم (content) سيُستخدم الآن لتخزين قائمة كتل المحتوى
  // على هيئة JSON String
  TextColumn get content => text().named('content').clientDefault(() => '[]')();

  TextColumn get unitId => text()();
  IntColumn get order => integer().nullable()();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  // [جديد] 2. إضافة الحقول الجديدة
  TextColumn get profileImageUrl => text().named('profile_image_url').nullable()();
  TextColumn get audioUrl => text().named('audio_url').nullable()();

  // لإدارة المزامنة
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}