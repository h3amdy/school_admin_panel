import 'package:ashil_school/Utils/helpers/network_manger.dart';
import 'package:ashil_school/data/services/sync/sync_manager.dart';
import 'package:get/get.dart';
import 'package:ashil_school/data/repositories/local/grade_local_repository.dart';
import 'package:ashil_school/data/repositories/remote/grade_remote_repository.dart';
import 'package:ashil_school/data/repositories/sync_repository.dart';
import 'package:ashil_school/data/services/sync/grade_sync_service.dart';
import 'package:ashil_school/features/grade/models/grade.dart';
import 'package:ashil_school/Utils/helpers/loaders/loaders.dart';

class GradeController extends GetxController {
  final grades = <GradeModel>[].obs;
  final isLoading = false.obs;
  final error = RxnString();
  final _isSyncing = false.obs;

  late final GradeLocalRepository localRepo;
  late final GradeRemoteRepository remoteRepo;
  late final SyncRepository syncRepo;
  late final GradeSyncService syncService;

  @override
  void onInit() {
    super.onInit();
    localRepo = Get.find<GradeLocalRepository>();
    remoteRepo = Get.find<GradeRemoteRepository>();
    syncRepo = SyncRepository();
    syncService = GradeSyncService(
      localRepo: localRepo,
      remoteRepo: remoteRepo,
      syncRepo: syncRepo,
    );

    _loadLocalThenSync();
  }

  /// دالة لإعادة تحميل البيانات المحلية + محاولة المزامنة
  Future<void> _loadLocalThenSync() async {
    isLoading.value = true;
    error.value = null;
    try {
      final local = await localRepo.getAll();
      grades.assignAll(local);
      // Ensure the grades list is always sorted by order
      grades.sort((a, b) => a.order.compareTo(b.order));
      isLoading.value = false;
      await _syncAndRefresh();
    } catch (e) {
      print("خطأ في _loadLocalThenSync: $e");
      error.value = e.toString();
      KLoaders.error(title: "خطأ في التحميل/المزامنة", message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// دالة خاصة لتجميع منطق المزامنة وتحديث القائمة
  Future<void> _syncAndRefresh() async {
    if (await NetworkManager.instance.isConnected()) {
      final syncManager = Get.find<SyncManager>();
      await syncManager.syncAll();
      final refreshed = await localRepo.getAll();
      grades.assignAll(refreshed);
      grades.sort((a, b) => a.order.compareTo(b.order));
    }
  }

  Future<void> addGrade({
    required String name,
    required int order,
    String? description,
  }) async {
    if (_isSyncing.value) return;
    _isSyncing.value = true;
    isLoading.value = true;
    error.value = null;
    try {
      final newGrade = await localRepo.createLocalGrade(
        name: name,
        order: order,
        description: description,
      );

      grades.add(newGrade);
      grades.sort((a, b) => a.order.compareTo(b.order));

      KLoaders.success(title: "نجاح", message: "تمت إضافة الصف بنجاح.");
      if (await NetworkManager.instance.isConnected()) {
        await syncService.pushPending();
      }
    } catch (e) {
      error.value = e.toString();
      KLoaders.error(title: "خطأ في إضافة الصف", message: e.toString());
    } finally {
      isLoading.value = false;
      _isSyncing.value = false;
    }
  }

  Future<void> updateGrade(
    String id, {
    required String name,
    required int order,
    String? description,
  }) async {
    if (_isSyncing.value) return;
    _isSyncing.value = true;
    isLoading.value = true;
    error.value = null;
    try {
      final existingIndex = grades.indexWhere((g) => g.id == id);
      if (existingIndex == -1) {
        throw Exception("الصف غير موجود محلياً للتحرير.");
      }
      final now = DateTime.now();
      final updatedGradeModel = GradeModel(
        id: id,
        name: name,
        order: order,
        description: description,
        createdAt: grades[existingIndex].createdAt,
        updatedAt: now,
        deleted: grades[existingIndex].deleted,
      );

      await localRepo.updateGradeLocal(updatedGradeModel);

      grades[existingIndex] = updatedGradeModel;
      grades.sort((a, b) => a.order.compareTo(b.order));

      KLoaders.success(title: "نجاح", message: "تم تحديث الصف بنجاح.");
      if (await NetworkManager.instance.isConnected()) {
        await syncService.pushPending();
      }
    } catch (e) {
      error.value = e.toString();
      KLoaders.error(title: "خطأ في تحديث الصف", message: e.toString());
    } finally {
      isLoading.value = false;
      _isSyncing.value = false;
    }
  }

  Future<void> deleteGrade(String id) async {
    if (_isSyncing.value) return;
    _isSyncing.value = true;
    isLoading.value = true;
    error.value = null;
    try {
      await localRepo.markAsDeleted(id);

      grades.removeWhere((g) => g.id == id);

      if (await NetworkManager.instance.isConnected()) {
        await syncService.pushPending();
      }
      KLoaders.success(title: "نجاح", message: "تم حذف الصف بنجاح.");
    } catch (e) {
      error.value = e.toString();
      KLoaders.error(title: "خطأ في حذف الصف", message: e.toString());
    } finally {
      isLoading.value = false;
      _isSyncing.value = false;
    }
  }
}
