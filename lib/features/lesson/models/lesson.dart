import 'dart:convert';

import 'package:ashil_school/features/lesson/models/content_block.dart';
import 'package:flutter/rendering.dart';

class LessonModel {
  final String id;
  final String title;
  final String unitId;
  final int? order;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isSynced;
  final bool deleted;


  final String? profileImageUrl;
  final String? audioUrl;
  final List<ContentBlock> contentBlocks;

  LessonModel({
    required this.id,
    required this.title,
    required this.unitId,
    this.order,
    this.createdAt,
    this.updatedAt,
    this.isSynced = false,
    this.deleted = false,
    this.profileImageUrl,
    this.audioUrl,
    this.contentBlocks = const [],
  });

  factory LessonModel.fromMap(Map<String, dynamic> map) {
    // [تعديل] 4. تحديث fromMap
    List<ContentBlock> blocks = [];
    if (map['content'] != null) {
      try {
        final List<dynamic> decoded = jsonDecode(map['content'] as String);
        blocks = decoded
            .map((item) => ContentBlock.fromMap(item as Map<String, dynamic>))
            .toList();
      } catch (e) {
        // إذا كان المحتوى نصاً قديماً، تجاهله أو قم بتحويله
        // لأغراض التوافقية، سنتركه فارغاً
        blocks = []; 
      }
    }

    return LessonModel(
      id: map['id'] as String,
      title: map['title'] as String,
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
      // [جديد]
      profileImageUrl: map['profileImageUrl'] as String?,
      audioUrl: map['audioUrl'] as String?,
      contentBlocks: blocks,
    );
  }

  Map<String, dynamic> toMap() {
    // [تعديل] 5. تحديث toMap
    return {
      'id': id,
      'title': title,
      'unitId': unitId,
      'order': order,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isSynced': isSynced,
      'deleted': deleted,
      // [جديد]
      'profileImageUrl': profileImageUrl,
      'audioUrl': audioUrl,
      'content': jsonEncode(contentBlocks.map((b) => b.toMap()).toList()),
    };
  }

  LessonModel copyWith({
    String? id,
    String? title,
    String? unitId,
    int? order,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSynced,
    bool? deleted,
    // [تعديل] 6. تحديث copyWith
    ValueGetter<String?>? profileImageUrl,
    ValueGetter<String?>? audioUrl,
    List<ContentBlock>? contentBlocks,
  }) {
    return LessonModel(
      id: id ?? this.id,
      title: title ?? this.title,
      unitId: unitId ?? this.unitId,
      order: order ?? this.order,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
      deleted: deleted ?? this.deleted,
      profileImageUrl: profileImageUrl != null ? profileImageUrl() : this.profileImageUrl,
      audioUrl: audioUrl != null ? audioUrl() : this.audioUrl,
      contentBlocks: contentBlocks ?? this.contentBlocks,
    );
  }
}