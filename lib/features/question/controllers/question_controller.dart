// question_controller.dart
// تم التعديل لإضافة نقاط تتبع (PRINT TRACES) لتحديد مصدر الخطأ.
import 'package:ashil_school/Utils/constants/database_constant.dart';
import 'package:ashil_school/Utils/helpers/loaders/loaders.dart';
import 'package:ashil_school/Utils/helpers/network_manger.dart';
import 'package:ashil_school/data/repositories/local/question_local_repository.dart';
import 'package:ashil_school/data/repositories/remote/question_remote_repository.dart';
import 'package:ashil_school/data/repositories/sync_repository.dart';
import 'package:ashil_school/data/services/sync/question_sync_service.dart';
import 'package:ashil_school/features/question/models/base_question.dart';
import 'package:get/get.dart';

class QuestionController extends GetxController {
  final String lessonId;
  final questions = <BaseQuestion>[].obs;
  final isLoading = false.obs;
  final error = RxnString();
  final _isSyncing = false.obs;
  final selectedQuestion = Rx<BaseQuestion?>(null);

  late final QuestionLocalRepository localRepo;
  late final QuestionRemoteRepository remoteRepo;
  late final SyncRepository syncRepo;
  late final QuestionSyncService syncService;

  QuestionController({required this.lessonId});

  @override
  void onInit() {
    super.onInit();
    localRepo = QuestionLocalRepository();
    remoteRepo = QuestionRemoteRepository();
    syncRepo = SyncRepository();
    syncService = QuestionSyncService(
      localRepo: localRepo,
      remoteRepo: remoteRepo,
      syncRepo: syncRepo,
    );
    fetchQuestions();
    NetworkManager.instance.onReconnect =
        () => fetchQuestions(isAutoSync: true);
  }

  Future<void> fetchQuestions({bool isAutoSync = false}) async {
    print(
        "--- DEBUG TRACE: Starting fetchQuestions for lesson: $lessonId ---"); // TRACE 1
    isLoading.value = true;
    error.value = null;
    try {
      final local = await localRepo.getAllQuestionsByLessonId(lessonId);

      print(
          "TRACE 2: Local data fetched (before assign): $local. Type: ${local.runtimeType}"); // TRACE 2

      // 💡 فحص الـ Null والتأكد من أنها قائمة
      questions.assignAll(local ?? []);

      print(
          "TRACE 3: Questions list size after local fetch: ${questions.length}"); // TRACE 3

      // ✅ فرز الأسئلة محليًا حسب الترتيب إذا كان موجودًا
      questions.sort((a, b) => a.order?.compareTo(b.order ?? 9999) ?? -1);

      if (await NetworkManager.instance.isConnected()) {
        print("TRACE 4: Connected. Starting sync operations."); // TRACE 4
        final lastSyncAt = await syncRepo
            .getLastSync(DBConstants.questionsTable, parentId: lessonId);
        await syncService.pullUpdates(lastSyncAt);
        await syncService.pushPending();

        print("TRACE 5: Sync completed. Re-fetching local data."); // TRACE 5

        final refreshed = await localRepo.getAllQuestionsByLessonId(lessonId);

        print(
            "TRACE 6: Refreshed data fetched (before assign): $refreshed. Type: ${refreshed.runtimeType}"); // TRACE 6

        // 💡 فحص الـ Null والتأكد من أنها قائمة
        questions.assignAll(refreshed ?? []);

        print(
            "TRACE 7: Questions list size after sync/refresh: ${questions.length}"); // TRACE 7

        // ✅ إعادة فرز القائمة بعد المزامنة
        questions.sort((a, b) => a.order?.compareTo(b.order ?? 9999) ?? -1);
      } else {
        if (!isAutoSync) {
          // KLoaders.warning(
          //     title: "لا يوجد اتصال بالإنترنت",
          //     message: "تم عرض البيانات المحلية فقط.",
          // );
        }
      }
    } catch (e, stack) {
      // تم إضافة Stack Trace لفهم مصدر الخطأ بدقة
      error.value = e.toString();
      KLoaders.error(title: "خطأ في التحميل/المزامنة", message: e.toString());
      print("!!! FATAL ERROR CAUGHT IN fetchQuestions !!!"); // TRACE 8
      print("خطأ في التحميل/المزامنة: ${e.toString()}");
      print("Stack Trace: $stack"); // TRACE 9
    } finally {
      isLoading.value = false;
      print("--- DEBUG TRACE: fetchQuestions finished. ---"); // TRACE 10
    }
  }

