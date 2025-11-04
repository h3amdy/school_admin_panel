import 'package:ashil_school/features/question/models/base_question.dart';
import 'package:ashil_school/features/question/models/option_model.dart';
import 'dart:convert'; // 💡 تم إضافة الاستيراد هنا

class MatchingQuestion extends BaseQuestion {
  final List<Option> leftItems;
  final List<Option> rightItems;
  final Map<int, int> correctPairs; // indexLeft → indexRight

  MatchingQuestion({
    required super.id,
    required super.lessonId,
    required super.text,
    required this.leftItems,
    required this.rightItems,
    required this.correctPairs,
    super.order,
    super.createdAt,
    super.updatedAt,
    super.isSynced,
    super.deleted,
    super.explanation,
  }) : super(type: QuestionType.matching);

  factory MatchingQuestion.fromJson(Map<String, dynamic> json) {
    // تأمين قراءة القوائم ضد null
    final leftItemsJson = json['leftItems'] as List<dynamic>? ?? [];
    final rightItemsJson = json['rightItems'] as List<dynamic>? ?? [];

    return MatchingQuestion(
      id: json['id'],
      lessonId: json['lessonId'],
      text: json['text'],
      // 💡 الإصلاح: فحص وتحويل String إلى Map لـ leftItems
      leftItems: leftItemsJson.map((e) {
        final Map<String, dynamic> mapData = e is String
            ? jsonDecode(e) as Map<String, dynamic>
            : e as Map<String, dynamic>;
        return Option.fromJson(mapData);
      }).toList(),
      // 💡 الإصلاح: فحص وتحويل String إلى Map لـ rightItems
      rightItems: rightItemsJson.map((e) {
        final Map<String, dynamic> mapData = e is String
            ? jsonDecode(e) as Map<String, dynamic>
            : e as Map<String, dynamic>;
        return Option.fromJson(mapData);
      }).toList(),
      correctPairs: Map<int, int>.from(json['correctPairs'] ?? {}),
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
        'leftItems': leftItems.map((o) => o.toJson()).toList(),
        'rightItems': rightItems.map((o) => o.toJson()).toList(),
        'correctPairs': correctPairs,
        'order': order,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'isSynced': isSynced,
        'deleted': deleted,
        'explanation': explanation,
      };
}
