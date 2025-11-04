import 'package:ashil_school/Utils/helpers/network_manger.dart';
import 'package:ashil_school/data/local/app_database.dart';
import 'package:ashil_school/data/repositories/authentication_repository.dart';
import 'package:ashil_school/data/repositories/local/grade_local_repository.dart';
import 'package:ashil_school/data/repositories/local/lesson_local_repository.dart';
import 'package:ashil_school/data/repositories/local/question_local_repository.dart';
import 'package:ashil_school/data/repositories/local/semester_local_repository.dart';
import 'package:ashil_school/data/repositories/remote/grade_remote_repository.dart';
import 'package:ashil_school/data/repositories/remote/lesson_remote_repository.dart';
import 'package:ashil_school/data/repositories/remote/question_remote_repository.dart';
import 'package:ashil_school/data/repositories/remote/semester_remote_repository.dart';
import 'package:ashil_school/data/repositories/sync_repository.dart';
import 'package:ashil_school/data/services/sync/grade_sync_service.dart';
import 'package:ashil_school/data/services/sync/lesson_sync_service.dart';
import 'package:ashil_school/data/services/sync/question_sync_service.dart';
import 'package:ashil_school/data/services/sync/semester_sync_service.dart';
import 'package:ashil_school/data/services/sync/sync_manager.dart';
import 'package:get/get.dart';
import 'package:ashil_school/data/repositories/local/teacher_local_repository.dart';
import 'package:ashil_school/data/repositories/remote/teacher_remote_repository.dart';
import 'package:ashil_school/data/services/sync/teacher_sync_service.dart';

class GeneralBindings extends Bindings {
  @override
  void dependencies() {
    // Authentication
     Get.put(AuthenticationRepository()); // ✅ قد تحتاج لتسجيل هذا أيضًا

    // قاعدة البيانات المحلية
    final appDb = AppDatabase();
    Get.put(appDb);

    // المستودعات المحلية
    Get.put(GradeLocalRepository());
    Get.put(LessonLocalRepository());
    Get.put(SemesterLocalRepository());
    Get.put(TeacherLocalRepository()); // ✅ تسجيل مستودع المعلم المحلي
    Get.put(QuestionLocalRepository());
    // ... قم بتسجيل أي مستودعات محلية أخرى

    // المستودعات البعيدة
    Get.put(GradeRemoteRepository());
    Get.put(LessonRemoteRepository());
    Get.put(SemesterRemoteRepository());
    Get.put(TeacherRemoteRepository()); // ✅ تسجيل مستودع المعلم البعيد
    Get.put(QuestionRemoteRepository());
    // ... قم بتسجيل أي مستودعات بعيدة أخرى

    // المستودعات الأخرى
    Get.put(NetworkManager());
    Get.put(SyncRepository()); // ✅ تسجيل SyncRepository مرة واحدة

    // خدمات المزامنة
    final gradeSyncService = GradeSyncService(
      localRepo: Get.find<GradeLocalRepository>(),
      remoteRepo: Get.find<GradeRemoteRepository>(),
      syncRepo: Get.find<SyncRepository>(),
    );
    final lessonSyncService = LessonSyncService(
      localRepo: Get.find<LessonLocalRepository>(),
      remoteRepo: Get.find<LessonRemoteRepository>(),
      syncRepo: Get.find<SyncRepository>(),
    );
    final semesterSyncService = SemesterSyncService(
      localRepo: Get.find<SemesterLocalRepository>(),
      remoteRepo: Get.find<SemesterRemoteRepository>(),
      syncRepo: Get.find<SyncRepository>(),
    );
    final teacherSyncService = TeacherSyncService( // ✅ تسجيل خدمة مزامنة المعلم
      localRepo: Get.find<TeacherLocalRepository>(),
      remoteRepo: Get.find<TeacherRemoteRepository>(),
      syncRepo: Get.find<SyncRepository>(),
    );
  final questionSyncService = QuestionSyncService( // ✅ تسجيل خدمة مزامنة المعلم
      localRepo: Get.find<QuestionLocalRepository>(),
      remoteRepo: Get.find<QuestionRemoteRepository>(),
      syncRepo: Get.find<SyncRepository>(),
    );
    // مدير المزامنة مع جميع الخدمات
    Get.put(SyncManager(
      services: [
        gradeSyncService,
        lessonSyncService,
        semesterSyncService,
        teacherSyncService, // ✅ إضافة خدمة مزامنة المعلم
       questionSyncService
      ],
      syncRepo: Get.find<SyncRepository>(),
    ));
  }
}
