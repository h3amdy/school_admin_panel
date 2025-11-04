import 'package:ashil_school/data/repositories/local/grade_local_repository.dart';
import 'package:ashil_school/data/repositories/remote/grade_remote_repository.dart';
import 'package:ashil_school/data/repositories/sync_repository.dart';
import 'package:ashil_school/data/services/sync/syncable.dart';

class GradeSyncService implements Syncable{
  final GradeLocalRepository localRepo;
  final GradeRemoteRepository remoteRepo;
  final SyncRepository syncRepo;
 @override
  String get entity => 'grades';

  GradeSyncService({
    required this.localRepo,
    required this.remoteRepo,
    required this.syncRepo,
  });

  @override
  Future<void> pushPending() async {
    final pending = await localRepo.getPendingSync();
    if (pending.isEmpty) return;

    try {
      await remoteRepo.pushGrades(pending);
      for (final g in pending) {
        await localRepo.updateGradeSynced(g.id);
      }
    } catch (e) {
      print("Error pushing grades: $e");
    }
  }

  @override
  Future<void>  pullUpdates(DateTime? lastSyncAt) async {
    try {
      final updated = await remoteRepo.fetchUpdatedGrades(lastSyncAt);
      for (final g in updated) {
        if (g.deleted == true) {
          await localRepo.deleteGradePermanently(g.id);
        } else {
          await localRepo.upsertGrade(g);
        }
      }
      await syncRepo.updateSync(entity);
    } catch (e) {
      print("Error fetching grades: $e");
    }
  }
  
}
