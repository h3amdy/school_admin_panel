import 'package:ashil_school/features/question/models/base_question.dart';

class TrueFalseQuestion extends BaseQuestion {
  final bool isTrue;

  TrueFalseQuestion({
    required super.id,
    required super.lessonId,
    required super.text,
    required this.isTrue,
    super.order,
    super.createdAt,
    super.updatedAt,
    super.isSynced,
    super.deleted,
    super.explanation,
  }) : super(type: QuestionType.trueFalse);

  factory TrueFalseQuestion.fromJson(Map<String, dynamic> json) {
    return TrueFalseQuestion(
      id: json['id'],
      lessonId: json['lessonId'],
      text: json['text'],
      // يُفترض أن 'isTrue' هي قيمة boolean وليست قائمة، لذلك لا تحتاج لـ ?? []
      isTrue: json['isTrue'] ?? false,
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
        'isTrue': isTrue,
        'order': order,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'isSynced': isSynced,
        'deleted': deleted,
        'explanation': explanation,
      };
}
