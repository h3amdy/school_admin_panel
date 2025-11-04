// lib/models/user_model/base_user_model.dart

// هذا الـ enum ضروري لأنه مستخدم في الكلاسات الفرعية
enum UserRole {
  admin,
  teacher,
  student,
  unknown, // قيمة افتراضية جيدة
}

// هذه الدالة المساعدة مستخدمة في User.fromMap
UserRole userRoleFromString(String? role) {
  switch (role) {
    case 'admin':
      return UserRole.admin;
    case 'teacher':
      return UserRole.teacher;
    case 'student':
      return UserRole.student;
    default:
      return UserRole.unknown;
  }
}

// الكلاس الأب الذي ترث منه الكلاسات الأخرى
abstract class BaseUser {
  final String id;
  final String username;
  final String? phone;
  final String? fullName;
  final String? password;
  final UserRole? role;
  final bool? isActive;
  final bool? isVerified;
  final String? school;
  final String? city;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? deleted;
  final DateTime? deletedAt;

  BaseUser({
    required this.id,
    required this.username,
    required this.phone,
    this.fullName,
    this.password,
    this.role,
    this.isActive,
    this.isVerified,
    this.school,
    this.city,
    this.createdAt,
    this.updatedAt,
    this.deleted,
    this.deletedAt,
  });

  // دالة toMap الأساسية التي تعتمد عليها الكلاسات الفرعية
  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'username': username,
      'phone': phone,
      'fullName': fullName,
      'password': password,
      // .name يحول الـ enum إلى نص مطابق للدالة المساعدة (مثل: 'admin')
      'role': role?.name, 
      'isActive': isActive,
      'isVerified': isVerified,
      'school': school,
      'city': city,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'deleted': deleted,
      'deletedAt': deletedAt?.toIso8601String(),
    };
  }
}