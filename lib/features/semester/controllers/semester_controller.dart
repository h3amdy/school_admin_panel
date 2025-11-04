import 'package:ashil_school/Utils/constants/database_constant.dart';
import 'package:ashil_school/Utils/helpers/loaders/loaders.dart';
import 'package:ashil_school/Utils/helpers/network_manger.dart';
import 'package:ashil_school/data/repositories/local/semester_local_repository.dart';
import 'package:ashil_school/data/repositories/remote/semester_remote_repository.dart';
import 'package:ashil_school/data/repositories/sync_repository.dart';
import 'package:ashil_school/data/services/sync/semester_sync_service.dart';
import 'package:ashil_school/features/semester/models/semester.dart';
import 'package:get/get.dart';

class SemesterController extends GetxController {
  final String gradeId;
  final semesters = <SemesterModel>[].obs;
  final isLoading = false.obs;
  final error = RxnString();
  final _isSyncing = false.obs;

  late final SemesterLocalRepository localRepo;
  late final SemesterRemoteRepository remoteRepo;
  late final SyncRepository syncRepo;
  late final SemesterSyncService syncService;

  SemesterController(this.gradeId);

  @override
  void onInit() {
    super.onInit();
    localRepo = SemesterLocalRepository();
    remoteRepo = SemesterRemoteRepository();
    syncRepo = SyncRepository();
    syncService = SemesterSyncService(
        localRepo: localRepo, remoteRepo: remoteRepo, syncRepo: syncRepo);

    NetworkManager.instance.onReconnect = () => loadAndSyncByGrade();

    loadAndSyncByGrade();
  }

  Future<void> loadAndSyncByGrade() async {
    isLoading.value = true;
    error.value = null;
    try {
      final local = await localRepo.getSemestersByGradeId(gradeId);
      semesters.assignAll(local);
      semesters.sort((a, b) => a.order.compareTo(b.order));
      isLoading.value = false;
      if (await NetworkManager.instance.isConnected()) {
        final lastSyncAt =
            await syncRepo.getLastSync(DBConstants.semestersTable);

        await syncService.pullUpdates(lastSyncAt);
        final refreshed = await localRepo.getSemestersByGradeId(gradeId);
        semesters.assignAll(refreshed);
        semesters.sort((a, b) => a.order.compareTo(b.order));
      } else {
        // KLoaders.warning(
        //   title: "لا يوجد اتصال بالإنترنت",
        //   message: "تم عرض البيانات المحلية فقط.",
        // );
      }
    } catch (e) {
      print("هذا الخطأ هنا $e");
      error.value = e.toString();
      KLoaders.error(title: "خطأ في التحميل/المزامنة", message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addSemester({
    required String name,
    required int order,
    String? description,
  }) async {
    if (_isSyncing.value) return;
    _isSyncing.value = true;

    error.value = null;
    try {
      final newSemester = await localRepo.createLocalSemester(
        name: name,
        order: order,
        gradeId: gradeId,
        description: description,
      );

      semesters.add(newSemester);
      semesters.sort((a, b) => a.order.compareTo(b.order));

      if (await NetworkManager.instance.isConnected()) {
        await syncService.pushPending();
      }

      KLoaders.success(title: "نجاح", message: "تمت إضافة الفصل بنجاح.");
    } catch (e) {
      error.value = e.toString();
      KLoaders.error(title: "خطأ في إضافة الفصل", message: e.toString());
    } finally {
      _isSyncing.value = false;
    }
  }

  Future<void> updateSemester(
    String id, {
    required String name,
    required int order,
    String? description,
  }) async {
    if (_isSyncing.value) return;
    _isSyncing.value = true;

    error.value = null;
    try {
      final existingIndex = semesters.indexWhere((s) => s.id == id);
      if (existingIndex == -1) {
        throw Exception("الفصل غير موجود محلياً للتحرير.");
      }

      final updatedSemesterModel = SemesterModel(
        id: id,
        name: name,
        order: order,
        gradeId: gradeId,
        description: description,
        createdAt: semesters[existingIndex].createdAt,
        updatedAt: DateTime.now(),
        deleted: semesters[existingIndex].deleted,
      );

      await localRepo.updateSemesterLocal(updatedSemesterModel);
      semesters[existingIndex] = updatedSemesterModel;
      semesters.sort((a, b) => a.order.compareTo(b.order));

      if (await NetworkManager.instance.isConnected()) {
        await syncService.pushPending();
      }

      KLoaders.success(title: "نجاح", message: "تم تحديث الفصل بنجاح.");
    } catch (e) {
      error.value = e.toString();
      KLoaders.error(title: "خطأ في تحديث الفصل", message: e.toString());
    } finally {
      _isSyncing.value = false;
    }
  }

  Future<void> deleteSemester(String id) async {
    if (_isSyncing.value) return;
    _isSyncing.value = true;

    error.value = null;
    try {
      await localRepo.markAsDeleted(id);
      semesters.removeWhere((s) => s.id == id);

      if (await NetworkManager.instance.isConnected()) {
        await syncService.pushPending();
      }

      KLoaders.success(title: "نجاح", message: "تم حذف الفصل بنجاح.");
    } catch (e) {
      error.value = e.toString();
      KLoaders.error(title: "خطأ في حذف الفصل", message: e.toString());
    } finally {
      _isSyncing.value = false;
    }
  }
}
