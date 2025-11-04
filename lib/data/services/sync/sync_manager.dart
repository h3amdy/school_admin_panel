import 'package:ashil_school/data/repositories/sync_repository.dart';
import 'package:ashil_school/data/services/sync/syncable.dart';

class SyncManager {
  final SyncRepository syncRepo;
  final List<Syncable> services;

  SyncManager({required this.syncRepo, required this.services});

  Future<void> syncAll() async {
    for (final service in services) {
      final lastSyncAt = await syncRepo.getLastSync(service.entity);

      try {
        await service.pushPending();
      } catch (e) {
        print("Error pushing ${service.entity}: $e");
      }

      try {
        await service.pullUpdates(lastSyncAt);
      } catch (e) {
        print("Error pulling ${service.entity}: $e");
      }

      await syncRepo.updateSync(service.entity);
    }
  }
}
