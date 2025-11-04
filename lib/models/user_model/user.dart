// lib/models/user_model/user.dart

import 'package:ashil_school/models/user_model/base_user_model.dart';

import 'package:ashil_school/data/local/app_database.dart';

class User extends BaseUser {

  final String? specialization;

  final List<String>? assignedSubjects;

  final String? gradeId;

  final String? semesterId;

  final String? parentPhone;

  final bool? isSynced;



  User({

    required super.id,

    required super.username,

     super.phone,

    super.fullName,

    super.password, // ✅ لا تجعلها required

    super.role,

    super.isActive,

    super.isVerified,

    super.school,

    super.city,

    super.createdAt,

    super.updatedAt,

    this.specialization,

    this.assignedSubjects,

    this.gradeId,

    this.semesterId,

    this.parentPhone,

    this.isSynced,

    super.deleted,

    super.deletedAt,

  });



  factory User.fromMap(Map<String, dynamic> map) {

    return User(

      id: map['_id'] ?? '',

      username: map['username'] ?? '',

      phone: map['phone'] ?? '',

      fullName: map['fullName'] ?? '',

      password: map['password'] ?? '',

      role: userRoleFromString(map['role']),

      isActive: map['isActive'] ?? true,

      isVerified: map['isVerified'] ?? false,

      school: map['school'],

      city: map['city'],

      createdAt: map['createdAt'] != null ? DateTime.tryParse(map['createdAt']) : null,

      updatedAt: map['updatedAt'] != null ? DateTime.tryParse(map['updatedAt']) : null,

      specialization: map['specialization'],

      assignedSubjects: map['assignedSubjects'] != null ? List<String>.from(map['assignedSubjects']) : null,

      gradeId: map['gradeId'],

      semesterId: map['semesterId'],

      parentPhone: map['parentPhone'],

      isSynced: map['isSynced'] ?? true,

    );

  }



  factory User.fromLocalTeacher(Teacher teacher) {

    return User(

      id: teacher.id,

      username: teacher.username,

      phone: teacher.phone,

      fullName: teacher.fullName,

      password: teacher.password,

      role: UserRole.teacher,

      specialization: teacher.specialization,

      assignedSubjects: teacher.assignedSubjects,

      isSynced: teacher.isSynced,

      deleted: teacher.deleted,

      deletedAt: teacher.deletedAt,

    );

  }



  @override

  Map<String, dynamic> toMap() {

    final map = super.toMap();

    map.addAll({

      'specialization': specialization,

      'assignedSubjects': assignedSubjects,

      'gradeId': gradeId,

      'semesterId': semesterId,

      'parentPhone': parentPhone,

      'isSynced': isSynced,

    });

    return map;

  }



  // ✅ تصحيح: هذه الخصائص يجب أن تكون داخل الكلاس مباشرة

  bool get isNew => isSynced != true;

  bool get isDeleted => deleted == true;



  String get displayRole {

    switch (role) {

      case UserRole.admin:

        return 'مدير';

      case UserRole.teacher:

        return 'معلم';

      case UserRole.student:

        return 'طالب';

      default:

        return 'غير متوفر';

    }

  }

}