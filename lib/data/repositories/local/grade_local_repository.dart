import 'package:ashil_school/data/local/app_database.dart';
import 'package:ashil_school/features/grade/models/grade.dart';
import 'package:drift/drift.dart';
import 'package:get/get.dart' hide Value;
import 'package:uuid/uuid.dart';

class GradeLocalRepository {
   final AppDatabase db=Get.find<AppDatabase>();
  final _uuid = const Uuid();

  GradeLocalRepository();

  // تم تصحيح هذا السطر
  GradeModel _fromRow(Grade row) {
    return GradeModel(
      id: row.id,
      name: row.name,
      order: row.order,
      description: row.description,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      semesters: null,
      isSynced: row.isSynced,
      deleted: row.deleted,
    );
  }

  /// جلب كل الصفوف محلياً (مرتبة حسب order، وتجاهل المحذوفة منطقياً عادةً)
  Future<List<GradeModel>> getAll({bool includeDeleted = false}) async {
    final query = db.select(db.grades)..orderBy([(t) => OrderingTerm(expression: t.order)]);
    if (!includeDeleted) {
      query.where((tbl) => tbl.deleted.equals(false));
    }
    final rows = await query.get();
    return rows.map(_fromRow).toList();
  }

  /// جلب صف واحد بالـ ID
  Future<GradeModel?> getById(String id) async {
    final row = await (db.select(db.grades)..where((t) => t.id.equals(id))).getSingleOrNull();
    return row != null ? _fromRow(row) : null;
  }

  /// إدراج صف جديد محلياً (مُولَّد id محلي)
  Future<void> insertGradeModel(GradeModel grade) async {
    await db.into(db.grades).insert(
      GradesCompanion.insert(
        id: grade.id, 
        name: grade.name,
        order: grade.order,
        description: Value(grade.description),
        createdAt: Value(grade.createdAt ?? DateTime.now()),
        updatedAt: Value(grade.updatedAt ?? DateTime.now()),
        isSynced: const Value(false),
        deleted: const Value(false),
      ),
    );
  }

  /// إدراج مباشر من الحقول (يسهل الاستخدام)
  Future<GradeModel> createLocalGrade({required String name, required int order, String? description}) async {
    final id = _uuid.v4();
    final now = DateTime.now();
    final grade = GradeModel(
      id: id,
      name: name,
      order: order,
      description: description,
      createdAt: now,
      updatedAt: now,
      deleted: false, // افتراضيًا غير محذوف عند الإنشاء
    );
    await insertGradeModel(grade);
    return grade;
  }

  /// تحديث محلي: اجعل updatedAt = now و isSynced = false
  Future<void> updateGradeLocal(GradeModel grade) async {
    final now = DateTime.now();
    await (db.update(db.grades)..where((t) => t.id.equals(grade.id))).write(
      GradesCompanion(
        name: Value(grade.name),
        order: Value(grade.order),
        description: Value(grade.description),
        updatedAt: Value(now),
        isSynced: const Value(false),
        deleted: Value(grade.deleted), // تأكد من تمرير حالة الحذف
      ),
    );
  }

  /// وضع علامة حذف منطقي محلياً
  Future<void> markAsDeleted(String id) async {
    await (db.update(db.grades)..where((t) => t.id.equals(id))).write(
      const GradesCompanion(deleted: Value(true), isSynced: Value(false)),
    );
  }
  
  /// حذف سجل بشكل دائم من القاعدة المحلية (عندما يكون محذوفاً من السيرفر)
  Future<void> deleteGradePermanently(String id) async {
    await (db.delete(db.grades)..where((t) => t.id.equals(id))).go();
  }

  /// سجلات تنتظر الرفع (isSynced == false)
  Future<List<GradeModel>> getPendingSync() async {
    // جلب السجلات غير المتزامنة، بما في ذلك المحذوفة منطقياً
    final rows = await (db.select(db.grades)..where((t) => t.isSynced.equals(false))).get();
    return rows.map(_fromRow).toList();
  }

  /// بعد نجاح الرفع على السيرفر نعلِّم أنها متزامنة ونعطي updatedAt ممكن من السيرفر
  Future<void> updateGradeSynced(String id, {DateTime? updatedAt}) async {
    await (db.update(db.grades)..where((t) => t.id.equals(id))).write(
      GradesCompanion(
        isSynced: const Value(true),
        updatedAt: Value(updatedAt ?? DateTime.now()),
      ),
    );
  }

  /// إدخال أو تحديث (upsert) لما نأتي من السيرفر
  Future<void> upsertGrade(GradeModel gradeFromServer) async {
    // ملاحظة: Drift يتطلب Value() لكل حقل في insertOnConflictUpdate
    await db.into(db.grades).insertOnConflictUpdate(
      GradesCompanion(
        id: Value(gradeFromServer.id), // id يجب ألا يكون null
        name: Value(gradeFromServer.name),
        order: Value(gradeFromServer.order),
        description: Value(gradeFromServer.description),
        createdAt: Value(gradeFromServer.createdAt ?? DateTime.now()),
        updatedAt: Value(gradeFromServer.updatedAt ?? DateTime.now()),
        isSynced: const Value(true), // دائمًا متزامنة إذا جاءت من السيرفر
        deleted: Value(gradeFromServer.deleted ), // تعيين حسب قيمة السيرفر
      ),
    );
  }
}