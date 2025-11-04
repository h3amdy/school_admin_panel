abstract class Syncable {
  String get entity;

  Future<void> pushPending();
  Future<void> pullUpdates(DateTime? lastSyncAt);
}
