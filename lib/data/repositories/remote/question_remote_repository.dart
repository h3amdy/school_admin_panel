import 'dart:convert';
import 'package:ashil_school/data/services/server.dart';
import 'package:ashil_school/features/question/models/base_question.dart';

class QuestionRemoteRepository {
  Future<List<BaseQuestion>> fetchUpdatedQuestions(DateTime? lastSyncAt) async {
    final response = await Server.get(
      "questions",
      params: {
        if (lastSyncAt != null) "lastSyncAt": lastSyncAt.toIso8601String(),
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      // 💡 الإصلاح: دمج حقل 'data' مع حقول الجذر قبل إرساله إلى fromJson
      return data.map((e) {
        final Map<String, dynamic> rootData = Map.from(e);
        final Map<String, dynamic>? dynamicFields = rootData.remove('data');

        if (dynamicFields != null) {
          rootData.addAll(dynamicFields);
        }

        // يجب تسمية حقل المعرف بـ 'id' بدلاً من '_id' كما يرسله الخادم أحياناً
        if (rootData.containsKey('_id')) {
          rootData['id'] = rootData['_id'];
          rootData.remove('_id');
        }

        return BaseQuestion.fromJson(rootData);
      }).toList();
    } else {
      throw Exception("Failed to fetch questions: ${response.statusCode}");
    }
  }

  Future<void> pushQuestions(List<BaseQuestion> questions) async {
    final response = await Server.post(
      "questions/sync",
      // 💡 الإصلاح: تحويل كل سؤال بحيث تكون البيانات الديناميكية ضمن حقل 'data'
      params: {
        "questions": questions.map((q) {
          final json = q.toJson();
          // فصل الحقول الثابتة عن الديناميكية
          final dynamicFields = {};

          // تحديد الحقول الديناميكية بناءً على النوع
          switch (q.type) {
            case QuestionType.mcq:
              dynamicFields['options'] = json.remove('options');
              dynamicFields['correctAnswerIndexes'] =
                  json.remove('correctAnswerIndexes');
              break;
            case QuestionType.matching:
              dynamicFields['leftItems'] = json.remove('leftItems');
              dynamicFields['rightItems'] = json.remove('rightItems');
              dynamicFields['correctPairs'] = json.remove('correctPairs');
              break;
            case QuestionType.ordering:
              dynamicFields['items'] = json.remove('items');
              dynamicFields['correctOrder'] = json.remove('correctOrder');
              break;
            case QuestionType.fillBlank:
              dynamicFields['correctAnswers'] = json.remove('correctAnswers');
              break;
            case QuestionType.essay:
              dynamicFields['sampleAnswer'] = json.remove('sampleAnswer');
              break;
            case QuestionType.trueFalse:
              dynamicFields['isTrue'] = json.remove('isTrue');
              break;
          }

          // حقل explanation يتم إضافته إلى البيانات الديناميكية
          if (json.containsKey('explanation')) {
            dynamicFields['explanation'] = json.remove('explanation');
          } else if (q.explanation != null) {
            dynamicFields['explanation'] = q.explanation;
          }

          // دمج البيانات الديناميكية في حقل 'data'
          json['data'] = dynamicFields;

          // إعادة تسمية id إلى _id قبل الإرسال للخادم (الذي يستخدم _id)
          json['_id'] = json.remove('id');

          return json;
        }).toList(),
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    } else {
      throw Exception("Failed to push questions: ${response.statusCode}");
    }
  }
}
