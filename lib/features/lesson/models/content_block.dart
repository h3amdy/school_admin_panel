import 'dart:convert';

// 1. تعريف أنواع كتل المحتوى
enum ContentType {
  text,
  image,
}

// 2. موديل كتلة المحتوى
class ContentBlock {
  final String id;
  final ContentType type;
  final String data; // سيحتوي إما على النص أو على مسار/رابط الصورة
  final int order;

  ContentBlock({
    required this.id,
    required this.type,
    required this.data,
    required this.order,
  });

  // دوال التحويل من وإلى Map (JSON)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.name, // حفظ النوع كـ "text" أو "image"
      'data': data,
      'order': order,
    };
  }

  factory ContentBlock.fromMap(Map<String, dynamic> map) {
    return ContentBlock(
      id: map['id'] as String,
      type: (map['type'] as String) == ContentType.image.name
          ? ContentType.image
          : ContentType.text,
      data: map['data'] as String,
      order: map['order'] as int,
    );
  }

  // دوال مساعدة للتحويل من وإلى JSON String
  String toJson() => json.encode(toMap());

  factory ContentBlock.fromJson(String source) =>
      ContentBlock.fromMap(json.decode(source) as Map<String, dynamic>);
}