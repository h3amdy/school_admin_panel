// lib/features/question/models/fill_blank_question.dart
import 'package:ashil_school/features/question/models/base_question.dart';

class FillBlankQuestion extends BaseQuestion {
  final List<String> correctAnswers;

  FillBlankQuestion({
    required super.id,
    required super.lessonId,
    required super.text,
    required this.correctAnswers,
    super.order,
    super.createdAt,
    super.updatedAt,
    super.isSynced,
    super.deleted,
    super.explanation,
  }) : super(type: QuestionType.fillBlank);

  factory FillBlankQuestion.fromJson(Map<String, dynamic> json) {
    // ✅ الحل: استخدام ?? [] للتأكد من أن القيمة ليست null قبل التحويل إلى قائمة
    final answersList = json['correctAnswers'] as List<dynamic>? ?? [];

    return FillBlankQuestion(
      id: json['id'],
      lessonId: json['lessonId'],
      text: json['text'],
      correctAnswers: List<String>.from(answersList),
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
        'correctAnswers': correctAnswers,
        'order': order,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'isSynced': isSynced,
        'deleted': deleted,
        'explanation': explanation,
      };
}
