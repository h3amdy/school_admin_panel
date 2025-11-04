import 'package:ashil_school/data/repositories/local/question_local_repository.dart';
import 'package:ashil_school/data/repositories/remote/question_remote_repository.dart';
import 'package:ashil_school/data/repositories/sync_repository.dart';
import 'package:ashil_school/data/services/sync/syncable.dart';

class QuestionSyncService implements Syncable {
  final QuestionLocalRepository localRepo;
  final QuestionRemoteRepository remoteRepo;
  final SyncRepository syncRepo;

  @override
  String get entity => 'questions';

  QuestionSyncService({
    required this.localRepo,
    required this.remoteRepo,
    required this.syncRepo,
  });

  @override
  Future<void> pushPending() async {
    final pending = await localRepo.getPendingSync();
    if (pending.isNotEmpty) {
      await remoteRepo.pushQuestions(pending);
      for (final q in pending) {
        await localRepo.updateQuestionSynced(q.id);
      }
    }
  }

  @override
  Future<void> pullUpdates(DateTime? lastSyncAt) async {
    final updatedFromServer = await remoteRepo.fetchUpdatedQuestions(lastSyncAt);
    for (final q in updatedFromServer) {
      if (q.deleted) {
        await localRepo.deleteQuestionPermanently(q.id);
      } else {
        await localRepo.upsertQuestion(q);
      }
    }
  }
}