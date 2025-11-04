// lib/features/teacher/controllers/teacher_controller.dart
import 'package:ashil_school/Utils/helpers/network_manger.dart';
import 'package:ashil_school/data/repositories/local/teacher_local_repository.dart';
import 'package:ashil_school/data/repositories/remote/teacher_remote_repository.dart';
import 'package:ashil_school/data/repositories/sync_repository.dart';
import 'package:ashil_school/data/services/sync/teacher_sync_service.dart';
import 'package:ashil_school/features/subject/models/subject.dart';
import 'package:ashil_school/models/user_model/user.dart';
import 'package:ashil_school/Utils/helpers/loaders/loaders.dart';
import 'package:get/get.dart';

class TeacherController extends GetxController {
  static TeacherController get instance => Get.find();

  final RxList<User> teachers = <User>[].obs;
  final isLoading = false.obs;
  final isSyncing = false.obs;
  final error = RxnString();
  final allAvailableSubjects = <SubjectModel>[].obs; // ✅ إضافة هذه القائمة

  late final TeacherLocalRepository localRepo;
  late final TeacherRemoteRepository remoteRepo;
  late final SyncRepository syncRepo;
  late final TeacherSyncService syncService;

  @override
  void onInit() {
    super.onInit();
    localRepo = Get.find<TeacherLocalRepository>(); // ✅
    remoteRepo = TeacherRemoteRepository();
    syncRepo = Get.find<SyncRepository>();
    syncService = TeacherSyncService(
      localRepo: localRepo,
      remoteRepo: remoteRepo,
      syncRepo: syncRepo,
    );

    _loadDataAndSync();
  }

  Future<void> _loadDataAndSync() async {
    isLoading.value = true;
    error.value = null;
    try {
      await _loadLocalTeachers();
      if (teachers.isNotEmpty) {
        isLoading.value = false;
      }
      await syncAll(); // المزامنة الأولية
    } catch (e) {
      error.value = e.toString();
      KLoaders.error(title: "خطأ في التحميل/المزامنة", message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadLocalTeachers() async {
    final localTeachers = await localRepo.getAll();
    teachers.assignAll(localTeachers);
  }

  Future<void> syncAll() async {
    if (isSyncing.value) return;
    isSyncing.value = true;
    try {
      if (await NetworkManager.instance.isConnected()) {
        await syncService.pushPending();
        await _loadLocalTeachers(); // تحديث القائمة بعد المزامنة
        // KLoaders.success(
        //     title: "تمت المزامنة", message: "تم تحديث بيانات المعلمين بنجاح.");
      } else {
        // KLoaders.warning(
        //     title: "لا يوجد اتصال",
        //     message: "تعذر إجراء المزامنة. يرجى التحقق من اتصالك بالإنترنت.");
      }
    } catch (e) {
      KLoaders.error(title: "خطأ في المزامنة", message: e.toString());
    } finally {
      isSyncing.value = false;
    }
  }

  Future<void> addTeacher({
    required String username,
    required String password,
    String? fullName,
    String? phone,
    String? specialization,
    List<String>? assignedSubjects,
  }) async {
    isSyncing.value = true;
    try {
      final newTeacher = await localRepo.createLocalTeacher(
        username: username,
        password: password,
        fullName: fullName,
        phone: phone,
        specialization: specialization,
        assignedSubjects: assignedSubjects,
      );
      teachers.add(newTeacher);

      await syncAll();

      KLoaders.success(title: "نجاح", message: "تمت إضافة المعلم بنجاح.");
    } catch (e) {
      error.value = e.toString();
      KLoaders.error(title: "خطأ في إضافة المعلم", message: e.toString());
    } finally {
      isSyncing.value = false;
    }
  }

  Future<void> updateTeacher(
    String id, {
    String? username,
    String? password,
    String? fullName,
    String? phone,
    String? specialization,
    List<String>? assignedSubjects,
  }) async {
    isSyncing.value = true;
    try {
      final existingTeacherIndex = teachers.indexWhere((t) => t.id == id);
      if (existingTeacherIndex == -1) {
        throw Exception("المعلم غير موجود محلياً للتحرير.");
      }

      final updatedTeacherModel = User(
        id: id,
        username: username ?? teachers[existingTeacherIndex].username,
        password: password ?? teachers[existingTeacherIndex].password,
        fullName: fullName ?? teachers[existingTeacherIndex].fullName,
        phone: phone ?? teachers[existingTeacherIndex].phone,
        specialization:
            specialization ?? teachers[existingTeacherIndex].specialization,
        assignedSubjects:
            assignedSubjects ?? teachers[existingTeacherIndex].assignedSubjects,
        // ✅ تصحيح: يجب أن يكون role قابلاً للقيمة الفارغة
        role: null,
      );

      await localRepo.updateTeacherLocal(updatedTeacherModel);
      teachers[existingTeacherIndex] = updatedTeacherModel;

      await syncAll();

      KLoaders.success(title: "نجاح", message: "تم تحديث بيانات المعلم بنجاح.");
    } catch (e) {
      error.value = e.toString();
      KLoaders.error(title: "خطأ في تحديث المعلم", message: e.toString());
    } finally {
      isSyncing.value = false;
    }
  }

  Future<void> deleteTeacher(String id) async {
    isSyncing.value = true;
    try {
      await localRepo.markAsDeleted(id);
      teachers.removeWhere((t) => t.id == id);
      await syncAll();
      KLoaders.success(title: "نجاح", message: "تم حذف المعلم بنجاح.");
    } catch (e) {
      error.value = e.toString();
      KLoaders.error(title: "خطأ في حذف المعلم", message: e.toString());
    } finally {
      isSyncing.value = false;
    }
  }
}
