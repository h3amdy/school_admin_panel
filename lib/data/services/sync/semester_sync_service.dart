import 'package:ashil_school/data/repositories/local/semester_local_repository.dart';
import 'package:ashil_school/data/repositories/remote/semester_remote_repository.dart';
import 'package:ashil_school/data/repositories/sync_repository.dart';
import 'package:ashil_school/data/services/sync/syncable.dart';

class SemesterSyncService implements Syncable {
  final SemesterLocalRepository localRepo;
  final SemesterRemoteRepository remoteRepo;
  final SyncRepository syncRepo;
  @override
  String get entity => 'semesters';

  SemesterSyncService({
    required this.localRepo,
    required this.remoteRepo,
    required this.syncRepo,
  });

  @override
  Future<void> pushPending() async {
    final pending = await localRepo.getPendingSync();
    if (pending.isEmpty) return;

    try {
      await remoteRepo.pushSemesters(pending);
      for (final s in pending) {
        await localRepo.updateSemesterSynced(s.id);
      }
    } catch (e) {
      print("Error pushing semesters: $e");
    }
  }

  @override
  Future<void> pullUpdates(DateTime? lastSyncAt) async {
   try {
      final updatedFromServer = await remoteRepo.fetchUpdatedSemesters(lastSyncAt);
      for (final s in updatedFromServer) {
        if (s.deleted == true) {
          await localRepo.deleteSemesterPermanently(s.id);
        } else {
          await localRepo.upsertSemester(s);
        }
      }
      await syncRepo.updateSync(entity);
    } catch (e) {
      print("Error pulling semesters: $e");
    }
  }

 
}
