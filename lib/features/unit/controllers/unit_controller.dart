import 'package:ashil_school/Utils/constants/database_constant.dart';
import 'package:ashil_school/Utils/helpers/loaders/loaders.dart';
import 'package:ashil_school/Utils/helpers/network_manger.dart';
import 'package:ashil_school/data/repositories/local/unit_local_repository.dart';
import 'package:ashil_school/data/repositories/remote/unit_remote_repository.dart';
import 'package:ashil_school/data/repositories/sync_repository.dart';
import 'package:ashil_school/data/services/sync/unit_sync_service.dart';
import 'package:ashil_school/features/unit/models/unit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UnitController extends GetxController {
  final String subjectId;

  final nameController = TextEditingController();
  final orderController = TextEditingController();
  final descriptionController = TextEditingController();

  final units = <UnitModel>[].obs;
  final isLoading = false.obs;
  final error = RxnString();
  final _isSyncing = false.obs;
  final selectedUnit = Rxn<UnitModel>();

  late final UnitLocalRepository localRepo;
  late final UnitRemoteRepository remoteRepo;
  late final SyncRepository syncRepo;
  late final UnitSyncService syncService;

  UnitController({required this.subjectId});

  @override
  void onInit() {
    super.onInit();
    localRepo = UnitLocalRepository();
    remoteRepo = UnitRemoteRepository();
    syncRepo = SyncRepository();
    syncService = UnitSyncService(
      localRepo: localRepo,
      remoteRepo: remoteRepo,
      syncRepo: syncRepo,
    );

    loadAndSyncUnits();
  }

  @override
  void onClose() {
    nameController.dispose();
    orderController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  void prepareForAdd() {
    nameController.clear();
    descriptionController.clear();
    final nextOrder = units.isEmpty ? 1 : (units.last.order ?? 0) + 1;
    // ✅ هنا نقوم بملء حقل الترتيب بقيمة افتراضية إجبارية
    orderController.text = nextOrder.toString();
  }

  void prepareForEdit(UnitModel unit) {
    nameController.text = unit.name;
    orderController.text = unit.order?.toString() ?? '';
    descriptionController.text = unit.description ?? '';
  }

  Future<void> fetchUnits() async {
    await loadAndSyncUnits();
  }

  Future<void> loadAndSyncUnits() async {
    isLoading.value = true;
    error.value = null;
    try {
      final local = await localRepo.getUnitsBySubjectId(subjectId);
      units.assignAll(local);
      units.sort((a, b) {
        if (a.order == null && b.order == null) return 0;
        if (a.order == null) return 1;
        if (b.order == null) return -1;
        return a.order!.compareTo(b.order!);
      });

      if (units.isNotEmpty && selectedUnit.value == null) {
        selectedUnit.value = units.first;
      } else if (units.isEmpty) {
        selectedUnit.value = null;
      } else if (selectedUnit.value != null && !units.any((unit) => unit.id == selectedUnit.value!.id)) {
        selectedUnit.value = units.first;
      }

      isLoading.value = false;
      if (await NetworkManager.instance.isConnected()) {
        final lastSyncAt = await syncRepo.getLastSync(DBConstants.unitsTable);
        await syncService.pullUpdates(lastSyncAt);
        final refreshed = await localRepo.getUnitsBySubjectId(subjectId);
        units.assignAll(refreshed);
        units.sort((a, b) {
          if (a.order == null && b.order == null) return 0;
          if (a.order == null) return 1;
          if (b.order == null) return -1;
          return a.order!.compareTo(b.order!);
        });

        final currentSelectionId = selectedUnit.value?.id;
        if (currentSelectionId != null && refreshed.any((u) => u.id == currentSelectionId)) {
          selectedUnit.value = refreshed.firstWhere((u) => u.id == currentSelectionId);
        } else if (refreshed.isNotEmpty) {
          selectedUnit.value = refreshed.first;
        } else {
          selectedUnit.value = null;
        }
      }
    } catch (e) {
      print("Error loading units: $e");
      error.value = e.toString();
      KLoaders.error(title: "خطأ في التحميل/المزامنة", message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addUnit() async {
    if (_isSyncing.value) return;
    _isSyncing.value = true;
    try {
      final name = nameController.text.trim();
      final order = orderController.text.isNotEmpty ? int.tryParse(orderController.text.trim()) : null;
      final description = descriptionController.text.trim();

      final newUnit = await localRepo.createLocalUnit(
        name: name,
        order: order,
        subjectId: subjectId,
        description: description,
      );

      units.add(newUnit);
      units.sort((a, b) {
        if (a.order == null && b.order == null) return 0;
        if (a.order == null) return 1;
        if (b.order == null) return -1;
        return a.order!.compareTo(b.order!);
      });
      selectedUnit.value = newUnit;

      if (await NetworkManager.instance.isConnected()) {
        await syncService.pushPending();
      }

      KLoaders.success(title: "نجاح", message: "تمت إضافة الوحدة بنجاح.");
    } catch (e) {
      error.value = e.toString();
      KLoaders.error(title: "خطأ في إضافة الوحدة", message: e.toString());
    } finally {
      _isSyncing.value = false;
    }
  }

  Future<void> updateUnit(String id) async {
    if (_isSyncing.value) return;
    _isSyncing.value = true;
  
    try {
      final existingIndex = units.indexWhere((s) => s.id == id);
      if (existingIndex == -1) {
        throw Exception("الوحدة غير موجودة محلياً للتحرير.");
      }
      
      final updatedUnitModel = UnitModel(
        id: id,
        name: nameController.text.trim(),
        order: orderController.text.isNotEmpty ? int.tryParse(orderController.text.trim()) : null,
        subjectId: subjectId,
        description: descriptionController.text.trim(),
        createdAt: units[existingIndex].createdAt,
        updatedAt: DateTime.now(),
        deleted: units[existingIndex].deleted,
      );

      await localRepo.updateUnitLocal(updatedUnitModel);
      units[existingIndex] = updatedUnitModel;
      units.sort((a, b) {
        if (a.order == null && b.order == null) return 0;
        if (a.order == null) return 1;
        if (b.order == null) return -1;
        return a.order!.compareTo(b.order!);
      });
      selectedUnit.value = updatedUnitModel;

      if (await NetworkManager.instance.isConnected()) {
        await syncService.pushPending();
      }

      KLoaders.success(title: "نجاح", message: "تم تحديث الوحدة بنجاح.");
    } catch (e) {
      error.value = e.toString();
      KLoaders.error(title: "خطأ في تحديث الوحدة", message: e.toString());
    } finally {
      _isSyncing.value = false;
    }
  }

  Future<void> deleteUnit(String id) async {
    if (_isSyncing.value) return;
    _isSyncing.value = true;
  
    try {
      await localRepo.markAsDeleted(id);
      units.removeWhere((s) => s.id == id);
      if (selectedUnit.value?.id == id) {
        selectedUnit.value = units.isNotEmpty ? units.first : null;
      }

      if (await NetworkManager.instance.isConnected()) {
        await syncService.pushPending();
      }

      KLoaders.success(title: "نجاح", message: "تم حذف الوحدة بنجاح.");
    } catch (e) {
      error.value = e.toString();
      KLoaders.error(title: "خطأ في حذف الوحدة", message: e.toString());
    } finally {
      _isSyncing.value = false;
    }
  }

  void selectUnit(UnitModel unit) {
    selectedUnit.value = unit;
  }
}
