class LessonModel {
  final String id;
  final String title;
  final String content;
  final String unitId;
  final int? order;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isSynced;
  final bool deleted;

  LessonModel({
    required this.id,
    required this.title,
    required this.content,
    required this.unitId,
    this.order,
    this.createdAt,
    this.updatedAt,
    this.isSynced = false,
    this.deleted = false,
  });

  factory LessonModel.fromMap(Map<String, dynamic> map) {
    return LessonModel(
      id: map['id'] as String,
      title: map['title'] as String,
      content: map['content'] as String,
      unitId: map['unitId'] as String,
      order: map['order'] as int?,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
      isSynced: map['isSynced'] as bool? ?? false,
      deleted: map['deleted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'unitId': unitId,
      'order': order,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isSynced': isSynced,
      'deleted': deleted,
    };
  }
}
