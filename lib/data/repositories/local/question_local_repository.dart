import 'package:ashil_school/data/local/app_database.dart';
import 'package:ashil_school/features/question/models/base_question.dart';
import 'package:drift/drift.dart';
import 'package:get/get.dart' hide Value;
import 'package:uuid/uuid.dart';
import 'dart:convert';

class QuestionLocalRepository {
  final AppDatabase db = Get.find<AppDatabase>();
  final _uuid = const Uuid();

  QuestionLocalRepository();

  // 💡 دالة مساعدة لاستخراج البيانات الديناميكية فقط
  Map<String, dynamic> _extractDynamicData(BaseQuestion question) {
    final jsonMap = question.toJson();
    final dynamicData = Map<String, dynamic>.from(jsonMap);
    // إزالة الحقول الثابتة التي يتم تخزينها في أعمدة الجدول المنفصلة
    dynamicData.remove('id');
    dynamicData.remove('lessonId');
    dynamicData.remove('text');
    dynamicData.remove('type');
    dynamicData.remove('order');
    dynamicData.remove('createdAt');
    dynamicData.remove('updatedAt');
    dynamicData.remove('isSynced');
    dynamicData.remove('deleted');
    // إزالة explanation لأنها محفوظة في عمود منفصل
    dynamicData.remove('explanation');

    return dynamicData;
  }

  BaseQuestion _fromRow(QuestionTable row) {
    // فك تشفير البيانات العامة المخزنة في حقل 'data'
    final Map<String, dynamic> dynamicData = json.decode(row.data);

    // دمج جميع الحقول في خريطة واحدة (الحقول الثابتة تأتي أولاً لتكون أساسية)
    final Map<String, dynamic> fullData = {
      // حقول من صف قاعدة البيانات
      'id': row.id,
      'lessonId': row.lessonId,
      'text': row.questionText,
      'type': row.type,
      'createdAt': row.createdAt?.toIso8601String(),
      'updatedAt': row.updatedAt?.toIso8601String(),
      'isSynced': row.isSynced,
      'deleted': row.deleted,
      'order': row.order,
      'explanation': row.explanation, // 💡 إضافة explanation من العمود المنفصل
      // دمج البيانات الخاصة بالأسئلة من حقل 'data' - هنا تأتي الحقول مثل options
      ...dynamicData,
    };

    return BaseQuestion.fromJson(fullData);
  }

  Future<List<BaseQuestion>> getAllQuestionsByLessonId(String lessonId,
      {bool includeDeleted = false}) async {
    final query = db.select(db.questions)
      ..where((tbl) => tbl.lessonId.equals(lessonId));
    if (!includeDeleted) {
      query.where((tbl) => tbl.deleted.equals(false));
    }
    final rows = await query.get();
    return rows.map(_fromRow).toList();
  }

  Future<BaseQuestion> createLocalQuestion({
    required String lessonId,
    required String text,
    required String type,
    required Map<String, dynamic> data,
    int? order,
  }) async {
    final id = _uuid.v4();
    final now = DateTime.now();

    // 💡 إنشاء fullData أولاً للحصول على كائن السؤال الكامل
    final fullData = {
      ...data,
      'id': id,
      'lessonId': lessonId,
      'text': text,
      'type': type,
      'createdAt': now.toIso8601String(),
      'updatedAt': now.toIso8601String(),
      'isSynced': false,
      'deleted': false,
      'order': order,
    };
    final question = BaseQuestion.fromJson(fullData);

    // 💡 استخدام دالة مساعدة لحفظ البيانات الديناميكية فقط في حقل 'data'
    final dynamicPayload = _extractDynamicData(question);

    await db.into(db.questions).insert(
          QuestionsCompanion.insert(
            id: question.id,
            lessonId: question.lessonId,
            questionText: question.text,
            type: question.type.name,
            data:
                json.encode(dynamicPayload), // 💡 حفظ البيانات الديناميكية فقط
            explanation:
                Value(question.explanation), // 💡 حفظ explanation في عمود منفصل
            createdAt: Value(now),
            updatedAt: Value(now),
            order: Value(order),
            isSynced: const Value(false),
            deleted: const Value(false),
          ),
        );
    return question;
  }

  Future<void> updateQuestionLocal(BaseQuestion question) async {
    final now = DateTime.now();

    // 💡 استخدام دالة مساعدة لحفظ البيانات الديناميكية فقط في حقل 'data'
    final dynamicPayload = _extractDynamicData(question);

    await (db.update(db.questions)..where((t) => t.id.equals(question.id)))
        .write(
      QuestionsCompanion(
        questionText: Value(question.text),
        type: Value(question.type.name),
        data: Value(
            json.encode(dynamicPayload)), // 💡 حفظ البيانات الديناميكية فقط
        explanation:
            Value(question.explanation), // 💡 حفظ explanation في عمود منفصل
        updatedAt: Value(now),
        order: Value(question.order),
        isSynced: const Value(false),
        deleted: Value(question.deleted),
      ),
    );
  }

  Future<void> markAsDeleted(String id) async {
    await (db.update(db.questions)..where((t) => t.id.equals(id))).write(
      const QuestionsCompanion(deleted: Value(true), isSynced: Value(false)),
    );
  }

  Future<void> deleteQuestionPermanently(String id) async {
    await (db.delete(db.questions)..where((t) => t.id.equals(id))).go();
  }

  Future<List<BaseQuestion>> getPendingSync() async {
    final rows = await (db.select(db.questions)
          ..where((t) => t.isSynced.equals(false)))
        .get();
    return rows.map(_fromRow).toList();
  }

  Future<void> updateQuestionSynced(String id, {DateTime? updatedAt}) async {
    await (db.update(db.questions)..where((t) => t.id.equals(id))).write(
      QuestionsCompanion(
        isSynced: const Value(true),
        updatedAt: Value(updatedAt ?? DateTime.now()),
      ),
    );
  }

  Future<void> upsertQuestion(BaseQuestion questionFromServer) async {
    // 💡 استخدام دالة مساعدة لحفظ البيانات الديناميكية فقط في حقل 'data'
    final dynamicPayload = _extractDynamicData(questionFromServer);

    await db.into(db.questions).insertOnConflictUpdate(
          QuestionsCompanion.insert(
            id: questionFromServer.id,
            lessonId: questionFromServer.lessonId,
            questionText: questionFromServer.text,
            type: questionFromServer.type.name,
            data:
                json.encode(dynamicPayload), // 💡 حفظ البيانات الديناميكية فقط
            explanation: Value(questionFromServer
                .explanation), // 💡 حفظ explanation في عمود منفصل
            createdAt: Value(questionFromServer.createdAt!),
            updatedAt: Value(questionFromServer.updatedAt!),
            order: Value(questionFromServer.order),
            isSynced: const Value(true),
            deleted: Value(questionFromServer.deleted),
          ),
        );
  }
}
