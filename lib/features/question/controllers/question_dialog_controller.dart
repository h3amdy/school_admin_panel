// question_dialog_controller.dart
// تم التعديل لإضافة حقل الترتيب.
import 'package:ashil_school/features/question/models/essay_question.dart';
import 'package:ashil_school/features/question/models/fill_blank_question.dart';
import 'package:ashil_school/features/question/models/matching_question.dart';
import 'package:ashil_school/features/question/models/mcq_question.dart';
import 'package:ashil_school/features/question/models/option_model.dart';
import 'package:ashil_school/features/question/models/ordering_question.dart';
import 'package:ashil_school/features/question/models/true_false_question.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ashil_school/features/question/models/base_question.dart';

class QuestionDialogController extends GetxController {
  final _questionTextController = TextEditingController();
  final _orderController = TextEditingController(); // ✅ إضافة حقل الترتيب
  final _selectedType = Rx<QuestionType>(QuestionType.mcq);
  final _questionData = <String, dynamic>{}.obs;
  final _explanationController = TextEditingController(); // ✅ NEW: حقل شرح الإجابة
   final mcqOptions = <Option>[].obs;
  final mcqCorrectAnswerIndexes = <int>[].obs;

   final matchingLeftItems = <Option>[].obs;
  final matchingRightItems = <Option>[].obs;
  final matchingCorrectPairs = <int, int>{}.obs;

  final fillBlankCorrectAnswers = <TextEditingController>[].obs;

final orderingItems = <Option>[].obs;
  final orderingCorrectOrder = <int>[].obs; // ✅ NEW: الترتيب الصحيح

  @override
  void onInit() {
    super.onInit();
    _questionTextController.addListener(() {
      if (_selectedType.value == QuestionType.fillBlank) {
        _reNumberFillBlanks();
      }
    });
  }

  void loadQuestionForEdit(BaseQuestion question) {
    _questionTextController.text = question.text;
    _selectedType.value = question.type;
    _orderController.text = question.order?.toString() ?? '0'; 
    _explanationController.text = question.explanation ?? ''; // ✅ تعبئة الشرح
    _clearFields(); // مسح أي حقول سابقة

    // تعبئة البيانات حسب نوع السؤال
    switch (question.type) {
      case QuestionType.mcq:
        final mcq = question as MCQQuestion;
        mcqOptions.assignAll(mcq.options); // ✅ استخدام Option
        mcqCorrectAnswerIndexes.assignAll(mcq.correctAnswerIndexes); // ✅ قائمة فهارس
        break;
      case QuestionType.trueFalse:
        final tf = question as TrueFalseQuestion;
        _questionData['isTrue'] = tf.isTrue;
        break;
      case QuestionType.matching:
        final matching = question as MatchingQuestion;
        matchingLeftItems.assignAll(matching.leftItems); // ✅ استخدام Option
        matchingRightItems.assignAll(matching.rightItems); // ✅ استخدام Option
        matchingCorrectPairs.assignAll(matching.correctPairs); // ✅ Map<int, int>
        break;
      case QuestionType.fillBlank:
        final fillBlank = question as FillBlankQuestion;
        _questionTextController.text = fillBlank.text;
        fillBlankCorrectAnswers.assignAll(fillBlank.correctAnswers.map((e) => TextEditingController(text: e)));
        break;
      case QuestionType.ordering:
        final ordering = question as OrderingQuestion;
        orderingItems.assignAll(ordering.items); // ✅ استخدام Option
        orderingCorrectOrder.assignAll(ordering.correctOrder); // ✅ قائمة الترتيب
        break;
      case QuestionType.essay:
        final essay = question as EssayQuestion;
        _questionData['sampleAnswer'] = essay.sampleAnswer;
        break;
    }
  }

