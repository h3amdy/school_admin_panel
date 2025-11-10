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

  // [تعديل] 1. هذه المتحكمات لم تعد مستخدمة لإضافة/تعديل
  // يمكن استخدامها للفلترة أو البحث إذا أردت، لكنها غير مرتبطة بـ addLesson
  // final nameController = TextEditingController();
  // final contentController = TextEditingController();
  // final orderController = TextEditingController();

  final lessons = <LessonModel>[].obs;
  final isLoading = false.obs;
  final error = RxnString();
  final isSyncing = false.obs;
  final selectedLesson = Rx<LessonModel?>(null);

  late final LessonLocalRepository localRepo;
  late final LessonRemoteRepository remoteRepo;
  late final SyncRepository syncRepo;
  late final LessonSyncService syncService;

  LessonController({required this.unitId});

  @override
  void onInit() {
    super.onInit();
    localRepo = Get.put(LessonLocalRepository());
    remoteRepo = Get.put(LessonRemoteRepository());
    syncRepo = Get.put(SyncRepository());
    syncService = LessonSyncService(
      localRepo: localRepo,
      remoteRepo: remoteRepo,
      syncRepo: syncRepo,
    );
  }

  // @override
  // void onClose() {
  //   nameController.dispose();
  //   contentController.dispose();
  //   orderController.dispose();
  //   super.onClose();
  // }

  // [تعديل] 2. هذه الدوال لم تعد صالحة لأن المتحكمات أزيلت
  // void prepareForAdd(int nextOrder) {
  //   nameController.clear();
  //   contentController.clear();
  //   orderController.text = nextOrder.toString();
  // }

  // void prepareForEdit(LessonModel lesson) {
  //   nameController.text = lesson.title;
  //   contentController.text = lesson.content; // هذا الحقل لم يعد موجوداً
  //   orderController.text = lesson.order?.toString() ?? '';
  // }

  Future<void> fetchLessons({bool isAutoSync = false}) async {
    await _loadLocalThenSync(isAutoSync: isAutoSync);
  }

  Future<void> _loadLocalThenSync({bool isAutoSync = false}) async {
    // ... (نفس الكود السابق، لا تغيير هنا)
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
      }
    } catch (e) {
      error.value = e.toString();
      KLoaders.error(title: "خطأ في التحميل/المزامنة", message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // [تعديل] 3. تعديل دالة addLesson لتقبل موديل كامل
  Future<void> addLesson(LessonModel newLesson) async {
    if (isSyncing.value) return;
    isSyncing.value = true;
    error.value = null;
    try {
      // التأكد من أن unitId يطابق هذا المتحكم
      final lessonToAdd = newLesson.copyWith(unitId: unitId);

      final createdLesson = await localRepo.createLocalLesson(lessonToAdd);
      
      lessons.add(createdLesson);
      lessons.sort((a, b) => a.order?.compareTo(b.order ?? 9999) ?? -1);
      selectLesson(createdLesson);
      
      if (await NetworkManager.instance.isConnected()) {
        await syncService.pushPending();
      }
      KLoaders.success(title: "نجاح", message: "تمت إضافة الدرس بنجاح.");
    } catch (e) {
      error.value = e.toString();
      KLoaders.error(title: "خطأ في إضافة الدرس", message: e.toString());
    } finally {
      isSyncing.value = false;
    }
  }

  // [تعديل] 4. تعديل دالة updateLesson
  Future<void> updateLesson(String id, LessonModel lessonWithChanges) async {
    if (isSyncing.value) return;
    isSyncing.value = true;
    error.value = null;
    try {
      // lessonWithChanges يحتوي على كل التغييرات من الـ UI الجديد
      // نضمن الحفاظ على البيانات الوصفية (metadata)
      final lessonFromRepo = await localRepo.getLessonById(id);
      if (lessonFromRepo == null) {
        throw Exception("الدرس غير موجود محلياً للتحرير.");
      }

      final updatedLessonModel = lessonWithChanges.copyWith(
        id: id,
        createdAt: lessonFromRepo.createdAt, // الحفاظ على تاريخ الإنشاء
        updatedAt: DateTime.now(),
        isSynced: false, // تم تعديله، يحتاج مزامنة
      );
      
      await localRepo.updateLessonLocal(updatedLessonModel);

      // تحديث القائمة المحلية 
      final existingIndex = lessons.indexWhere((l) => l.id == id);
      if (existingIndex != -1) {
        lessons[existingIndex] = updatedLessonModel;
        lessons.sort((a, b) => a.order?.compareTo(b.order ?? 9999) ?? -1);
        selectLesson(updatedLessonModel);
      }

      KLoaders.success(title: "نجاح", message: "تم تحديث الدرس بنجاح.");
      if (await NetworkManager.instance.isConnected()) {
        await syncService.pushPending();
      }
    } catch (e) {
      error.value = e.toString();
      KLoaders.error(title: "خطأ في تحديث الدرس", message: e.toString());
    } finally {
      isSyncing.value = false;
    }
  }

  Future<void> deleteLesson(String id) async {
    if (isSyncing.value) return;
    isSyncing.value = true;
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
      isSyncing.value = false;
    }
  }

  void selectLesson(LessonModel? lesson) {
    selectedLesson.value = lesson;
  }
}