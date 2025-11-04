import 'package:ashil_school/data/repositories/local/lesson_local_repository.dart';
import 'package:ashil_school/data/repositories/remote/lesson_remote_repository.dart';
import 'package:ashil_school/data/repositories/sync_repository.dart';
import 'package:ashil_school/data/services/sync/syncable.dart';

class LessonSyncService implements Syncable {
  final LessonLocalRepository localRepo;
  final LessonRemoteRepository remoteRepo;
  final SyncRepository syncRepo;

  @override
  String get entity => 'lessons';

  LessonSyncService({
    required this.localRepo,
    required this.remoteRepo,
    required this.syncRepo,
  });

  @override
  Future<void> pushPending() async {
    final pending = await localRepo.getPendingSync();
    if (pending.isNotEmpty) {
      await remoteRepo.pushLessons(pending);
      for (final l in pending) {
        await localRepo.updateLessonSynced(l.id);
      }
    }
  }

  @override
  Future<void> pullUpdates(DateTime? lastSyncAt) async {
    final updatedFromServer = await remoteRepo.fetchUpdatedLessons(lastSyncAt);
    for (final l in updatedFromServer) {
      if (l.deleted == true) {
        await localRepo.deleteLessonPermanently(l.id);
      } else {
        await localRepo.upsertLesson(l);
      }
    }
  }
}
