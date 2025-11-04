// lib/features/subject/controllers/subject_controller.dart
import 'package:ashil_school/Utils/constants/database_constant.dart';
import 'package:ashil_school/Utils/helpers/loaders/loaders.dart';
import 'package:ashil_school/Utils/helpers/network_manger.dart';
import 'package:ashil_school/data/repositories/local/subject_local_repository.dart';
import 'package:ashil_school/data/repositories/remote/subject_remote_repository.dart';
import 'package:ashil_school/data/repositories/sync_repository.dart';
import 'package:ashil_school/data/services/sync/subject_sync_service.dart';
import 'package:ashil_school/features/subject/models/subject.dart';
import 'package:get/get.dart';

class SubjectController extends GetxController {
  final String gradeId;
  final RxnString semesterId;

  final subjects = <SubjectModel>[].obs;
  final isLoading = false.obs;
  final error = RxnString();
  final _isSyncing = false.obs;

  late final SubjectLocalRepository localRepo;
  late final SubjectRemoteRepository remoteRepo;
  late final SyncRepository syncRepo;
  late final SubjectSyncService syncService;

  SubjectController({required this.gradeId, required String? semesterId})
      : semesterId = RxnString(semesterId);

  @override
  void onInit() {
    super.onInit();
    localRepo = SubjectLocalRepository();
    remoteRepo = SubjectRemoteRepository();
    syncRepo = SyncRepository();
    syncService = SubjectSyncService(
        localRepo: localRepo, remoteRepo: remoteRepo, syncRepo: syncRepo);

    ever(semesterId, (_) => loadAndSyncSubjects());
  }

  Future<void> loadAndSyncSubjects() async {
    isLoading.value = true;
    error.value = null;
    try {
      if (semesterId.value == null) {
        subjects.clear();
        return;
      }
   
      final local = await localRepo.getSubjectsBySemesterId(semesterId.value!);
      subjects.assignAll(local);
      subjects.sort((a, b) {
        if (a.order == null && b.order == null) return 0;
        if (a.order == null) return 1;
        if (b.order == null) return -1;
        return a.order!.compareTo(b.order!);
      });
      isLoading.value = false;
      if (await NetworkManager.instance.isConnected()) {
        final lastSyncAt =
            await syncRepo.getLastSync(DBConstants.subjectsTable);
     
        await syncService.pullUpdates(lastSyncAt);
      
        final refreshed =
            await localRepo.getSubjectsBySemesterId(semesterId.value!);
        subjects.assignAll(refreshed);
        subjects.sort((a, b) {
          if (a.order == null && b.order == null) return 0;
          if (a.order == null) return 1;
          if (b.order == null) return -1;
          return a.order!.compareTo(b.order!);
        });
      } else {
        // KLoaders.warning(
        //   title: "لا يوجد اتصال بالإنترنت",
        //   message: "تم عرض البيانات المحلية فقط.",
        // );
      }
    } catch (e) {
      print("Error loading subjects: $e");
      error.value = e.toString();
      KLoaders.error(title: "خطأ في التحميل/المزامنة", message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void updateSemesterId(String? newSemesterId) {
    semesterId.value = newSemesterId;
  }

  Future<void> addSubject({
    required String name,
    int? order, // ✅ أصبح اختياري
    String? description,
  }) async {
    if (semesterId.value == null || _isSyncing.value) return;
    _isSyncing.value = true;
    try {
      final newSubject = await localRepo.createLocalSubject(
        name: name,
        order: order,
        semesterId: semesterId.value!,
        gradeId: gradeId,
        description: description,
      );

      subjects.add(newSubject);
      subjects.sort((a, b) {
        if (a.order == null && b.order == null) return 0;
        if (a.order == null) return 1;
        if (b.order == null) return -1;
        return a.order!.compareTo(b.order!);
      });

      if (await NetworkManager.instance.isConnected()) {
        await syncService.pushPending();
      }

      KLoaders.success(title: "نجاح", message: "تمت إضافة المادة بنجاح.");
    } catch (e) {
      error.value = e.toString();
      KLoaders.error(title: "خطأ في إضافة المادة", message: e.toString());
    } finally {
      isLoading.value = false;
      _isSyncing.value = false;
    }
  }

  Future<void> updateSubject(
    String id, {
    required String name,
    int? order, // ✅ أصبح اختياري
    String? description,
  }) async {
    if (_isSyncing.value) return;
    _isSyncing.value = true;
    try {
      final existingIndex = subjects.indexWhere((s) => s.id == id);
      if (existingIndex == -1) {
        throw Exception("المادة غير موجودة محلياً للتحرير.");
      }

      final updatedSubjectModel = SubjectModel(
        id: id,
        name: name,
        order: order,
        semesterId: semesterId.value!,
        gradeId: gradeId,
        description: description,
        createdAt: subjects[existingIndex].createdAt,
        updatedAt: DateTime.now(),
        deleted: subjects[existingIndex].deleted,
      );

      await localRepo.updateSubjectLocal(updatedSubjectModel);
      subjects[existingIndex] = updatedSubjectModel;
      subjects.sort((a, b) {
        if (a.order == null && b.order == null) return 0;
        if (a.order == null) return 1;
        if (b.order == null) return -1;
        return a.order!.compareTo(b.order!);
      });

      if (await NetworkManager.instance.isConnected()) {
        await syncService.pushPending();
      }

      KLoaders.success(title: "نجاح", message: "تم تحديث المادة بنجاح.");
    } catch (e) {
      error.value = e.toString();
      KLoaders.error(title: "خطأ في تحديث المادة", message: e.toString());
    } finally {
      _isSyncing.value = false;
    }
  }

  Future<void> deleteSubject(String id) async {
    if (_isSyncing.value) return;
    _isSyncing.value = true;

    try {
      await localRepo.markAsDeleted(id);
      subjects.removeWhere((s) => s.id == id);

      if (await NetworkManager.instance.isConnected()) {
        await syncService.pushPending();
      }

      KLoaders.success(title: "نجاح", message: "تم حذف المادة بنجاح.");
    } catch (e) {
      error.value = e.toString();
      KLoaders.error(title: "خطأ في حذف المادة", message: e.toString());
    } finally {
      _isSyncing.value = false;
    }
  }
}
