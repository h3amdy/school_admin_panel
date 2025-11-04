import 'package:ashil_school/features/question/models/base_question.dart';
import 'package:ashil_school/features/question/models/option_model.dart';
import 'dart:convert'; // 💡 تم إضافة الاستيراد هنا

class OrderingQuestion extends BaseQuestion {
  final List<Option> items;
  final List<int> correctOrder; // ترتيب العناصر الصحيح

  OrderingQuestion({
    required super.id,
    required super.lessonId,
    required super.text,
    required this.items,
    required this.correctOrder,
    super.order,
    super.createdAt,
    super.updatedAt,
    super.isSynced,
    super.deleted,
    super.explanation,
  }) : super(type: QuestionType.ordering);

  factory OrderingQuestion.fromJson(Map<String, dynamic> json) {
    // تأمين قراءة القوائم ضد null
    final itemsJson = json['items'] as List<dynamic>? ?? [];
    final correctOrderJson = json['correctOrder'] as List<dynamic>? ?? [];

    return OrderingQuestion(
      id: json['id'],
      lessonId: json['lessonId'],
      text: json['text'],
      // 💡 الإصلاح: فحص وتحويل String إلى Map لـ items
      items: itemsJson.map((e) {
        final Map<String, dynamic> mapData = e is String
            ? jsonDecode(e) as Map<String, dynamic>
            : e as Map<String, dynamic>;
        return Option.fromJson(mapData);
      }).toList(),
      correctOrder: List<int>.from(correctOrderJson),
      order: json['order'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      isSynced: json['isSynced'] ?? false,
      deleted: json['deleted'] ?? false,
      explanation: json['explanation'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'lessonId': lessonId,
        'text': text,
        'type': type.name,
        'items': items.map((o) => o.toJson()).toList(),
        'correctOrder': correctOrder,
        'order': order,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'isSynced': isSynced,
        'deleted': deleted,
        'explanation': explanation,
      };
}
