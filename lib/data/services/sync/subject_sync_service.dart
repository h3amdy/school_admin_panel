import 'package:ashil_school/data/repositories/local/subject_local_repository.dart';
import 'package:ashil_school/data/repositories/remote/subject_remote_repository.dart';
import 'package:ashil_school/data/repositories/sync_repository.dart';
import 'package:ashil_school/data/services/sync/syncable.dart';

class SubjectSyncService implements Syncable {
  final SubjectLocalRepository localRepo;
  final SubjectRemoteRepository remoteRepo;
  final SyncRepository syncRepo;

  @override
  String get entity => 'subjects';

  SubjectSyncService({
    required this.localRepo,
    required this.remoteRepo,
    required this.syncRepo,
  });

  @override
  Future<void> pushPending() async {
    final pending = await localRepo.getPendingSync();
    if (pending.isNotEmpty) {
      await remoteRepo.pushSubjects(pending);
      for (final s in pending) {
        await localRepo.updateSubjectSynced(s.id);
      }
    }
  }

  @override
  Future<void> pullUpdates(DateTime? lastSyncAt) async {
    print("رقم 2");
    final updatedFromServer = await remoteRepo.fetchUpdatedSubjects(lastSyncAt);
   
    for (final s in updatedFromServer) {
      if (s.deleted == true) {
        await localRepo.deleteSubjectPermanently(s.id);
      } else {
        await localRepo.upsertSubject(s);
      }
    }
  }
}
