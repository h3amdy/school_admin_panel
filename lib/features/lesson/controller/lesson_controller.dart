import 'package:ashil_school/Utils/constants/database_constant.dart';
import 'package:ashil_school/Utils/helpers/loaders/loaders.dart';
import 'package:ashil_school/Utils/helpers/network_manger.dart';
import 'package:ashil_school/data/repositories/local/lesson_local_repository.dart';
import 'package:ashil_school/data/repositories/remote/lesson_remote_repository.dart';
import 'package:ashil_school/data/repositories/sync_repository.dart';
import 'package:ashil_school/data/services/sync/lesson_sync_service.dart';
import 'package:ashil_school/features/lesson/models/lesson.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LessonController extends GetxController {
  final String unitId;
  
  // ✅ المتحكمات الجديدة
  final nameController = TextEditingController();
  final contentController = TextEditingController();
  final orderController = TextEditingController();

  final lessons = <LessonModel>[].obs;
  final isLoading = false.obs;
  final error = RxnString();
  final _isSyncing = false.obs;
  final selectedLesson = Rx<LessonModel?>(null);

  late final LessonLocalRepository localRepo;
  late final LessonRemoteRepository remoteRepo;
  late final SyncRepository syncRepo;
  late final LessonSyncService syncService;

  LessonController({required this.unitId});

  get isEditing => null;

  @override
  void onInit() {
    super.onInit();
    localRepo = Get.find<LessonLocalRepository>();
    remoteRepo = Get.find<LessonRemoteRepository>();
    syncRepo = Get.find<SyncRepository>();
    syncService = LessonSyncService(
      localRepo: localRepo,
      remoteRepo: remoteRepo,
      syncRepo: syncRepo,
    );
  }

  @override
  void onClose() {
    nameController.dispose();
    contentController.dispose();
    orderController.dispose();
    super.onClose();
  }

  // ✅ دالة جديدة لتجهيز المتحكمات لإضافة درس جديد
  void prepareForAdd() {
    nameController.clear();
    contentController.clear();
    // الحصول على الترتيب التلقائي للدرس الجديد
    final nextOrder = lessons.isEmpty ? 1 : (lessons.last.order ?? 0) + 1;
    orderController.text = nextOrder.toString();
  }

  // ✅ دالة جديدة لتجهيز المتحكمات لتعديل درس
  void prepareForEdit(LessonModel lesson) {
    nameController.text = lesson.title;
    contentController.text = lesson.content;
    orderController.text = lesson.order?.toString() ?? '';
  }

  Future<void> fetchLessons({bool isAutoSync = false}) async {
    await _loadLocalThenSync(isAutoSync: isAutoSync);
  }

  Future<void> _loadLocalThenSync({bool isAutoSync = false}) async {
    isLoading.value = true;
    error.value = null;
    try {
      final local = await localRepo.getAllLessonsByUnitId(unitId);
      lessons.assignAll(local);
      lessons.sort((a, b) => a.order?.compareTo(b.order ?? 9999) ?? -1);

      if (selectedLesson.value == null && lessons.isNotEmpty) {
        selectLesson(lessons.first);
      } else if (lessons.isEmpty) {
        selectLesson(null);
      } else if (selectedLesson.value != null &&
          !lessons.any((l) => l.id == selectedLesson.value!.id)) {
        selectLesson(lessons.isNotEmpty ? lessons.first : null);
      }
      isLoading.value = false;
      if (await NetworkManager.instance.isConnected()) {
        final lastSyncAt = await syncRepo.getLastSync(DBConstants.lessonsTable);
        await syncService.pullUpdates(lastSyncAt);
        final refreshed = await localRepo.getAllLessonsByUnitId(unitId);
        lessons.assignAll(refreshed);
        lessons.sort((a, b) => a.order?.compareTo(b.order ?? 9999) ?? -1);
        final currentSelectionId = selectedLesson.value?.id;
        if (currentSelectionId != null &&
            refreshed.any((l) => l.id == currentSelectionId)) {
          selectedLesson.value =
              refreshed.firstWhere((l) => l.id == currentSelectionId);
        } else if (refreshed.isNotEmpty) {
          selectLesson(refreshed.first);
        } else {
          selectLesson(null);
        }
      } else {
        if (!isAutoSync) {
        }
      }
    } catch (e) {
      error.value = e.toString();
      KLoaders.error(title: "خطأ في التحميل/المزامنة", message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ الآن لا تستقبل الدالة أي بارامترات وتعتمد على المتحكمات
  Future<void> addLesson() async {
    if (_isSyncing.value) return;
    _isSyncing.value = true;
    error.value = null;
    try {
      final title = nameController.text.trim();
      final content = contentController.text.trim();
      final order = orderController.text.isNotEmpty ? int.tryParse(orderController.text.trim()) : null;

      final newLesson = await localRepo.createLocalLesson(
        title: title,
        content: content,
        unitId: unitId,
        order: order,
      );
      lessons.add(newLesson);
      lessons.sort((a, b) => a.order?.compareTo(b.order ?? 9999) ?? -1);
      selectLesson(newLesson);
      if (await NetworkManager.instance.isConnected()) {
        await syncService.pushPending();
      }
      KLoaders.success(title: "نجاح", message: "تمت إضافة الدرس بنجاح.");
    } catch (e) {
      error.value = e.toString();
      KLoaders.error(title: "خطأ في إضافة الدرس", message: e.toString());
    } finally {
      _isSyncing.value = false;
    }
  }

  // ✅ الآن تستقبل الدالة فقط الـ ID وتعتمد على المتحكمات
  Future<void> updateLesson(String id) async {
    if (_isSyncing.value) return;
    _isSyncing.value = true;
    error.value = null;
    try {
      final existingIndex = lessons.indexWhere((l) => l.id == id);
      if (existingIndex == -1) {
        throw Exception("الدرس غير موجود محلياً للتحرير.");
      }
      final updatedLessonModel = LessonModel(
        id: id,
        title: nameController.text.trim(),
        content: contentController.text.trim(),
        unitId: unitId,
        order: orderController.text.isNotEmpty ? int.tryParse(orderController.text.trim()) : null,
        createdAt: lessons[existingIndex].createdAt,
        updatedAt: DateTime.now(),
        deleted: lessons[existingIndex].deleted,
      );

      await localRepo.updateLessonLocal(updatedLessonModel);

      lessons[existingIndex] = updatedLessonModel;
      lessons.sort((a, b) => a.order?.compareTo(b.order ?? 9999) ?? -1);
      selectLesson(updatedLessonModel);
      KLoaders.success(title: "نجاح", message: "تم تحديث الدرس بنجاح.");
      if (await NetworkManager.instance.isConnected()) {
        await syncService.pushPending();
      }
    } catch (e) {
      error.value = e.toString();
      KLoaders.error(title: "خطأ في تحديث الدرس", message: e.toString());
    } finally {
      _isSyncing.value = false;
    }
  }

  Future<void> deleteLesson(String id) async {
    if (_isSyncing.value) return;
    _isSyncing.value = true;
    error.value = null;
    try {
      await localRepo.markAsDeleted(id);
      lessons.removeWhere((l) => l.id == id);
      selectLesson(lessons.isNotEmpty ? lessons.first : null);

      if (await NetworkManager.instance.isConnected()) {
        await syncService.pushPending();
      }
      KLoaders.success(title: "نجاح", message: "تم حذف الدرس بنجاح.");
    } catch (e) {
      error.value = e.toString();
      KLoaders.error(title: "خطأ في حذف الدرس", message: e.toString());
    } finally {
      _isSyncing.value = false;
    }
  }

  void selectLesson(LessonModel? lesson) {
    selectedLesson.value = lesson;
  }
}
