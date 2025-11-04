import 'package:ashil_school/features/question/models/base_question.dart';

String getQuestionTypeName(QuestionType type) {
  switch (type) {
    case QuestionType.mcq:
      return "خيارات";
    case QuestionType.trueFalse:
      return " صح أو خطأ";
    case QuestionType.matching:
      return " مطابقة";
    case QuestionType.fillBlank:
      return " ملء الفراغ";
    case QuestionType.ordering:
      return " ترتيب";
    case QuestionType.essay:
      return " مقالي";
    default:
      return "نوع غير معروف"; // Good practice for robustness
  }
}