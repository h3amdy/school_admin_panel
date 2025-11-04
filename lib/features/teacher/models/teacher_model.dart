// lib/models/user_model/teacher_user.dart
import 'package:ashil_school/models/user_model/base_user_model.dart';

class TeacherUser extends BaseUser {
  final String specialization;
  final List<String> assignedSubjects;

  TeacherUser({
    required super.id,
    required super.username,
    required super.phone,
    required super.fullName,
    required super.password,
    required super.isActive,
    required super.isVerified,
    required this.specialization,
    required this.assignedSubjects,
    super.school,
    super.city,
    super.createdAt,
    super.updatedAt,
  }) : super(
          role: UserRole.teacher,
        );

  factory TeacherUser.fromMap(Map<String, dynamic> map) {
    return TeacherUser(
      id: map['_id'] ?? '',
      username: map['username'] ?? '',
      phone: map['phone'] ?? '',
      fullName: map['fullName'] ?? '',
      password: map['password'] ?? '',
      isActive: map['isActive'] ?? true,
      isVerified: map['isVerified'] ?? false,
      specialization: map['specialization'] ?? '',
      assignedSubjects: map['assignedSubjects'] != null
          ? List<String>.from(map['assignedSubjects'])
          : [],
      school: map['school'],
      city: map['city'],
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'])
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.tryParse(map['updatedAt'])
          : null,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map.addAll({
      'specialization': specialization,
      'assignedSubjects': assignedSubjects,
    });
    return map;
  }
}