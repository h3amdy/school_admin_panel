// lib/features/question/models/essay_question.dart
import 'package:ashil_school/features/question/models/base_question.dart';

class EssayQuestion extends BaseQuestion {
  final String? sampleAnswer;

  EssayQuestion({
    required super.id,
    required super.lessonId,
    required super.text,
    this.sampleAnswer,
    super.order,
    super.createdAt,
    super.updatedAt,
    super.isSynced,
    super.deleted,
    super.explanation,
  }) : super(type: QuestionType.essay);

  factory EssayQuestion.fromJson(Map<String, dynamic> json) {
    return EssayQuestion(
      id: json['id'],
      lessonId: json['lessonId'],
      text: json['text'],
      sampleAnswer: json['sampleAnswer'],
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
        'sampleAnswer': sampleAnswer,
        'order': order,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'isSynced': isSynced,
        'deleted': deleted,
        'explanation': explanation,
      };
}
