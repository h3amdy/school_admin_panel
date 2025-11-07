// question_dialog_controller.dart
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

  // ✅ T1: متغيرات لتخزين مرفقات نص السؤال
  final questionImageUrl = Rx<String?>(null);
  final questionAudioUrl = Rx<String?>(null);

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

    // ✅ T1: تحميل الميديا الخاصة بالسؤال
    try {
      questionImageUrl.value = (question as dynamic).imageUrl;
      questionAudioUrl.value = (question as dynamic).audioUrl;
    } catch (e) {
      print("Note: Could not load imageUrl/audioUrl from question model. $e");
      questionImageUrl.value = null;
      questionAudioUrl.value = null;
    }

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
        fillBlankCorrectAnswers.assignAll(
            fillBlank.correctAnswers.map((e) => TextEditingController(text: e)));
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

    // ✅ T2: التأكد من وجود حقلين على الأقل إذا كانت القوائم فارغة
    addFirstFieldIfNeeded(question.type);
  }

  void addField(QuestionType type) {
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
    // ✅ T1: تعديل: السماح بالحذف طالما لدينا أكثر من حقلين
    bool canDelete = false;
    switch (type) {
      case QuestionType.mcq:
        canDelete = mcqOptions.length > 2;
        break;
      case QuestionType.matching:
        // التحقق من أن كلاهما أكبر من 2 (رغم أنهما يجب أن يكونا متساويين)
        canDelete =
            matchingLeftItems.length > 2 && matchingRightItems.length > 2;
        break;
      case QuestionType.ordering:
        canDelete = orderingItems.length > 2;
        break;
      default:
        break; // Tpyes like fillBlank/trueFalse don't use this
    }

    if (!canDelete) return; // لا تحذف إذا وصلنا للحد الأدنى (حقلين)

    switch (type) {
      case QuestionType.mcq:
        if (index < mcqOptions.length) {
          mcqOptions.removeAt(index);
          mcqCorrectAnswerIndexes.removeWhere((i) => i == index);
          mcqCorrectAnswerIndexes.assignAll(mcqCorrectAnswerIndexes
              .map((i) => i > index ? i - 1 : i)
              .toList());
        }
        break;
      case QuestionType.matching:
        if (index < matchingLeftItems.length &&
            index < matchingRightItems.length) {
          matchingLeftItems.removeAt(index);
          matchingRightItems.removeAt(index);
          matchingCorrectPairs.removeWhere((left, right) => left == index);
          matchingCorrectPairs.assignAll(matchingCorrectPairs.map((left, right) => MapEntry(
                left > index ? left - 1 : left,
                right,
              )));
        }
        break;
      case QuestionType.ordering:
        if (index < orderingItems.length) {
          orderingItems.removeAt(index);
          orderingCorrectOrder.removeWhere((i) => i == index);
          orderingCorrectOrder.assignAll(orderingCorrectOrder
              .map((i) => i > index ? i - 1 : i)
              .toList());
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
    mcqCorrectAnswerIndexes.clear();
    matchingLeftItems.clear();
    matchingRightItems.clear();
    matchingCorrectPairs.clear();

    for (var controller in fillBlankCorrectAnswers) {
      controller.dispose();
    }
    fillBlankCorrectAnswers.clear();

    orderingItems.clear();
    orderingCorrectOrder.clear();

    // ✅ T2: إضافة الحقلين الأولين تلقائيًا
    addFirstFieldIfNeeded(_selectedType.value);
  }

  // ✅ T2: دالة مساعدة لإضافة الحقلين الأولين
  void addFirstFieldIfNeeded(QuestionType type) {
    // ✅ T4: إصلاح خطأ GlobalKey بإنشاء كائنات جديدة
    switch (type) {
      case QuestionType.mcq:
        if (mcqOptions.isEmpty) {
          mcqOptions.addAll([Option(text: ''), Option(text: '')]);
        }
        break;
      case QuestionType.matching:
        if (matchingLeftItems.isEmpty) {
          matchingLeftItems.addAll([Option(text: ''), Option(text: '')]);
          matchingRightItems.addAll([Option(text: ''), Option(text: '')]);
        }
        break;
      case QuestionType.ordering:
        if (orderingItems.isEmpty) {
          orderingItems.addAll([Option(text: ''), Option(text: '')]);
        }
        break;
      default:
        break;
    }
  }

  Map<String, dynamic> prepareQuestionData() {
    final data = <String, dynamic>{
      'text': questionTextController.text.trim(),
      'type': selectedType.value.name,
      'order': int.tryParse(_orderController.text.trim()) ?? 0,
      'explanation': _explanationController.text.trim(),
      'imageUrl': questionImageUrl.value,
      'audioUrl': questionAudioUrl.value,
    };

    switch (selectedType.value) {
      case QuestionType.mcq:
        data['options'] = mcqOptions
            // ✅ T1: إصلاح خطأ .isNotEmpty
            .where((o) =>
                (o.text ?? '').isNotEmpty ||
                o.imageUrl != null ||
                o.audioUrl != null)
            .map((o) => o.toJson())
            .toList();
        data['correctAnswerIndexes'] = mcqCorrectAnswerIndexes.toList();
        break;
      case QuestionType.trueFalse:
        data['isTrue'] = questionData['isTrue'] ?? false;
        break;
      case QuestionType.fillBlank:
        data['correctAnswers'] =
            fillBlankCorrectAnswers.map((e) => e.text.trim()).toList();
        break;
      case QuestionType.matching:
        final validPairs = <MapEntry<Option, Option>>[];
        for (int i = 0; i < matchingLeftItems.length; i++) {
          if (i >= matchingRightItems.length) continue; // ضمان السلامة
          
          final left = matchingLeftItems[i];
          final right = matchingRightItems[i];
          // ✅ T1: إصلاح خطأ .isNotEmpty
          if (((left.text ?? '').isNotEmpty ||
                  left.imageUrl != null ||
                  left.audioUrl != null) &&
              ((right.text ?? '').isNotEmpty ||
                  right.imageUrl != null ||
                  right.audioUrl != null)) {
            validPairs.add(MapEntry(left, right));
          }
        }
        data['leftItems'] = validPairs.map((pair) => pair.key.toJson()).toList();
        data['rightItems'] =
            validPairs.map((pair) => pair.value.toJson()).toList();
        data['correctPairs'] =
            matchingCorrectPairs.map((k, v) => MapEntry(k.toString(), v));
        break;
      case QuestionType.ordering:
        data['items'] = orderingItems
            // ✅ T1: إصلاح خطأ .isNotEmpty
            .where((o) =>
                (o.text ?? '').isNotEmpty ||
                o.imageUrl != null ||
                o.audioUrl != null)
            .map((o) => o.toJson())
            .toList();
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

  // --- ✅ T1: دوال اختيار مرفقات نص السؤال ---
  void pickImageFromCamera() {
    questionImageUrl.value = 'dummy/camera_image.jpg';
    questionAudioUrl.value = null;
    print('Picking image from camera...');
  }

  void pickImageFromGallery() {
    questionImageUrl.value = 'dummy/gallery_image.png';
    questionAudioUrl.value = null;
    print('Picking image from gallery...');
  }

  void pickAudio() {
    questionAudioUrl.value = 'dummy/selected_audio.mp3';
    questionImageUrl.value = null;
    print('Picking audio...');
  }

  void clearQuestionMedia() {
    questionImageUrl.value = null;
    questionAudioUrl.value = null;
  }

  // --- ✅ T3: دوال اختيار مرفقات *الخيارات* ---
  // TODO: استبدل هذا بمنطق حقيقي لاستدعاء image_picker أو file_picker
  
  void pickImageForOption(RxList<Option> optionsList, int index,
      {bool fromCamera = false}) {
    if (index >= optionsList.length) return;
    String dummyUrl = fromCamera
        ? 'dummy/option_cam_${index}.jpg'
        : 'dummy/option_gal_${index}.png';
    optionsList[index] = optionsList[index].copyWith(
      imageUrl: dummyUrl,
      audioUrl: null, // مسح الآخر
    );
    optionsList.refresh(); // إجبار Obx على التحديث
  }

  void pickAudioForOption(RxList<Option> optionsList, int index) {
    if (index >= optionsList.length) return;
    optionsList[index] = optionsList[index].copyWith(
      audioUrl: 'dummy/option_audio_${index}.mp3',
      imageUrl: null, // مسح الآخر
    );
    optionsList.refresh();
  }

  void clearMediaForOption(RxList<Option> optionsList, int index,
      {bool clearImage = false, bool clearAudio = false}) {
    if (index >= optionsList.length) return;
    optionsList[index] = optionsList[index].copyWith(
      imageUrl: clearImage ? null : optionsList[index].imageUrl,
      audioUrl: clearAudio ? null : optionsList[index].audioUrl,
    );
    optionsList.refresh();
  }


  TextEditingController get questionTextController => _questionTextController;
  TextEditingController get orderController => _orderController;
  TextEditingController get explanationController => _explanationController;
  Rx<QuestionType> get selectedType => _selectedType;
  Map<String, dynamic> get questionData => _questionData;

  @override
  void onClose() {
    _questionTextController.dispose();
    _orderController.dispose();
    _explanationController.dispose();
    for (var controller in fillBlankCorrectAnswers) {
      controller.dispose();
    }
    super.onClose();
  }
}