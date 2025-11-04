class Option {
  final String? text;
  final String? imageUrl;
  final String? audioUrl;

  Option({this.text, this.imageUrl, this.audioUrl});

  // 💡 دالة copyWith تسمح بإنشاء نسخة جديدة من الكائن مع تغيير خصائص محددة
  Option copyWith({
    String? text,
    String? imageUrl,
    String? audioUrl,
  }) {
    return Option(
      text: text ?? this.text,
      imageUrl: imageUrl ?? this.imageUrl,
      audioUrl: audioUrl ?? this.audioUrl,
    );
  }

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      text: json['text'] as String?,
      imageUrl: json['imageUrl'] as String?,
      audioUrl: json['audioUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'imageUrl': imageUrl,
      'audioUrl': audioUrl,
    };
  }
}