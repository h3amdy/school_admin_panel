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
  // ... (الخصائص كما هي) ...
  final String subjectId;

  final nameController = TextEditingController();
  final orderController = TextEditingController();
  final descriptionController = TextEditingController();

  final units = <UnitModel>[].obs;
  final isLoading = false.obs;
  final error = RxnString();
  final isSyncing = false.obs;
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
    // ... (كما هو) ...
    nameController.dispose();
    orderController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  void prepareForAdd() {
    // ... (كما هو) ...
    nameController.clear();
    descriptionController.clear();
    units.sort((a, b) => (a.order ?? 0).compareTo(b.order ?? 0));
    final nextOrder = units.isEmpty ? 1 : (units.last.order ?? 0) + 1;
    orderController.text = nextOrder.toString();
  }

  void prepareForEdit(UnitModel unit) {
    // ... (كما هو) ...
    nameController.text = unit.name;
    orderController.text = unit.order?.toString() ?? '';
    descriptionController.text = unit.description ?? '';
  }

  Future<void> fetchUnits() async {
    await loadAndSyncUnits();
  }

  // [MODIFIED] 2. تم تعديل الدالة بالكامل لتطبيق "العرض المحلي أولاً"
  Future<void> loadAndSyncUnits() async {
    isLoading.value = true;
    error.value = null;
    try {
      // 1. [NEW] تحميل وعرض البيانات المحلية *أولاً*
      List<UnitModel> localUnits =
          await localRepo.getUnitsBySubjectId(subjectId);

      // 2. [NEW] التحديث الفوري للقائمة (هذا سيشغل SubjectDetailsController)
      units.assignAll(localUnits);
      units.sort((a, b) {
        if (a.order == null && b.order == null) return 0;
        if (a.order == null) return 1;
        if (b.order == null) return -1;
        return a.order!.compareTo(b.order!);
      });
      _updateSelectedUnit(localUnits); // تحديث الوحدة المختارة
      isLoading.value = false; // [NEW] إيقاف التحميل الأولي

      // 3. [NEW] المزامنة في الخلفية (إذا كان متصلاً)
      if (await NetworkManager.instance.isConnected()) {
        final lastSyncAt = await syncRepo.getLastSync(DBConstants.unitsTable);
        await syncService.pullUpdates(lastSyncAt);

        // 4. [NEW] إعادة تحميل البيانات المحدثة
        List<UnitModel> refreshedUnits =
            await localRepo.getUnitsBySubjectId(subjectId);

        // 5. [NEW] التحديث الثاني (لن يسبب تكراراً بسبب "القفل" في SubjectDetailsController)
        units.assignAll(refreshedUnits);
        units.sort((a, b) {
          if (a.order == null && b.order == null) return 0;
          if (a.order == null) return 1;
          if (b.order == null) return -1;
          return a.order!.compareTo(b.order!);
        });
        _updateSelectedUnit(refreshedUnits); // تحديث الوحدة المختارة
      }
    } catch (e) {
      print("Error loading units: $e");
      error.value = e.toString();
      KLoaders.error(title: "خطأ في التحميل/المزامنة", message: e.toString());
    } finally {
      isLoading.value = false; // التأكد من إيقاف التحميل في كل الأحوال
    }
  }

  /// [NEW] 3. دالة مساعدة لتحديث الوحدة المختارة
  void _updateSelectedUnit(List<UnitModel> refreshedUnits) {
    // ... (كما هو) ...
    final currentSelectionId = selectedUnit.value?.id;
    if (currentSelectionId != null &&
        refreshedUnits.any((u) => u.id == currentSelectionId)) {
      selectedUnit.value =
          refreshedUnits.firstWhere((u) => u.id == currentSelectionId);
    } else if (refreshedUnits.isNotEmpty) {
      selectedUnit.value = refreshedUnits.first;
    } else {
      selectedUnit.value = null;
    }
  }

  // [MODIFIED] 4. إصلاح خطأ "Unmounted State" (إرجاع bool)
  Future<bool> addUnit({VoidCallback? onUnitAddedCallback}) async {
    // ... (كما هو) ...
    if (isSyncing.value) return false;
    isSyncing.value = true;
    bool success = false;
    try {
      final name = nameController.text.trim();
      final order = orderController.text.isNotEmpty
          ? int.tryParse(orderController.text.trim())
          : null;
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
      onUnitAddedCallback?.call();
      success = true; // تم النجاح
    } catch (e) {
      error.value = e.toString();
      print("مدري مدري مدري مدري مدري مدر${e.toString()}");
      KLoaders.error(title: "خطأ في إضافة الوحدة", message: e.toString());
      success = false; // فشل
    } finally {
      isSyncing.value = false;
    }
    return success; // إرجاع النتيجة
  }

  // [MODIFIED] 5. إصلاح خطأ "Unmounted State" (إرجاع bool)
  Future<bool> updateUnit(String id) async {
    // ... (كما هو) ...
    if (isSyncing.value) return false;
    isSyncing.value = true;
    bool success = false;
    try {
      final existingIndex = units.indexWhere((s) => s.id == id);
      if (existingIndex == -1) {
        throw Exception("الوحدة غير موجودة محلياً للتحرير.");
      }

      final updatedUnitModel = UnitModel(
        id: id,
        name: nameController.text.trim(),
        order: orderController.text.isNotEmpty
            ? int.tryParse(orderController.text.trim())
            : null,
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
      success = true;
    } catch (e) {
      error.value = e.toString();
      KLoaders.error(title: "خطأ في تحديث الوحدة", message: e.toString());
      success = false;
    } finally {
      isSyncing.value = false;
    }
    return success;
  }

  // [MODIFIED] 6. إصلاح خطأ "Unmounted State" (إرجاع bool)
  Future<bool> deleteUnit(String id) async {
    // ... (كما هو) ...
    if (isSyncing.value) return false;
    isSyncing.value = true;
    bool success = false;
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
      success = true;
    } catch (e) {
      error.value = e.toString();
      KLoaders.error(title: "خطأ في حذف الوحدة", message: e.toString());
      success = false;
    } finally {
      isSyncing.value = false;
    }
    return success;
  }

  void selectUnit(UnitModel unit) {
    selectedUnit.value = unit;
  }
}
