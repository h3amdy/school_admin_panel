import 'package:ashil_school/data/repositories/local/unit_local_repository.dart';
import 'package:ashil_school/data/repositories/remote/unit_remote_repository.dart';
import 'package:ashil_school/data/repositories/sync_repository.dart';
import 'package:ashil_school/data/services/sync/syncable.dart';

class UnitSyncService implements Syncable {
  final UnitLocalRepository localRepo;
  final UnitRemoteRepository remoteRepo;
  final SyncRepository syncRepo;
   @override
  String get entity => 'units';

  UnitSyncService({
    required this.localRepo,
    required this.remoteRepo,
    required this.syncRepo,
  });

  @override
  Future<void> pushPending() async {
    final pending = await localRepo.getPendingSync();
    if (pending.isEmpty) return;

    try {
      await remoteRepo.pushUnits(pending);
      for (final s in pending) {
        await localRepo.updateUnitSynced(s.id);
      }
    } catch (e) {
      print("Error pushing units: $e");
    }
  }

  @override
  Future<void> pullUpdates(DateTime? lastSyncAt) async {
   try {
      final updatedFromServer = await remoteRepo.fetchUpdatedUnits(lastSyncAt);
      for (final s in updatedFromServer) {
        if (s.deleted == true) {
          await localRepo.deleteUnitPermanently(s.id);
        } else {
          await localRepo.upsertUnit(s);
        }
      }
      await syncRepo.updateSync(entity);
    } catch (e) {
      print("Error pulling units: $e");
    }
  }

 
}
