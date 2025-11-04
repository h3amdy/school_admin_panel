import 'package:ashil_school/features/question/models/base_question.dart';
import 'package:ashil_school/features/question/models/option_model.dart';
import 'dart:convert'; // 💡 تم إضافة الاستيراد هنا

class MCQQuestion extends BaseQuestion {
  final List<Option> options;
  final List<int> correctAnswerIndexes; // أكثر من إجابة صحيحة

  MCQQuestion({
    required super.id,
    required super.lessonId,
    required super.text,
    required this.options,
    required this.correctAnswerIndexes,
    super.order,
    super.createdAt,
    super.updatedAt,
    super.isSynced,
    super.deleted,
    super.explanation,
  }) : super(type: QuestionType.mcq);

  factory MCQQuestion.fromJson(Map<String, dynamic> json) {
    // تأمين قراءة القوائم ضد null
    final optionsJson = json['options'] as List<dynamic>? ?? [];
    final correctIndexesJson =
        json['correctAnswerIndexes'] as List<dynamic>? ?? [];

    return MCQQuestion(
      id: json['id'],
      lessonId: json['lessonId'],
      text: json['text'],
      // 💡 الإصلاح: فحص إذا كان العنصر string، نقوم بتحويله إلى Map باستخدام jsonDecode
      options: optionsJson.map((e) {
        final Map<String, dynamic> mapData = e is String
            ? jsonDecode(e) as Map<String, dynamic>
            : e as Map<String, dynamic>;
        return Option.fromJson(mapData);
      }).toList(),
      correctAnswerIndexes: List<int>.from(correctIndexesJson),
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
        'options': options.map((o) => o.toJson()).toList(),
        'correctAnswerIndexes': correctAnswerIndexes,
        'order': order,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'isSynced': isSynced,
        'deleted': deleted,
        'explanation': explanation,
      };
}
