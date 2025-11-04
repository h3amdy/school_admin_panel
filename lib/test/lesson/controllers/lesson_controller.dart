// lesson_controller.dart

import 'package:ashil_school/test/lesson/models/lesson_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LessonController extends GetxController {
  // === بيانات الدرس الأساسية ===
  var isEditing = true.obs; // يبدأ بـ true لبيانات الإضافة
  var lessonTitle = 'مقدمة في الجاذبية'.obs;
  var lessonDetails = 'شرح قوانين نيوتن وتأثيرها على الأجسام'.obs;
  var lessonOrder = 1.obs;

  // === حالة الصوت والمحتوى ===
  var isAudioPlaying = false.obs;
  var isVerticalView = true.obs; // لتبديل عرض المحتوى بين عمودي/أفقي
  var audioDuration = Duration(minutes: 1, seconds: 45).obs; // مدة افتراضية
  var currentTime = Duration.zero.obs;

  // === البيانات الافتراضية (للمحاكاة) ===
  final List<Color> _contentColors = [
    Colors.blue.shade300,
    Colors.green.shade300,
    Colors.orange.shade300,
    Colors.purple.shade300,
    Colors.red.shade300,
  ];

  Color getContentBorderColor(int index) {
    return _contentColors[index % _contentColors.length];
  }

  // قائمة المحتوى الافتراضية
  var contentList = <ContentItem>[
    ContentItem(id: 'c1', type: ContentType.text, content: 'نص يشرح الأساسيات وقانون الجاذبية الأول.'),
    ContentItem(id: 'c2', type: ContentType.image, content: 'assets/image_a.png'),
    ContentItem(id: 'c3', type: ContentType.text, content: 'مفهوم الكتلة والوزن واختلافهما بين الكواكب.'),
    ContentItem(id: 'c4', type: ContentType.image, content: 'assets/image_b.png'),
    ContentItem(id: 'c5', type: ContentType.text, content: 'تجربة التفاحة وسرعة السقوط الحر.'),
  ].obs;

  // قائمة شرائح الصوت الافتراضية المربوطة بالمحتوى
  late final RxList<AudioSegment> audioSegments = <AudioSegment>[
    AudioSegment(contentId: 'c1', startTime: Duration(seconds: 0), endTime: Duration(seconds: 20), color: getContentBorderColor(0)),
    AudioSegment(contentId: 'c2', startTime: Duration(seconds: 21), endTime: Duration(seconds: 40), color: getContentBorderColor(1)),
    AudioSegment(contentId: 'c3', startTime: Duration(seconds: 41), endTime: Duration(seconds: 70), color: getContentBorderColor(2)),
    AudioSegment(contentId: 'c4', startTime: Duration(seconds: 71), endTime: Duration(seconds: 90), color: getContentBorderColor(3)),
    AudioSegment(contentId: 'c5', startTime: Duration(seconds: 91), endTime: Duration(seconds: 105), color: getContentBorderColor(4)),
  ].obs;
  
  // دالة وهمية لإعادة ترتيب المحتوى
  void reorderContent(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final item = contentList.removeAt(oldIndex);
    contentList.insert(newIndex, item);
  }
}