  Future<void> saveQuestion(Map<String, dynamic> data,
      {String? questionId}) async {
    if (_isSyncing.value) return;
    _isSyncing.value = true;
    error.value = null;

    try {
      if (questionId == null) {
        // إضافة سؤال جديد
        // 💡 نحدد الترتيب بناءً على حجم القائمة لضمان إضافته في النهاية
        final newOrder = questions.length;

        final newQuestion = await localRepo.createLocalQuestion(
          text: data['text'],
          lessonId: lessonId,
          type: data['type'],
          data: data,
          order: newOrder, // ⬅️ الترتيب محدد داخليًا
        );
        questions.add(newQuestion);
        questions.sort((a, b) => a.order?.compareTo(b.order ?? 9999) ?? -1);
        KLoaders.success(title: "نجاح", message: "تمت إضافة السؤال بنجاح.");
      } else {
        // تعديل سؤال موجود
        final existingQuestion =
            questions.firstWhereOrNull((q) => q.id == questionId);
        if (existingQuestion == null) {
          throw Exception("السؤال غير موجود محلياً للتحرير.");
        }

        // استخدام toMap لتضمين الحقول الإضافية
        final updatedData = {
          ...data,
          'id': questionId,
          'lessonId': lessonId,
          'createdAt': existingQuestion.createdAt?.toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
          'deleted': false,
          'isSynced': false,
          'order': existingQuestion.order, // ⬅️ الحفاظ على الترتيب القديم
        };

        final updatedQuestionModel = BaseQuestion.fromJson(updatedData);
        await localRepo.updateQuestionLocal(updatedQuestionModel);

        final index = questions.indexWhere((q) => q.id == questionId);
        if (index != -1) {
          questions[index] = updatedQuestionModel;
          // الترتيب لا يتغير في التحديث، لذا لا داعي للفرز هنا إلا إذا تم تغيير الترتيب يدوياً
        }
        KLoaders.success(title: "نجاح", message: "تم تحديث السؤال بنجاح.");
      }

      if (await NetworkManager.instance.isConnected()) {
        await syncService.pushPending();
      }
    } catch (e) {
      error.value = e.toString();

      KLoaders.error(title: "خطأ في الحفظ", message: e.toString());
      print("خطأ في الحفظ${e.toString()}");
    } finally {
      _isSyncing.value = false;
    }
  }

  Future<void> deleteQuestion(String id) async {
    if (_isSyncing.value) return;
    _isSyncing.value = true;
    error.value = null;
    try {
      await localRepo.markAsDeleted(id);
      questions.removeWhere((q) => q.id == id);
      KLoaders.success(title: "نجاح", message: "تم حذف السؤال بنجاح.");
      if (await NetworkManager.instance.isConnected()) {
        await syncService.pushPending();
      }
    } catch (e) {
      error.value = e.toString();
      KLoaders.error(title: "خطأ في حذف السؤال", message: e.toString());
    } finally {
      _isSyncing.value = false;
    }
  }

  // ✅ دالة تحديث الترتيب (تبقى كما هي)
  Future<void> updateQuestionOrder(int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final question = questions.removeAt(oldIndex);
    questions.insert(newIndex, question);

    // تحديث حقل الترتيب لكل سؤال في القائمة
    for (int i = 0; i < questions.length; i++) {
      final q = questions[i];
      if (q.order != i) {
        final updatedQuestion = BaseQuestion.fromJson({
          ...q.toJson(),
          'id': q.id,
          'lessonId': q.lessonId,
          'order': i,
          'updatedAt': DateTime.now().toIso8601String(),
          'isSynced': false, // وضعها false للمزامنة
          'deleted': q.deleted,
        });
        // تحديث القائمة المراقبة (Observable List) لتضمن أن القيمة i هي القيمة الجديدة
        questions[i] = updatedQuestion;
        await localRepo.updateQuestionLocal(updatedQuestion);
      }
    }

    if (await NetworkManager.instance.isConnected()) {
      await syncService.pushPending();
    }
  }
}