 // 💡 الدوال التالية تتطلب تغييرًا لتدعم Option بدلاً من TextEditingController
  // ملاحظة: يمكنك إضافة طرق لإضافة خيارات بنوع صورة أو صوت لاحقًا من الـ UI.
  void addField(QuestionType type) {
    // 💡 التغيير: إضافة Option فارغة بدلاً من TextEditingController
    final emptyOption = Option(text: '');
    switch (type) {
      case QuestionType.mcq:
        mcqOptions.add(emptyOption);
        break;
      case QuestionType.matching:
        matchingLeftItems.add(emptyOption);
        matchingRightItems.add(emptyOption);
        break;
      case QuestionType.ordering:
        orderingItems.add(emptyOption);
        break;
      default:
        break;
    }
  }
 void removeField(QuestionType type, int index) {
    switch (type) {
      case QuestionType.mcq:
        if (index < mcqOptions.length) {
          mcqOptions.removeAt(index);
          // 💡 تحديث فهارس الإجابات الصحيحة بعد الحذف
          mcqCorrectAnswerIndexes.removeWhere((i) => i == index);
          mcqCorrectAnswerIndexes.assignAll(mcqCorrectAnswerIndexes.map((i) => i > index ? i - 1 : i).toList());
        }
        break;
      case QuestionType.matching:
        if (index < matchingLeftItems.length) {
          matchingLeftItems.removeAt(index);
          matchingRightItems.removeAt(index);
          // 💡 تحديث أزواج المطابقة بعد الحذف (تحديث الفهارس)
          matchingCorrectPairs.removeWhere((left, right) => left == index);
          matchingCorrectPairs.assignAll(matchingCorrectPairs.map((left, right) => MapEntry(
            left > index ? left - 1 : left,
            right, // لا حاجة لتحديث فهارس rightItems هنا إلا إذا كنت تستخدم نفس القائمة
          )));
        }
        break;
      case QuestionType.ordering:
        if (index < orderingItems.length) {
          orderingItems.removeAt(index);
          // 💡 تحديث الترتيب الصحيح بعد الحذف
          orderingCorrectOrder.removeWhere((i) => i == index);
          orderingCorrectOrder.assignAll(orderingCorrectOrder.map((i) => i > index ? i - 1 : i).toList());
        }
        break;
      default:
        break;
    }
  }

  void addFillBlank() {
    final currentText = _questionTextController.text;
    final currentCursorPos = _questionTextController.selection.isValid
        ? _questionTextController.selection.baseOffset
        : currentText.length;

    const newBlank = ' {{}} ';
    final newText = currentText.substring(0, currentCursorPos) +
        newBlank +
        currentText.substring(currentCursorPos);

    final newOffset = currentCursorPos + newBlank.length;

    _questionTextController.value = _questionTextController.value.copyWith(
      text: newText,
      selection: TextSelection.fromPosition(TextPosition(offset: newOffset)),
      composing: TextRange.empty,
    );

    _reNumberFillBlanks();
  }

  void removeFillBlank(int index) {
    final regex = RegExp(r'\{\{.*?\}\}');
    final currentText = _questionTextController.text;
    final matches = regex.allMatches(currentText).toList();

    if (index >= 0 && index < matches.length) {
      final match = matches[index];
      final newText = currentText.substring(0, match.start) +
          currentText.substring(match.end);

      _questionTextController.value = _questionTextController.value.copyWith(
        text: newText,
        selection: TextSelection.fromPosition(
            TextPosition(offset: match.start.clamp(0, newText.length))),
        composing: TextRange.empty,
      );
    }
    _reNumberFillBlanks();
  }

