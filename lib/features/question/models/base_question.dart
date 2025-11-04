import 'package:ashil_school/features/question/models/essay_question.dart';
import 'package:ashil_school/features/question/models/fill_blank_question.dart';
import 'package:ashil_school/features/question/models/matching_question.dart';
import 'package:ashil_school/features/question/models/mcq_question.dart';
import 'package:ashil_school/features/question/models/ordering_question.dart';
import 'package:ashil_school/features/question/models/true_false_question.dart';

enum QuestionType { mcq, trueFalse, matching, fillBlank, ordering, essay }

abstract class BaseQuestion {
  final String id; // uuid
  final String lessonId;
  final String text;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final QuestionType type;
  final int? order;
  final bool isSynced;
  final bool deleted;
  final String? explanation; // شرح الإجابة الصحيحة

  BaseQuestion({
    required this.id,
    required this.lessonId,
    required this.text,
    required this.type,
    this.order,
    this.createdAt,
    this.updatedAt,
    this.isSynced = false,
    this.deleted = false,
    this.explanation,
  });

  factory BaseQuestion.fromJson(Map<String, dynamic> json) {
    final type = QuestionType.values.firstWhere((e) => e.name == json['type']);
    switch (type) {
      case QuestionType.mcq:
        return MCQQuestion.fromJson(json);
      case QuestionType.trueFalse:
        return TrueFalseQuestion.fromJson(json);
      case QuestionType.matching:
        return MatchingQuestion.fromJson(json);
      case QuestionType.fillBlank:
        return FillBlankQuestion.fromJson(json);
      case QuestionType.ordering:
        return OrderingQuestion.fromJson(json);
      case QuestionType.essay:
        return EssayQuestion.fromJson(json);
    }
  }

  Map<String, dynamic> toJson();
}
