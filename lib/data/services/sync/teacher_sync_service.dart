// lib/data/services/teacher_sync_service.dart
import 'package:ashil_school/Utils/constants/database_constant.dart';
import 'package:ashil_school/data/repositories/local/teacher_local_repository.dart';
import 'package:ashil_school/data/repositories/remote/teacher_remote_repository.dart';
import 'package:ashil_school/data/repositories/sync_repository.dart';
import 'package:ashil_school/data/services/sync/syncable.dart';
import 'package:ashil_school/models/user_model/user.dart';

class TeacherSyncService implements Syncable {
  final TeacherLocalRepository localRepo;
  final TeacherRemoteRepository remoteRepo;
  final SyncRepository syncRepo;

  TeacherSyncService({
    required this.localRepo,
    required this.remoteRepo,
    required this.syncRepo,
  });
  @override
  String get entity => DBConstants.teacherTable;

  // Future<void> syncTeachers() async {
  //   // 1. مزامنة التغييرات المحلية إلى السيرفر
  //   await pushPending();

  //   // 2. جلب التغييرات من السيرفر وتحديث القاعدة المحلية
  //   await pullUpdates();
  // }

  @override
  Future<void> pushPending() async {
    final pending = await localRepo.getUnsyncedTeachers();
    final deletedUnsyncedTeachers =
        await localRepo.getDeletedUnsyncedTeachers();

    // معالجة المعلمين الذين تم تعديلهم أو إضافتهم
    if (pending.isNotEmpty) {
      for (var teacherEntry in pending) {
        final userModel = User.fromLocalTeacher(teacherEntry);
        try {
          final syncedTeacher = await remoteRepo.pushChangesToServer(userModel);
          await localRepo.markAsSynced(syncedTeacher.id);
        } catch (e) {
          // يمكنك إضافة منطق معالجة الأخطاء هنا (مثل تسجيل الخطأ)
          print('Failed to sync teacher: ${userModel.id}, error: $e');
        }
      }
    }

    // معالجة المعلمين الذين تم حذفهم
    for (var teacherEntry in deletedUnsyncedTeachers) {
      try {
        await remoteRepo
            .pushChangesToServer(User.fromLocalTeacher(teacherEntry));
        await localRepo.deleteTeacherPermanently(teacherEntry.id);
      } catch (e) {
        print(
            'Failed to sync deletion for teacher: ${teacherEntry.id}, error: $e');
      }
    }
  }
   @override
  Future<void> pullUpdates(DateTime? lastSyncAt) async {
    try {
      final remoteTeachers = await remoteRepo.fetchTeachersFromRemote();
      await localRepo.upsertTeachersFromRemote(remoteTeachers);
      await syncRepo.updateSync('teachers');
    } catch (e) {
      print('Failed to pull remote teachers, error: $e');
    }
  }
}
