// models/student.dart
import 'package:flutter/material.dart';

class Student {
  final String id;
  String name;
  String grade;
  String section;
  String code;
  bool isActive;
  bool isRegistered;
  final String imageUrl;
  double overallProgress;
  List<SubjectProgress> subjects;
  String? phone;
  String? email;
  final List<Answer> answers;

  Student({
    required this.id,
    required this.name,
    required this.grade,
    required this.section,
    required this.code,
    required this.isActive,
    this.imageUrl = 'https://via.placeholder.com/150',
    required this.overallProgress,
    required this.subjects,
    this.phone,
    this.isRegistered = true,
    this.email,
    required this.answers,
  });
}

class SubjectProgress {
  final String subjectName;
  final double progress;
  final String status;
  final List<UnitProgress> units;

  SubjectProgress({
    required this.subjectName,
    required this.progress,
    required this.status,
    required this.units,
  });
}

class UnitProgress {
  final String unitName;
  final int completedLessons;
  final int totalLessons;
  final List<Lesson> lessons;

  UnitProgress({
    required this.unitName,
    required this.completedLessons,
    required this.totalLessons,
    required this.lessons,
  });
}

class Lesson {
  final String lessonName;
  final bool isWatched;
  final double progress;

  Lesson({
    required this.lessonName,
    required this.isWatched,
    required this.progress,
  });
}

class Answer {
  final String question;
  final String studentAnswer;
  final String correctAnswer;
  final bool isCorrect;
  final String type; // e.g., 'multiple_choice', 'essay'

  Answer({
    required this.question,
    required this.studentAnswer,
    required this.correctAnswer,
    required this.isCorrect,
    required this.type,
  });
}