  void _reNumberFillBlanks() {
    final regex = RegExp(r'\{\{.*?\}\}');
    String newText = _questionTextController.text;
    final currentSelection = _questionTextController.selection;
    final matches = regex.allMatches(newText).toList();

    int newBlankNumber = 1;
    for (final match in matches) {
      final oldBlankText = match.group(0)!;
      final newBlankText = '{{$newBlankNumber}}';
      newText = newText.replaceFirst(oldBlankText, newBlankText);
      newBlankNumber++;
    }

    if (newText != _questionTextController.text) {
      final newOffset = currentSelection.start.clamp(0, newText.length);
      _questionTextController.value = _questionTextController.value.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: newOffset),
        composing: TextRange.empty,
      );
    }

    final newBlanksCount =
        regex.allMatches(_questionTextController.text).length;
    final currentAnswersCount = fillBlankCorrectAnswers.length;

    if (newBlanksCount > currentAnswersCount) {
      for (int i = 0; i < newBlanksCount - currentAnswersCount; i++) {
        fillBlankCorrectAnswers.add(TextEditingController());
      }
    } else if (newBlanksCount < currentAnswersCount) {
      for (int i = 0; i < currentAnswersCount - newBlanksCount; i++) {
        fillBlankCorrectAnswers.removeLast().dispose();
      }
    }
  }

  void setSelectedType(QuestionType? type) {
    if (type != null) {
      _selectedType.value = type;
      _clearFields();
    }
  }

   void _clearFields() {
    mcqOptions.clear();
    mcqCorrectAnswerIndexes.clear(); // 💡 التغيير: clear بدلاً من تعيين قيمة null
    matchingLeftItems.clear();
    matchingRightItems.clear();
    matchingCorrectPairs.clear();
    fillBlankCorrectAnswers.clear();
    orderingItems.clear();
    orderingCorrectOrder.clear();
  }
  Map<String, dynamic> prepareQuestionData() {
    final data = <String, dynamic>{
      'text': questionTextController.text.trim(),
      'type': selectedType.value.name,
      'order': int.tryParse(_orderController.text.trim()) ?? 0, 
      'explanation': _explanationController.text.trim(), // ✅ إضافة الشرح
    };

    switch (selectedType.value) {
      case QuestionType.mcq:
        // 💡 التغيير: تحويل List<Option> إلى List<Map>
        data['options'] = mcqOptions.map((o) => o.toJson()).toList();
        // 💡 التغيير: استخدام قائمة الفهارس
        data['correctAnswerIndexes'] = mcqCorrectAnswerIndexes.toList(); 
        break;
      case QuestionType.trueFalse:
        data['isTrue'] = questionData['isTrue'] ?? false;
        break;
      case QuestionType.fillBlank:
        data['correctAnswers'] = fillBlankCorrectAnswers.map((e) => e.text.trim()).toList();
        break;
      case QuestionType.matching:
        // 💡 التغيير: تحويل List<Option> إلى List<Map> 
        data['leftItems'] = matchingLeftItems.map((o) => o.toJson()).toList();
        data['rightItems'] = matchingRightItems.map((o) => o.toJson()).toList();
        // 💡 التغيير: correctPairs موجود كـ Map<int, int> بالفعل
        data['correctPairs'] = matchingCorrectPairs.map((k, v) => MapEntry(k.toString(), v)); 
        break;
      case QuestionType.ordering:
        // 💡 التغيير: تحويل List<Option> إلى List<Map> 
        data['items'] = orderingItems.map((o) => o.toJson()).toList();
        // 💡 التغيير: إضافة الترتيب الصحيح
        data['correctOrder'] = orderingCorrectOrder.toList(); 
        break;
      case QuestionType.essay:
        if (questionData.containsKey('sampleAnswer')) {
          data['sampleAnswer'] = questionData['sampleAnswer'];
        }
        break;
    }
    return data;
  }
   // 💡 دوال مساعدة لـ MCQ لتحديد الإجابة الصحيحة (ستستخدم في الـ UI)
  void toggleCorrectMCQAnswer(int index, bool isMultiple) {
    if (mcqCorrectAnswerIndexes.contains(index)) {
      mcqCorrectAnswerIndexes.remove(index);
    } else {
      if (!isMultiple) {
        mcqCorrectAnswerIndexes.clear();
      }
      mcqCorrectAnswerIndexes.add(index);
    }
  }
 TextEditingController get questionTextController => _questionTextController;
  TextEditingController get orderController => _orderController;
  TextEditingController get explanationController => _explanationController; // ✅ NEW GETTER
  Rx<QuestionType> get selectedType => _selectedType;
  Map<String, dynamic> get questionData => _questionData;

  @override
  void onClose() {
   
    _questionTextController.dispose();
    _orderController.dispose();
    _explanationController.dispose(); // ✅ التخلص من المتحكم
    for (var controller in fillBlankCorrectAnswers) {
      controller.dispose();
    }
    for (var controller in fillBlankCorrectAnswers) {
      controller.dispose();
    }
    
    super.onClose();
  }
}