// lesson_model.dart

import 'package:flutter/material.dart';

// أنواع المحتوى الممكنة
enum ContentType { text, image }

// موديل لعنصر المحتوى (نص أو صورة)
class ContentItem {
  final String id;
  final ContentType type;
  final String content; // النص أو مسار الصورة (Placeholder)

  ContentItem({
    required this.id,
    required this.type,
    required this.content,
  });
}

// موديل لشريحة زمنية في المقطع الصوتي
class AudioSegment {
  final String contentId; // يربط بالشريحة الزمنية
  final Duration startTime;
  final Duration endTime;
  final Color color; // لون الشريحة لتمييزها

  AudioSegment({
    required this.contentId,
    required this.startTime,
    required this.endTime,
    required this.color,
  });
}