// lib/data/repositories/local/teacher_local_repository.dart
import 'package:ashil_school/data/local/app_database.dart';
import 'package:ashil_school/models/user_model/user.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:get/get.dart' hide Value;
import 'package:uuid/uuid.dart';

class TeacherLocalRepository {
  final AppDatabase _db = Get.find<AppDatabase>();
  final _uuid = const Uuid();

  TeacherLocalRepository();

  /// 1. إنشاء معلم جديد محلياً (قبل المزامنة)
  Future<User> createLocalTeacher({
    required String username,
    required String password,
    String? fullName,
    String? phone,
    String? specialization,
    List<String>? assignedSubjects,
  }) async {
    final newId = _uuid.v4();
    final now = DateTime.now();

    final teacherEntry = TeachersCompanion.insert(
      id: newId,
      username: username,
      password: password,
      fullName: Value(fullName),
      phone: Value(phone),
      specialization: Value(specialization),
      assignedSubjects: Value(assignedSubjects),
      isSynced: const Value(false),
      deleted: const Value(false),
      createdAt: Value(now),
      updatedAt: Value(now),
    );

    await _db.into(_db.teachers).insert(teacherEntry);

    // ✅ تصحيح: يجب استخدام getSingle() في نهاية الاستعلام
    final createdTeacher = await (_db.select(_db.teachers)
          ..where((t) => t.id.equals(newId)))
        .getSingle();

    return User.fromLocalTeacher(createdTeacher);
  }

  /// 2. جلب جميع المعلمين
  Future<List<User>> getAll() async {
    final teachers = await (_db.select(_db.teachers)
          ..where((t) => t.deleted.equals(false)))
        .get();

    return teachers.map((teacher) => User.fromLocalTeacher(teacher)).toList();
  }

  /// 3. جلب المعلمين غير المتزامنين
  Future<List<Teacher>> getUnsyncedTeachers() async {
    return await (_db.select(_db.teachers)
          ..where((t) => t.isSynced.equals(false)))
        .get();
  }

  /// 4. جلب المعلمين المحذوفين غير المتزامنين
  Future<List<Teacher>> getDeletedUnsyncedTeachers() async {
    return await (_db.select(_db.teachers)
          ..where((t) => t.isSynced.equals(false) & t.deleted.equals(true)))
        .get();
  }

  /// 5. تحديث معلم موجود محلياً
  Future<void> updateTeacherLocal(User teacher) async {
    await (_db.update(_db.teachers)..where((t) => t.id.equals(teacher.id)))
        .write(TeachersCompanion(
      username: Value(teacher.username),
      password: Value(teacher.password!),
      fullName: Value(teacher.fullName),
      phone: Value(teacher.phone),
      specialization: Value(teacher.specialization),
      assignedSubjects: Value(teacher.assignedSubjects),
      isSynced: const Value(false),
      updatedAt: Value(DateTime.now()),
    ));
  }

  /// 6. تحديث المعلمين من السيرفر
  Future<void> upsertTeachersFromRemote(List<User> remoteTeachers) async {
    for (final remoteTeacher in remoteTeachers) {
      await _db.into(_db.teachers).insert(
        remoteTeacher.toCompanion(),
        mode: InsertMode.insertOrReplace,
      );
    }
  }

  /// 7. تحديث حالة المزامنة
  Future<void> markAsSynced(String id) async {
    await (_db.update(_db.teachers)..where((t) => t.id.equals(id)))
        .write(const TeachersCompanion(isSynced: Value(true)));
  }

  /// 8. وضع علامة الحذف على معلم
  Future<void> markAsDeleted(String id) async {
    await (_db.update(_db.teachers)..where((t) => t.id.equals(id)))
        .write(TeachersCompanion(
      deleted: const Value(true),
      isSynced: const Value(false),
      deletedAt: Value(DateTime.now()),
    ));
  }

  /// 9. حذف معلم بشكل دائم
  Future<void> deleteTeacherPermanently(String id) async {
    await (_db.delete(_db.teachers)..where((t) => t.id.equals(id))).go();
  }
}

// ✅ إضافة هذه الدالة المساعدة
extension on User {
  TeachersCompanion toCompanion() {
    return TeachersCompanion(
      id: Value(id),
      username: Value(username),
      password: Value(password!),
      fullName: Value(fullName),
      phone: Value(phone),
      specialization: Value(specialization),
      assignedSubjects: Value(assignedSubjects),
      isSynced: Value(isSynced ?? false),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deleted: Value(deleted ?? false),
      deletedAt: Value(deletedAt),
    );
  }
}