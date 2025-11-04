import 'package:flutter/material.dart';
import 'package:get/get.dart';

// تعريف أنواع المحتوى
enum ContentType { text, image }

// نموذج لعنصر المحتوى المرتبط بالصوت
class ContentItem {
  final String id;
  final ContentType type;
  final String content; // مسار الصورة أو النص
  final Duration startTime; // بداية الفترة الزمنية المرتبطة
  final Duration endTime; // نهاية الفترة الزمنية المرتبطة
  final Color color; // لون مميز لتمييز العنصر في شريط الصوت

  ContentItem({
    required this.id,
    required this.type,
    required this.content,
    required this.startTime,
    required this.endTime,
    required this.color,
  });
}

// نموذج الدرس الأساسي
class Lesson {
  final int lessonNumber;
  final RxString title;
  final RxString details;
  final RxInt order;
  final RxString audioPath; // مسار ملف التسجيل الصوتي
  final RxList<ContentItem> contentItems;

  Lesson({
    required this.lessonNumber,
    String title = 'درس جديد (اضغط تعديل)',
    String details = 'لم يتم إدخال تفاصيل بعد',
    int order = 1,
    String audioPath = '',
    List<ContentItem>? contentItems,
  }) :
    title = title.obs,
    details = details.obs,
    order = order.obs,
    audioPath = audioPath.obs,
    contentItems = (contentItems ?? <ContentItem>[]).obs;
}
