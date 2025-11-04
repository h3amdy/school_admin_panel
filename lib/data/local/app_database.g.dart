// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $TeachersTable extends Teachers with TableInfo<$TeachersTable, Teacher> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TeachersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _usernameMeta =
      const VerificationMeta('username');
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
      'username', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _fullNameMeta =
      const VerificationMeta('fullName');
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
      'fullName', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _passwordMeta =
      const VerificationMeta('password');
  @override
  late final GeneratedColumn<String> password = GeneratedColumn<String>(
      'password', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
      'role', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('teacher'));
  static const VerificationMeta _specializationMeta =
      const VerificationMeta('specialization');
  @override
  late final GeneratedColumn<String> specialization = GeneratedColumn<String>(
      'specialization', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumnWithTypeConverter<List<String>?, String>
      assignedSubjects = GeneratedColumn<String>(
              'assignedSubjects', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<List<String>?>(
              $TeachersTable.$converterassignedSubjectsn);
  static const VerificationMeta _isSyncedMeta =
      const VerificationMeta('isSynced');
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
      'isSynced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("isSynced" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'createdAt', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updatedAt', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _deletedMeta =
      const VerificationMeta('deleted');
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
      'deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deletedAt', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        username,
        phone,
        fullName,
        password,
        role,
        specialization,
        assignedSubjects,
        isSynced,
        createdAt,
        updatedAt,
        deleted,
        deletedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'teachers';
  @override
  VerificationContext validateIntegrity(Insertable<Teacher> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('username')) {
      context.handle(_usernameMeta,
          username.isAcceptableOrUnknown(data['username']!, _usernameMeta));
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('fullName')) {
      context.handle(_fullNameMeta,
          fullName.isAcceptableOrUnknown(data['fullName']!, _fullNameMeta));
    }
    if (data.containsKey('password')) {
      context.handle(_passwordMeta,
          password.isAcceptableOrUnknown(data['password']!, _passwordMeta));
    } else if (isInserting) {
      context.missing(_passwordMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
          _roleMeta, role.isAcceptableOrUnknown(data['role']!, _roleMeta));
    }
    if (data.containsKey('specialization')) {
      context.handle(
          _specializationMeta,
          specialization.isAcceptableOrUnknown(
              data['specialization']!, _specializationMeta));
    }
    if (data.containsKey('isSynced')) {
      context.handle(_isSyncedMeta,
          isSynced.isAcceptableOrUnknown(data['isSynced']!, _isSyncedMeta));
    }
    if (data.containsKey('createdAt')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['createdAt']!, _createdAtMeta));
    }
    if (data.containsKey('updatedAt')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updatedAt']!, _updatedAtMeta));
    }
    if (data.containsKey('deleted')) {
      context.handle(_deletedMeta,
          deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta));
    }
    if (data.containsKey('deletedAt')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deletedAt']!, _deletedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Teacher map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Teacher(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      username: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}username'])!,
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone']),
      fullName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}fullName']),
      password: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}password'])!,
      role: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role'])!,
      specialization: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}specialization']),
      assignedSubjects: $TeachersTable.$converterassignedSubjectsn.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}assignedSubjects'])),
      isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}isSynced'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}createdAt']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updatedAt']),
      deleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}deleted'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deletedAt']),
    );
  }

  @override
  $TeachersTable createAlias(String alias) {
    return $TeachersTable(attachedDatabase, alias);
  }

  static TypeConverter<List<String>, String> $converterassignedSubjects =
      const StringListConverter();
  static TypeConverter<List<String>?, String?> $converterassignedSubjectsn =
      NullAwareTypeConverter.wrap($converterassignedSubjects);
}

class Teacher extends DataClass implements Insertable<Teacher> {
  final String id;
  final String username;
  final String? phone;
  final String? fullName;
  final String password;
  final String role;
  final String? specialization;
  final List<String>? assignedSubjects;
  final bool isSynced;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool deleted;
  final DateTime? deletedAt;
  const Teacher(
      {required this.id,
      required this.username,
      this.phone,
      this.fullName,
      required this.password,
      required this.role,
      this.specialization,
      this.assignedSubjects,
      required this.isSynced,
      this.createdAt,
      this.updatedAt,
      required this.deleted,
      this.deletedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['username'] = Variable<String>(username);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || fullName != null) {
      map['fullName'] = Variable<String>(fullName);
    }
    map['password'] = Variable<String>(password);
    map['role'] = Variable<String>(role);
    if (!nullToAbsent || specialization != null) {
      map['specialization'] = Variable<String>(specialization);
    }
    if (!nullToAbsent || assignedSubjects != null) {
      map['assignedSubjects'] = Variable<String>(
          $TeachersTable.$converterassignedSubjectsn.toSql(assignedSubjects));
    }
    map['isSynced'] = Variable<bool>(isSynced);
    if (!nullToAbsent || createdAt != null) {
      map['createdAt'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updatedAt'] = Variable<DateTime>(updatedAt);
    }
    map['deleted'] = Variable<bool>(deleted);
    if (!nullToAbsent || deletedAt != null) {
      map['deletedAt'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  TeachersCompanion toCompanion(bool nullToAbsent) {
    return TeachersCompanion(
      id: Value(id),
      username: Value(username),
      phone:
          phone == null && nullToAbsent ? const Value.absent() : Value(phone),
      fullName: fullName == null && nullToAbsent
          ? const Value.absent()
          : Value(fullName),
      password: Value(password),
      role: Value(role),
      specialization: specialization == null && nullToAbsent
          ? const Value.absent()
          : Value(specialization),
      assignedSubjects: assignedSubjects == null && nullToAbsent
          ? const Value.absent()
          : Value(assignedSubjects),
      isSynced: Value(isSynced),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      deleted: Value(deleted),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory Teacher.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Teacher(
      id: serializer.fromJson<String>(json['id']),
      username: serializer.fromJson<String>(json['username']),
      phone: serializer.fromJson<String?>(json['phone']),
      fullName: serializer.fromJson<String?>(json['fullName']),
      password: serializer.fromJson<String>(json['password']),
      role: serializer.fromJson<String>(json['role']),
      specialization: serializer.fromJson<String?>(json['specialization']),
      assignedSubjects:
          serializer.fromJson<List<String>?>(json['assignedSubjects']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'username': serializer.toJson<String>(username),
      'phone': serializer.toJson<String?>(phone),
      'fullName': serializer.toJson<String?>(fullName),
      'password': serializer.toJson<String>(password),
      'role': serializer.toJson<String>(role),
      'specialization': serializer.toJson<String?>(specialization),
      'assignedSubjects': serializer.toJson<List<String>?>(assignedSubjects),
      'isSynced': serializer.toJson<bool>(isSynced),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'deleted': serializer.toJson<bool>(deleted),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  Teacher copyWith(
          {String? id,
          String? username,
          Value<String?> phone = const Value.absent(),
          Value<String?> fullName = const Value.absent(),
          String? password,
          String? role,
          Value<String?> specialization = const Value.absent(),
          Value<List<String>?> assignedSubjects = const Value.absent(),
          bool? isSynced,
          Value<DateTime?> createdAt = const Value.absent(),
          Value<DateTime?> updatedAt = const Value.absent(),
          bool? deleted,
          Value<DateTime?> deletedAt = const Value.absent()}) =>
      Teacher(
        id: id ?? this.id,
        username: username ?? this.username,
        phone: phone.present ? phone.value : this.phone,
        fullName: fullName.present ? fullName.value : this.fullName,
        password: password ?? this.password,
        role: role ?? this.role,
        specialization:
            specialization.present ? specialization.value : this.specialization,
        assignedSubjects: assignedSubjects.present
            ? assignedSubjects.value
            : this.assignedSubjects,
        isSynced: isSynced ?? this.isSynced,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
        deleted: deleted ?? this.deleted,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
      );
  Teacher copyWithCompanion(TeachersCompanion data) {
    return Teacher(
      id: data.id.present ? data.id.value : this.id,
      username: data.username.present ? data.username.value : this.username,
      phone: data.phone.present ? data.phone.value : this.phone,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      password: data.password.present ? data.password.value : this.password,
      role: data.role.present ? data.role.value : this.role,
      specialization: data.specialization.present
          ? data.specialization.value
          : this.specialization,
      assignedSubjects: data.assignedSubjects.present
          ? data.assignedSubjects.value
          : this.assignedSubjects,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Teacher(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('phone: $phone, ')
          ..write('fullName: $fullName, ')
          ..write('password: $password, ')
          ..write('role: $role, ')
          ..write('specialization: $specialization, ')
          ..write('assignedSubjects: $assignedSubjects, ')
          ..write('isSynced: $isSynced, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      username,
      phone,
      fullName,
      password,
      role,
      specialization,
      assignedSubjects,
      isSynced,
      createdAt,
      updatedAt,
      deleted,
      deletedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Teacher &&
          other.id == this.id &&
          other.username == this.username &&
          other.phone == this.phone &&
          other.fullName == this.fullName &&
          other.password == this.password &&
          other.role == this.role &&
          other.specialization == this.specialization &&
          other.assignedSubjects == this.assignedSubjects &&
          other.isSynced == this.isSynced &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deleted == this.deleted &&
          other.deletedAt == this.deletedAt);
}

class TeachersCompanion extends UpdateCompanion<Teacher> {
  final Value<String> id;
  final Value<String> username;
  final Value<String?> phone;
  final Value<String?> fullName;
  final Value<String> password;
  final Value<String> role;
  final Value<String?> specialization;
  final Value<List<String>?> assignedSubjects;
  final Value<bool> isSynced;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<bool> deleted;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const TeachersCompanion({
    this.id = const Value.absent(),
    this.username = const Value.absent(),
    this.phone = const Value.absent(),
    this.fullName = const Value.absent(),
    this.password = const Value.absent(),
    this.role = const Value.absent(),
    this.specialization = const Value.absent(),
    this.assignedSubjects = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TeachersCompanion.insert({
    required String id,
    required String username,
    this.phone = const Value.absent(),
    this.fullName = const Value.absent(),
    required String password,
    this.role = const Value.absent(),
    this.specialization = const Value.absent(),
    this.assignedSubjects = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        username = Value(username),
        password = Value(password);
  static Insertable<Teacher> custom({
    Expression<String>? id,
    Expression<String>? username,
    Expression<String>? phone,
    Expression<String>? fullName,
    Expression<String>? password,
    Expression<String>? role,
    Expression<String>? specialization,
    Expression<String>? assignedSubjects,
    Expression<bool>? isSynced,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? deleted,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (username != null) 'username': username,
      if (phone != null) 'phone': phone,
      if (fullName != null) 'fullName': fullName,
      if (password != null) 'password': password,
      if (role != null) 'role': role,
      if (specialization != null) 'specialization': specialization,
      if (assignedSubjects != null) 'assignedSubjects': assignedSubjects,
      if (isSynced != null) 'isSynced': isSynced,
      if (createdAt != null) 'createdAt': createdAt,
      if (updatedAt != null) 'updatedAt': updatedAt,
      if (deleted != null) 'deleted': deleted,
      if (deletedAt != null) 'deletedAt': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TeachersCompanion copyWith(
      {Value<String>? id,
      Value<String>? username,
      Value<String?>? phone,
      Value<String?>? fullName,
      Value<String>? password,
      Value<String>? role,
      Value<String?>? specialization,
      Value<List<String>?>? assignedSubjects,
      Value<bool>? isSynced,
      Value<DateTime?>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<bool>? deleted,
      Value<DateTime?>? deletedAt,
      Value<int>? rowid}) {
    return TeachersCompanion(
      id: id ?? this.id,
      username: username ?? this.username,
      phone: phone ?? this.phone,
      fullName: fullName ?? this.fullName,
      password: password ?? this.password,
      role: role ?? this.role,
      specialization: specialization ?? this.specialization,
      assignedSubjects: assignedSubjects ?? this.assignedSubjects,
      isSynced: isSynced ?? this.isSynced,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (fullName.present) {
      map['fullName'] = Variable<String>(fullName.value);
    }
    if (password.present) {
      map['password'] = Variable<String>(password.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (specialization.present) {
      map['specialization'] = Variable<String>(specialization.value);
    }
    if (assignedSubjects.present) {
      map['assignedSubjects'] = Variable<String>($TeachersTable
          .$converterassignedSubjectsn
          .toSql(assignedSubjects.value));
    }
    if (isSynced.present) {
      map['isSynced'] = Variable<bool>(isSynced.value);
    }
    if (createdAt.present) {
      map['createdAt'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updatedAt'] = Variable<DateTime>(updatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (deletedAt.present) {
      map['deletedAt'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TeachersCompanion(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('phone: $phone, ')
          ..write('fullName: $fullName, ')
          ..write('password: $password, ')
          ..write('role: $role, ')
          ..write('specialization: $specialization, ')
          ..write('assignedSubjects: $assignedSubjects, ')
          ..write('isSynced: $isSynced, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncLogsTable extends SyncLogs with TableInfo<$SyncLogsTable, SyncLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _entityMeta = const VerificationMeta('entity');
  @override
  late final GeneratedColumn<String> entity = GeneratedColumn<String>(
      'entity', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _parentIdMeta =
      const VerificationMeta('parentId');
  @override
  late final GeneratedColumn<String> parentId = GeneratedColumn<String>(
      'parent_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _lastSyncAtMeta =
      const VerificationMeta('lastSyncAt');
  @override
  late final GeneratedColumn<DateTime> lastSyncAt = GeneratedColumn<DateTime>(
      'last_sync_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, entity, parentId, lastSyncAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_logs';
  @override
  VerificationContext validateIntegrity(Insertable<SyncLog> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('entity')) {
      context.handle(_entityMeta,
          entity.isAcceptableOrUnknown(data['entity']!, _entityMeta));
    } else if (isInserting) {
      context.missing(_entityMeta);
    }
    if (data.containsKey('parent_id')) {
      context.handle(_parentIdMeta,
          parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta));
    }
    if (data.containsKey('last_sync_at')) {
      context.handle(
          _lastSyncAtMeta,
          lastSyncAt.isAcceptableOrUnknown(
              data['last_sync_at']!, _lastSyncAtMeta));
    } else if (isInserting) {
      context.missing(_lastSyncAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncLog(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      entity: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity'])!,
      parentId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}parent_id']),
      lastSyncAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_sync_at'])!,
    );
  }

  @override
  $SyncLogsTable createAlias(String alias) {
    return $SyncLogsTable(attachedDatabase, alias);
  }
}

class SyncLog extends DataClass implements Insertable<SyncLog> {
  final int id;
  final String entity;
  final String? parentId;
  final DateTime lastSyncAt;
  const SyncLog(
      {required this.id,
      required this.entity,
      this.parentId,
      required this.lastSyncAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['entity'] = Variable<String>(entity);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<String>(parentId);
    }
    map['last_sync_at'] = Variable<DateTime>(lastSyncAt);
    return map;
  }

  SyncLogsCompanion toCompanion(bool nullToAbsent) {
    return SyncLogsCompanion(
      id: Value(id),
      entity: Value(entity),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      lastSyncAt: Value(lastSyncAt),
    );
  }

  factory SyncLog.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncLog(
      id: serializer.fromJson<int>(json['id']),
      entity: serializer.fromJson<String>(json['entity']),
      parentId: serializer.fromJson<String?>(json['parentId']),
      lastSyncAt: serializer.fromJson<DateTime>(json['lastSyncAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'entity': serializer.toJson<String>(entity),
      'parentId': serializer.toJson<String?>(parentId),
      'lastSyncAt': serializer.toJson<DateTime>(lastSyncAt),
    };
  }

  SyncLog copyWith(
          {int? id,
          String? entity,
          Value<String?> parentId = const Value.absent(),
          DateTime? lastSyncAt}) =>
      SyncLog(
        id: id ?? this.id,
        entity: entity ?? this.entity,
        parentId: parentId.present ? parentId.value : this.parentId,
        lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      );
  SyncLog copyWithCompanion(SyncLogsCompanion data) {
    return SyncLog(
      id: data.id.present ? data.id.value : this.id,
      entity: data.entity.present ? data.entity.value : this.entity,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      lastSyncAt:
          data.lastSyncAt.present ? data.lastSyncAt.value : this.lastSyncAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncLog(')
          ..write('id: $id, ')
          ..write('entity: $entity, ')
          ..write('parentId: $parentId, ')
          ..write('lastSyncAt: $lastSyncAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, entity, parentId, lastSyncAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncLog &&
          other.id == this.id &&
          other.entity == this.entity &&
          other.parentId == this.parentId &&
          other.lastSyncAt == this.lastSyncAt);
}

class SyncLogsCompanion extends UpdateCompanion<SyncLog> {
  final Value<int> id;
  final Value<String> entity;
  final Value<String?> parentId;
  final Value<DateTime> lastSyncAt;
  const SyncLogsCompanion({
    this.id = const Value.absent(),
    this.entity = const Value.absent(),
    this.parentId = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
  });
  SyncLogsCompanion.insert({
    this.id = const Value.absent(),
    required String entity,
    this.parentId = const Value.absent(),
    required DateTime lastSyncAt,
  })  : entity = Value(entity),
        lastSyncAt = Value(lastSyncAt);
  static Insertable<SyncLog> custom({
    Expression<int>? id,
    Expression<String>? entity,
    Expression<String>? parentId,
    Expression<DateTime>? lastSyncAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entity != null) 'entity': entity,
      if (parentId != null) 'parent_id': parentId,
      if (lastSyncAt != null) 'last_sync_at': lastSyncAt,
    });
  }

  SyncLogsCompanion copyWith(
      {Value<int>? id,
      Value<String>? entity,
      Value<String?>? parentId,
      Value<DateTime>? lastSyncAt}) {
    return SyncLogsCompanion(
      id: id ?? this.id,
      entity: entity ?? this.entity,
      parentId: parentId ?? this.parentId,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (entity.present) {
      map['entity'] = Variable<String>(entity.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<String>(parentId.value);
    }
    if (lastSyncAt.present) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncLogsCompanion(')
          ..write('id: $id, ')
          ..write('entity: $entity, ')
          ..write('parentId: $parentId, ')
          ..write('lastSyncAt: $lastSyncAt')
          ..write(')'))
        .toString();
  }
}

class $GradesTable extends Grades with TableInfo<$GradesTable, Grade> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GradesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _orderMeta = const VerificationMeta('order');
  @override
  late final GeneratedColumn<int> order = GeneratedColumn<int>(
      'order', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _isSyncedMeta =
      const VerificationMeta('isSynced');
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
      'is_synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _deletedMeta =
      const VerificationMeta('deleted');
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
      'deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, order, description, createdAt, updatedAt, isSynced, deleted];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'grades';
  @override
  VerificationContext validateIntegrity(Insertable<Grade> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('order')) {
      context.handle(
          _orderMeta, order.isAcceptableOrUnknown(data['order']!, _orderMeta));
    } else if (isInserting) {
      context.missing(_orderMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('is_synced')) {
      context.handle(_isSyncedMeta,
          isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta));
    }
    if (data.containsKey('deleted')) {
      context.handle(_deletedMeta,
          deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Grade map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Grade(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      order: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}order'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
      isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_synced'])!,
      deleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}deleted'])!,
    );
  }

  @override
  $GradesTable createAlias(String alias) {
    return $GradesTable(attachedDatabase, alias);
  }
}

class Grade extends DataClass implements Insertable<Grade> {
  final String id;
  final String name;
  final int order;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isSynced;
  final bool deleted;
  const Grade(
      {required this.id,
      required this.name,
      required this.order,
      this.description,
      this.createdAt,
      this.updatedAt,
      required this.isSynced,
      required this.deleted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['order'] = Variable<int>(order);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    map['is_synced'] = Variable<bool>(isSynced);
    map['deleted'] = Variable<bool>(deleted);
    return map;
  }

  GradesCompanion toCompanion(bool nullToAbsent) {
    return GradesCompanion(
      id: Value(id),
      name: Value(name),
      order: Value(order),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      isSynced: Value(isSynced),
      deleted: Value(deleted),
    );
  }

  factory Grade.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Grade(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      order: serializer.fromJson<int>(json['order']),
      description: serializer.fromJson<String?>(json['description']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      deleted: serializer.fromJson<bool>(json['deleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'order': serializer.toJson<int>(order),
      'description': serializer.toJson<String?>(description),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'isSynced': serializer.toJson<bool>(isSynced),
      'deleted': serializer.toJson<bool>(deleted),
    };
  }

  Grade copyWith(
          {String? id,
          String? name,
          int? order,
          Value<String?> description = const Value.absent(),
          Value<DateTime?> createdAt = const Value.absent(),
          Value<DateTime?> updatedAt = const Value.absent(),
          bool? isSynced,
          bool? deleted}) =>
      Grade(
        id: id ?? this.id,
        name: name ?? this.name,
        order: order ?? this.order,
        description: description.present ? description.value : this.description,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
        isSynced: isSynced ?? this.isSynced,
        deleted: deleted ?? this.deleted,
      );
  Grade copyWithCompanion(GradesCompanion data) {
    return Grade(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      order: data.order.present ? data.order.value : this.order,
      description:
          data.description.present ? data.description.value : this.description,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Grade(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('order: $order, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('deleted: $deleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, name, order, description, createdAt, updatedAt, isSynced, deleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Grade &&
          other.id == this.id &&
          other.name == this.name &&
          other.order == this.order &&
          other.description == this.description &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isSynced == this.isSynced &&
          other.deleted == this.deleted);
}

class GradesCompanion extends UpdateCompanion<Grade> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> order;
  final Value<String?> description;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<bool> isSynced;
  final Value<bool> deleted;
  final Value<int> rowid;
  const GradesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.order = const Value.absent(),
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GradesCompanion.insert({
    required String id,
    required String name,
    required int order,
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        order = Value(order);
  static Insertable<Grade> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? order,
    Expression<String>? description,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isSynced,
    Expression<bool>? deleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (order != null) 'order': order,
      if (description != null) 'description': description,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (deleted != null) 'deleted': deleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GradesCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<int>? order,
      Value<String?>? description,
      Value<DateTime?>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<bool>? isSynced,
      Value<bool>? deleted,
      Value<int>? rowid}) {
    return GradesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      order: order ?? this.order,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
      deleted: deleted ?? this.deleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (order.present) {
      map['order'] = Variable<int>(order.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GradesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('order: $order, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('deleted: $deleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SemestersTable extends Semesters
    with TableInfo<$SemestersTable, Semester> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SemestersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _orderMeta = const VerificationMeta('order');
  @override
  late final GeneratedColumn<int> order = GeneratedColumn<int>(
      'order', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _gradeIdMeta =
      const VerificationMeta('gradeId');
  @override
  late final GeneratedColumn<String> gradeId = GeneratedColumn<String>(
      'grade_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES grades (id)'));
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _isSyncedMeta =
      const VerificationMeta('isSynced');
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
      'is_synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _deletedMeta =
      const VerificationMeta('deleted');
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
      'deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        order,
        gradeId,
        description,
        createdAt,
        updatedAt,
        isSynced,
        deleted
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'semesters';
  @override
  VerificationContext validateIntegrity(Insertable<Semester> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('order')) {
      context.handle(
          _orderMeta, order.isAcceptableOrUnknown(data['order']!, _orderMeta));
    } else if (isInserting) {
      context.missing(_orderMeta);
    }
    if (data.containsKey('grade_id')) {
      context.handle(_gradeIdMeta,
          gradeId.isAcceptableOrUnknown(data['grade_id']!, _gradeIdMeta));
    } else if (isInserting) {
      context.missing(_gradeIdMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('is_synced')) {
      context.handle(_isSyncedMeta,
          isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta));
    }
    if (data.containsKey('deleted')) {
      context.handle(_deletedMeta,
          deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Semester map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Semester(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      order: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}order'])!,
      gradeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}grade_id'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
      isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_synced'])!,
      deleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}deleted'])!,
    );
  }

  @override
  $SemestersTable createAlias(String alias) {
    return $SemestersTable(attachedDatabase, alias);
  }
}

class Semester extends DataClass implements Insertable<Semester> {
  final String id;
  final String name;
  final int order;
  final String gradeId;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isSynced;
  final bool deleted;
  const Semester(
      {required this.id,
      required this.name,
      required this.order,
      required this.gradeId,
      this.description,
      this.createdAt,
      this.updatedAt,
      required this.isSynced,
      required this.deleted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['order'] = Variable<int>(order);
    map['grade_id'] = Variable<String>(gradeId);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    map['is_synced'] = Variable<bool>(isSynced);
    map['deleted'] = Variable<bool>(deleted);
    return map;
  }

  SemestersCompanion toCompanion(bool nullToAbsent) {
    return SemestersCompanion(
      id: Value(id),
      name: Value(name),
      order: Value(order),
      gradeId: Value(gradeId),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      isSynced: Value(isSynced),
      deleted: Value(deleted),
    );
  }

  factory Semester.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Semester(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      order: serializer.fromJson<int>(json['order']),
      gradeId: serializer.fromJson<String>(json['gradeId']),
      description: serializer.fromJson<String?>(json['description']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      deleted: serializer.fromJson<bool>(json['deleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'order': serializer.toJson<int>(order),
      'gradeId': serializer.toJson<String>(gradeId),
      'description': serializer.toJson<String?>(description),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'isSynced': serializer.toJson<bool>(isSynced),
      'deleted': serializer.toJson<bool>(deleted),
    };
  }

  Semester copyWith(
          {String? id,
          String? name,
          int? order,
          String? gradeId,
          Value<String?> description = const Value.absent(),
          Value<DateTime?> createdAt = const Value.absent(),
          Value<DateTime?> updatedAt = const Value.absent(),
          bool? isSynced,
          bool? deleted}) =>
      Semester(
        id: id ?? this.id,
        name: name ?? this.name,
        order: order ?? this.order,
        gradeId: gradeId ?? this.gradeId,
        description: description.present ? description.value : this.description,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
        isSynced: isSynced ?? this.isSynced,
        deleted: deleted ?? this.deleted,
      );
  Semester copyWithCompanion(SemestersCompanion data) {
    return Semester(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      order: data.order.present ? data.order.value : this.order,
      gradeId: data.gradeId.present ? data.gradeId.value : this.gradeId,
      description:
          data.description.present ? data.description.value : this.description,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Semester(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('order: $order, ')
          ..write('gradeId: $gradeId, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('deleted: $deleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, order, gradeId, description,
      createdAt, updatedAt, isSynced, deleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Semester &&
          other.id == this.id &&
          other.name == this.name &&
          other.order == this.order &&
          other.gradeId == this.gradeId &&
          other.description == this.description &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isSynced == this.isSynced &&
          other.deleted == this.deleted);
}

class SemestersCompanion extends UpdateCompanion<Semester> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> order;
  final Value<String> gradeId;
  final Value<String?> description;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<bool> isSynced;
  final Value<bool> deleted;
  final Value<int> rowid;
  const SemestersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.order = const Value.absent(),
    this.gradeId = const Value.absent(),
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SemestersCompanion.insert({
    required String id,
    required String name,
    required int order,
    required String gradeId,
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        order = Value(order),
        gradeId = Value(gradeId);
  static Insertable<Semester> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? order,
    Expression<String>? gradeId,
    Expression<String>? description,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isSynced,
    Expression<bool>? deleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (order != null) 'order': order,
      if (gradeId != null) 'grade_id': gradeId,
      if (description != null) 'description': description,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (deleted != null) 'deleted': deleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SemestersCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<int>? order,
      Value<String>? gradeId,
      Value<String?>? description,
      Value<DateTime?>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<bool>? isSynced,
      Value<bool>? deleted,
      Value<int>? rowid}) {
    return SemestersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      order: order ?? this.order,
      gradeId: gradeId ?? this.gradeId,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
      deleted: deleted ?? this.deleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (order.present) {
      map['order'] = Variable<int>(order.value);
    }
    if (gradeId.present) {
      map['grade_id'] = Variable<String>(gradeId.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SemestersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('order: $order, ')
          ..write('gradeId: $gradeId, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('deleted: $deleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SubjectsTable extends Subjects with TableInfo<$SubjectsTable, Subject> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubjectsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _orderMeta = const VerificationMeta('order');
  @override
  late final GeneratedColumn<int> order = GeneratedColumn<int>(
      'order', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _semesterIdMeta =
      const VerificationMeta('semesterId');
  @override
  late final GeneratedColumn<String> semesterId = GeneratedColumn<String>(
      'semester_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES semesters (id)'));
  static const VerificationMeta _gradeIdMeta =
      const VerificationMeta('gradeId');
  @override
  late final GeneratedColumn<String> gradeId = GeneratedColumn<String>(
      'grade_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES grades (id)'));
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _isSyncedMeta =
      const VerificationMeta('isSynced');
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
      'is_synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _deletedMeta =
      const VerificationMeta('deleted');
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
      'deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        order,
        semesterId,
        gradeId,
        description,
        createdAt,
        updatedAt,
        isSynced,
        deleted
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'subjects';
  @override
  VerificationContext validateIntegrity(Insertable<Subject> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('order')) {
      context.handle(
          _orderMeta, order.isAcceptableOrUnknown(data['order']!, _orderMeta));
    }
    if (data.containsKey('semester_id')) {
      context.handle(
          _semesterIdMeta,
          semesterId.isAcceptableOrUnknown(
              data['semester_id']!, _semesterIdMeta));
    } else if (isInserting) {
      context.missing(_semesterIdMeta);
    }
    if (data.containsKey('grade_id')) {
      context.handle(_gradeIdMeta,
          gradeId.isAcceptableOrUnknown(data['grade_id']!, _gradeIdMeta));
    } else if (isInserting) {
      context.missing(_gradeIdMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('is_synced')) {
      context.handle(_isSyncedMeta,
          isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta));
    }
    if (data.containsKey('deleted')) {
      context.handle(_deletedMeta,
          deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Subject map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Subject(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      order: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}order']),
      semesterId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}semester_id'])!,
      gradeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}grade_id'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
      isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_synced'])!,
      deleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}deleted'])!,
    );
  }

  @override
  $SubjectsTable createAlias(String alias) {
    return $SubjectsTable(attachedDatabase, alias);
  }
}

class Subject extends DataClass implements Insertable<Subject> {
  final String id;
  final String name;
  final int? order;
  final String semesterId;
  final String gradeId;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isSynced;
  final bool deleted;
  const Subject(
      {required this.id,
      required this.name,
      this.order,
      required this.semesterId,
      required this.gradeId,
      this.description,
      this.createdAt,
      this.updatedAt,
      required this.isSynced,
      required this.deleted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || order != null) {
      map['order'] = Variable<int>(order);
    }
    map['semester_id'] = Variable<String>(semesterId);
    map['grade_id'] = Variable<String>(gradeId);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    map['is_synced'] = Variable<bool>(isSynced);
    map['deleted'] = Variable<bool>(deleted);
    return map;
  }

  SubjectsCompanion toCompanion(bool nullToAbsent) {
    return SubjectsCompanion(
      id: Value(id),
      name: Value(name),
      order:
          order == null && nullToAbsent ? const Value.absent() : Value(order),
      semesterId: Value(semesterId),
      gradeId: Value(gradeId),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      isSynced: Value(isSynced),
      deleted: Value(deleted),
    );
  }

  factory Subject.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Subject(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      order: serializer.fromJson<int?>(json['order']),
      semesterId: serializer.fromJson<String>(json['semesterId']),
      gradeId: serializer.fromJson<String>(json['gradeId']),
      description: serializer.fromJson<String?>(json['description']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      deleted: serializer.fromJson<bool>(json['deleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'order': serializer.toJson<int?>(order),
      'semesterId': serializer.toJson<String>(semesterId),
      'gradeId': serializer.toJson<String>(gradeId),
      'description': serializer.toJson<String?>(description),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'isSynced': serializer.toJson<bool>(isSynced),
      'deleted': serializer.toJson<bool>(deleted),
    };
  }

  Subject copyWith(
          {String? id,
          String? name,
          Value<int?> order = const Value.absent(),
          String? semesterId,
          String? gradeId,
          Value<String?> description = const Value.absent(),
          Value<DateTime?> createdAt = const Value.absent(),
          Value<DateTime?> updatedAt = const Value.absent(),
          bool? isSynced,
          bool? deleted}) =>
      Subject(
        id: id ?? this.id,
        name: name ?? this.name,
        order: order.present ? order.value : this.order,
        semesterId: semesterId ?? this.semesterId,
        gradeId: gradeId ?? this.gradeId,
        description: description.present ? description.value : this.description,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
        isSynced: isSynced ?? this.isSynced,
        deleted: deleted ?? this.deleted,
      );
  Subject copyWithCompanion(SubjectsCompanion data) {
    return Subject(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      order: data.order.present ? data.order.value : this.order,
      semesterId:
          data.semesterId.present ? data.semesterId.value : this.semesterId,
      gradeId: data.gradeId.present ? data.gradeId.value : this.gradeId,
      description:
          data.description.present ? data.description.value : this.description,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Subject(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('order: $order, ')
          ..write('semesterId: $semesterId, ')
          ..write('gradeId: $gradeId, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('deleted: $deleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, order, semesterId, gradeId,
      description, createdAt, updatedAt, isSynced, deleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Subject &&
          other.id == this.id &&
          other.name == this.name &&
          other.order == this.order &&
          other.semesterId == this.semesterId &&
          other.gradeId == this.gradeId &&
          other.description == this.description &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isSynced == this.isSynced &&
          other.deleted == this.deleted);
}

class SubjectsCompanion extends UpdateCompanion<Subject> {
  final Value<String> id;
  final Value<String> name;
  final Value<int?> order;
  final Value<String> semesterId;
  final Value<String> gradeId;
  final Value<String?> description;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<bool> isSynced;
  final Value<bool> deleted;
  final Value<int> rowid;
  const SubjectsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.order = const Value.absent(),
    this.semesterId = const Value.absent(),
    this.gradeId = const Value.absent(),
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SubjectsCompanion.insert({
    required String id,
    required String name,
    this.order = const Value.absent(),
    required String semesterId,
    required String gradeId,
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        semesterId = Value(semesterId),
        gradeId = Value(gradeId);
  static Insertable<Subject> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? order,
    Expression<String>? semesterId,
    Expression<String>? gradeId,
    Expression<String>? description,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isSynced,
    Expression<bool>? deleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (order != null) 'order': order,
      if (semesterId != null) 'semester_id': semesterId,
      if (gradeId != null) 'grade_id': gradeId,
      if (description != null) 'description': description,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (deleted != null) 'deleted': deleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SubjectsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<int?>? order,
      Value<String>? semesterId,
      Value<String>? gradeId,
      Value<String?>? description,
      Value<DateTime?>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<bool>? isSynced,
      Value<bool>? deleted,
      Value<int>? rowid}) {
    return SubjectsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      order: order ?? this.order,
      semesterId: semesterId ?? this.semesterId,
      gradeId: gradeId ?? this.gradeId,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
      deleted: deleted ?? this.deleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (order.present) {
      map['order'] = Variable<int>(order.value);
    }
    if (semesterId.present) {
      map['semester_id'] = Variable<String>(semesterId.value);
    }
    if (gradeId.present) {
      map['grade_id'] = Variable<String>(gradeId.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubjectsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('order: $order, ')
          ..write('semesterId: $semesterId, ')
          ..write('gradeId: $gradeId, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('deleted: $deleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UnitsTable extends Units with TableInfo<$UnitsTable, Unit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UnitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _orderMeta = const VerificationMeta('order');
  @override
  late final GeneratedColumn<int> order = GeneratedColumn<int>(
      'order', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _subjectIdMeta =
      const VerificationMeta('subjectId');
  @override
  late final GeneratedColumn<String> subjectId = GeneratedColumn<String>(
      'subject_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES subjects (id)'));
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _isSyncedMeta =
      const VerificationMeta('isSynced');
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
      'is_synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _deletedMeta =
      const VerificationMeta('deleted');
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
      'deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        order,
        subjectId,
        description,
        createdAt,
        updatedAt,
        isSynced,
        deleted
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'units';
  @override
  VerificationContext validateIntegrity(Insertable<Unit> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('order')) {
      context.handle(
          _orderMeta, order.isAcceptableOrUnknown(data['order']!, _orderMeta));
    }
    if (data.containsKey('subject_id')) {
      context.handle(_subjectIdMeta,
          subjectId.isAcceptableOrUnknown(data['subject_id']!, _subjectIdMeta));
    } else if (isInserting) {
      context.missing(_subjectIdMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('is_synced')) {
      context.handle(_isSyncedMeta,
          isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta));
    }
    if (data.containsKey('deleted')) {
      context.handle(_deletedMeta,
          deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Unit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Unit(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      order: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}order']),
      subjectId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}subject_id'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
      isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_synced'])!,
      deleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}deleted'])!,
    );
  }

  @override
  $UnitsTable createAlias(String alias) {
    return $UnitsTable(attachedDatabase, alias);
  }
}

class Unit extends DataClass implements Insertable<Unit> {
  final String id;
  final String name;
  final int? order;
  final String subjectId;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isSynced;
  final bool deleted;
  const Unit(
      {required this.id,
      required this.name,
      this.order,
      required this.subjectId,
      this.description,
      this.createdAt,
      this.updatedAt,
      required this.isSynced,
      required this.deleted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || order != null) {
      map['order'] = Variable<int>(order);
    }
    map['subject_id'] = Variable<String>(subjectId);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    map['is_synced'] = Variable<bool>(isSynced);
    map['deleted'] = Variable<bool>(deleted);
    return map;
  }

  UnitsCompanion toCompanion(bool nullToAbsent) {
    return UnitsCompanion(
      id: Value(id),
      name: Value(name),
      order:
          order == null && nullToAbsent ? const Value.absent() : Value(order),
      subjectId: Value(subjectId),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      isSynced: Value(isSynced),
      deleted: Value(deleted),
    );
  }

  factory Unit.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Unit(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      order: serializer.fromJson<int?>(json['order']),
      subjectId: serializer.fromJson<String>(json['subjectId']),
      description: serializer.fromJson<String?>(json['description']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      deleted: serializer.fromJson<bool>(json['deleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'order': serializer.toJson<int?>(order),
      'subjectId': serializer.toJson<String>(subjectId),
      'description': serializer.toJson<String?>(description),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'isSynced': serializer.toJson<bool>(isSynced),
      'deleted': serializer.toJson<bool>(deleted),
    };
  }

  Unit copyWith(
          {String? id,
          String? name,
          Value<int?> order = const Value.absent(),
          String? subjectId,
          Value<String?> description = const Value.absent(),
          Value<DateTime?> createdAt = const Value.absent(),
          Value<DateTime?> updatedAt = const Value.absent(),
          bool? isSynced,
          bool? deleted}) =>
      Unit(
        id: id ?? this.id,
        name: name ?? this.name,
        order: order.present ? order.value : this.order,
        subjectId: subjectId ?? this.subjectId,
        description: description.present ? description.value : this.description,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
        isSynced: isSynced ?? this.isSynced,
        deleted: deleted ?? this.deleted,
      );
  Unit copyWithCompanion(UnitsCompanion data) {
    return Unit(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      order: data.order.present ? data.order.value : this.order,
      subjectId: data.subjectId.present ? data.subjectId.value : this.subjectId,
      description:
          data.description.present ? data.description.value : this.description,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Unit(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('order: $order, ')
          ..write('subjectId: $subjectId, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('deleted: $deleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, order, subjectId, description,
      createdAt, updatedAt, isSynced, deleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Unit &&
          other.id == this.id &&
          other.name == this.name &&
          other.order == this.order &&
          other.subjectId == this.subjectId &&
          other.description == this.description &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isSynced == this.isSynced &&
          other.deleted == this.deleted);
}

class UnitsCompanion extends UpdateCompanion<Unit> {
  final Value<String> id;
  final Value<String> name;
  final Value<int?> order;
  final Value<String> subjectId;
  final Value<String?> description;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<bool> isSynced;
  final Value<bool> deleted;
  final Value<int> rowid;
  const UnitsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.order = const Value.absent(),
    this.subjectId = const Value.absent(),
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UnitsCompanion.insert({
    required String id,
    required String name,
    this.order = const Value.absent(),
    required String subjectId,
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        subjectId = Value(subjectId);
  static Insertable<Unit> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? order,
    Expression<String>? subjectId,
    Expression<String>? description,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isSynced,
    Expression<bool>? deleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (order != null) 'order': order,
      if (subjectId != null) 'subject_id': subjectId,
      if (description != null) 'description': description,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (deleted != null) 'deleted': deleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UnitsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<int?>? order,
      Value<String>? subjectId,
      Value<String?>? description,
      Value<DateTime?>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<bool>? isSynced,
      Value<bool>? deleted,
      Value<int>? rowid}) {
    return UnitsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      order: order ?? this.order,
      subjectId: subjectId ?? this.subjectId,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
      deleted: deleted ?? this.deleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (order.present) {
      map['order'] = Variable<int>(order.value);
    }
    if (subjectId.present) {
      map['subject_id'] = Variable<String>(subjectId.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UnitsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('order: $order, ')
          ..write('subjectId: $subjectId, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('deleted: $deleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LessonsTable extends Lessons with TableInfo<$LessonsTable, LessonTable> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LessonsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 3, maxTextLength: 255),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _unitIdMeta = const VerificationMeta('unitId');
  @override
  late final GeneratedColumn<String> unitId = GeneratedColumn<String>(
      'unit_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _orderMeta = const VerificationMeta('order');
  @override
  late final GeneratedColumn<int> order = GeneratedColumn<int>(
      'order', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _isSyncedMeta =
      const VerificationMeta('isSynced');
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
      'is_synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _deletedMeta =
      const VerificationMeta('deleted');
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
      'deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        content,
        unitId,
        order,
        createdAt,
        updatedAt,
        isSynced,
        deleted
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lessons';
  @override
  VerificationContext validateIntegrity(Insertable<LessonTable> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('unit_id')) {
      context.handle(_unitIdMeta,
          unitId.isAcceptableOrUnknown(data['unit_id']!, _unitIdMeta));
    } else if (isInserting) {
      context.missing(_unitIdMeta);
    }
    if (data.containsKey('order')) {
      context.handle(
          _orderMeta, order.isAcceptableOrUnknown(data['order']!, _orderMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('is_synced')) {
      context.handle(_isSyncedMeta,
          isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta));
    }
    if (data.containsKey('deleted')) {
      context.handle(_deletedMeta,
          deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LessonTable map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LessonTable(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      unitId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit_id'])!,
      order: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}order']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
      isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_synced'])!,
      deleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}deleted'])!,
    );
  }

  @override
  $LessonsTable createAlias(String alias) {
    return $LessonsTable(attachedDatabase, alias);
  }
}

class LessonTable extends DataClass implements Insertable<LessonTable> {
  final String id;
  final String title;
  final String content;
  final String unitId;
  final int? order;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isSynced;
  final bool deleted;
  const LessonTable(
      {required this.id,
      required this.title,
      required this.content,
      required this.unitId,
      this.order,
      this.createdAt,
      this.updatedAt,
      required this.isSynced,
      required this.deleted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['content'] = Variable<String>(content);
    map['unit_id'] = Variable<String>(unitId);
    if (!nullToAbsent || order != null) {
      map['order'] = Variable<int>(order);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    map['is_synced'] = Variable<bool>(isSynced);
    map['deleted'] = Variable<bool>(deleted);
    return map;
  }

  LessonsCompanion toCompanion(bool nullToAbsent) {
    return LessonsCompanion(
      id: Value(id),
      title: Value(title),
      content: Value(content),
      unitId: Value(unitId),
      order:
          order == null && nullToAbsent ? const Value.absent() : Value(order),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      isSynced: Value(isSynced),
      deleted: Value(deleted),
    );
  }

  factory LessonTable.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LessonTable(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      content: serializer.fromJson<String>(json['content']),
      unitId: serializer.fromJson<String>(json['unitId']),
      order: serializer.fromJson<int?>(json['order']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      deleted: serializer.fromJson<bool>(json['deleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'content': serializer.toJson<String>(content),
      'unitId': serializer.toJson<String>(unitId),
      'order': serializer.toJson<int?>(order),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'isSynced': serializer.toJson<bool>(isSynced),
      'deleted': serializer.toJson<bool>(deleted),
    };
  }

  LessonTable copyWith(
          {String? id,
          String? title,
          String? content,
          String? unitId,
          Value<int?> order = const Value.absent(),
          Value<DateTime?> createdAt = const Value.absent(),
          Value<DateTime?> updatedAt = const Value.absent(),
          bool? isSynced,
          bool? deleted}) =>
      LessonTable(
        id: id ?? this.id,
        title: title ?? this.title,
        content: content ?? this.content,
        unitId: unitId ?? this.unitId,
        order: order.present ? order.value : this.order,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
        isSynced: isSynced ?? this.isSynced,
        deleted: deleted ?? this.deleted,
      );
  LessonTable copyWithCompanion(LessonsCompanion data) {
    return LessonTable(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      content: data.content.present ? data.content.value : this.content,
      unitId: data.unitId.present ? data.unitId.value : this.unitId,
      order: data.order.present ? data.order.value : this.order,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LessonTable(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('unitId: $unitId, ')
          ..write('order: $order, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('deleted: $deleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, content, unitId, order, createdAt,
      updatedAt, isSynced, deleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LessonTable &&
          other.id == this.id &&
          other.title == this.title &&
          other.content == this.content &&
          other.unitId == this.unitId &&
          other.order == this.order &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isSynced == this.isSynced &&
          other.deleted == this.deleted);
}

class LessonsCompanion extends UpdateCompanion<LessonTable> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> content;
  final Value<String> unitId;
  final Value<int?> order;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<bool> isSynced;
  final Value<bool> deleted;
  final Value<int> rowid;
  const LessonsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.unitId = const Value.absent(),
    this.order = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LessonsCompanion.insert({
    required String id,
    required String title,
    required String content,
    required String unitId,
    this.order = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        content = Value(content),
        unitId = Value(unitId);
  static Insertable<LessonTable> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? content,
    Expression<String>? unitId,
    Expression<int>? order,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isSynced,
    Expression<bool>? deleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (unitId != null) 'unit_id': unitId,
      if (order != null) 'order': order,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (deleted != null) 'deleted': deleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LessonsCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String>? content,
      Value<String>? unitId,
      Value<int?>? order,
      Value<DateTime?>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<bool>? isSynced,
      Value<bool>? deleted,
      Value<int>? rowid}) {
    return LessonsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      unitId: unitId ?? this.unitId,
      order: order ?? this.order,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
      deleted: deleted ?? this.deleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (unitId.present) {
      map['unit_id'] = Variable<String>(unitId.value);
    }
    if (order.present) {
      map['order'] = Variable<int>(order.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LessonsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('unitId: $unitId, ')
          ..write('order: $order, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('deleted: $deleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $QuestionsTable extends Questions
    with TableInfo<$QuestionsTable, QuestionTable> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuestionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lessonIdMeta =
      const VerificationMeta('lessonId');
  @override
  late final GeneratedColumn<String> lessonId = GeneratedColumn<String>(
      'lesson_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _questionTextMeta =
      const VerificationMeta('questionText');
  @override
  late final GeneratedColumn<String> questionText = GeneratedColumn<String>(
      'question_text', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<String> data = GeneratedColumn<String>(
      'data', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _explanationMeta =
      const VerificationMeta('explanation');
  @override
  late final GeneratedColumn<String> explanation = GeneratedColumn<String>(
      'explanation', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _deletedMeta =
      const VerificationMeta('deleted');
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
      'deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _orderMeta = const VerificationMeta('order');
  @override
  late final GeneratedColumn<int> order = GeneratedColumn<int>(
      'order', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _isSyncedMeta =
      const VerificationMeta('isSynced');
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
      'is_synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        lessonId,
        questionText,
        type,
        data,
        explanation,
        createdAt,
        updatedAt,
        deleted,
        order,
        isSynced
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'questions';
  @override
  VerificationContext validateIntegrity(Insertable<QuestionTable> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('lesson_id')) {
      context.handle(_lessonIdMeta,
          lessonId.isAcceptableOrUnknown(data['lesson_id']!, _lessonIdMeta));
    } else if (isInserting) {
      context.missing(_lessonIdMeta);
    }
    if (data.containsKey('question_text')) {
      context.handle(
          _questionTextMeta,
          questionText.isAcceptableOrUnknown(
              data['question_text']!, _questionTextMeta));
    } else if (isInserting) {
      context.missing(_questionTextMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('data')) {
      context.handle(
          _dataMeta, this.data.isAcceptableOrUnknown(data['data']!, _dataMeta));
    } else if (isInserting) {
      context.missing(_dataMeta);
    }
    if (data.containsKey('explanation')) {
      context.handle(
          _explanationMeta,
          explanation.isAcceptableOrUnknown(
              data['explanation']!, _explanationMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('deleted')) {
      context.handle(_deletedMeta,
          deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta));
    }
    if (data.containsKey('order')) {
      context.handle(
          _orderMeta, order.isAcceptableOrUnknown(data['order']!, _orderMeta));
    }
    if (data.containsKey('is_synced')) {
      context.handle(_isSyncedMeta,
          isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QuestionTable map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuestionTable(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      lessonId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lesson_id'])!,
      questionText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}question_text'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      data: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}data'])!,
      explanation: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}explanation']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      deleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}deleted'])!,
      order: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}order']),
      isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_synced'])!,
    );
  }

  @override
  $QuestionsTable createAlias(String alias) {
    return $QuestionsTable(attachedDatabase, alias);
  }
}

class QuestionTable extends DataClass implements Insertable<QuestionTable> {
  final String id;
  final String lessonId;
  final String questionText;
  final String type;
  final String data;
  final String? explanation;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool deleted;
  final int? order;
  final bool isSynced;
  const QuestionTable(
      {required this.id,
      required this.lessonId,
      required this.questionText,
      required this.type,
      required this.data,
      this.explanation,
      required this.createdAt,
      required this.updatedAt,
      required this.deleted,
      this.order,
      required this.isSynced});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['lesson_id'] = Variable<String>(lessonId);
    map['question_text'] = Variable<String>(questionText);
    map['type'] = Variable<String>(type);
    map['data'] = Variable<String>(data);
    if (!nullToAbsent || explanation != null) {
      map['explanation'] = Variable<String>(explanation);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['deleted'] = Variable<bool>(deleted);
    if (!nullToAbsent || order != null) {
      map['order'] = Variable<int>(order);
    }
    map['is_synced'] = Variable<bool>(isSynced);
    return map;
  }

  QuestionsCompanion toCompanion(bool nullToAbsent) {
    return QuestionsCompanion(
      id: Value(id),
      lessonId: Value(lessonId),
      questionText: Value(questionText),
      type: Value(type),
      data: Value(data),
      explanation: explanation == null && nullToAbsent
          ? const Value.absent()
          : Value(explanation),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deleted: Value(deleted),
      order:
          order == null && nullToAbsent ? const Value.absent() : Value(order),
      isSynced: Value(isSynced),
    );
  }

  factory QuestionTable.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuestionTable(
      id: serializer.fromJson<String>(json['id']),
      lessonId: serializer.fromJson<String>(json['lessonId']),
      questionText: serializer.fromJson<String>(json['questionText']),
      type: serializer.fromJson<String>(json['type']),
      data: serializer.fromJson<String>(json['data']),
      explanation: serializer.fromJson<String?>(json['explanation']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      order: serializer.fromJson<int?>(json['order']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'lessonId': serializer.toJson<String>(lessonId),
      'questionText': serializer.toJson<String>(questionText),
      'type': serializer.toJson<String>(type),
      'data': serializer.toJson<String>(data),
      'explanation': serializer.toJson<String?>(explanation),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deleted': serializer.toJson<bool>(deleted),
      'order': serializer.toJson<int?>(order),
      'isSynced': serializer.toJson<bool>(isSynced),
    };
  }

  QuestionTable copyWith(
          {String? id,
          String? lessonId,
          String? questionText,
          String? type,
          String? data,
          Value<String?> explanation = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt,
          bool? deleted,
          Value<int?> order = const Value.absent(),
          bool? isSynced}) =>
      QuestionTable(
        id: id ?? this.id,
        lessonId: lessonId ?? this.lessonId,
        questionText: questionText ?? this.questionText,
        type: type ?? this.type,
        data: data ?? this.data,
        explanation: explanation.present ? explanation.value : this.explanation,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deleted: deleted ?? this.deleted,
        order: order.present ? order.value : this.order,
        isSynced: isSynced ?? this.isSynced,
      );
  QuestionTable copyWithCompanion(QuestionsCompanion data) {
    return QuestionTable(
      id: data.id.present ? data.id.value : this.id,
      lessonId: data.lessonId.present ? data.lessonId.value : this.lessonId,
      questionText: data.questionText.present
          ? data.questionText.value
          : this.questionText,
      type: data.type.present ? data.type.value : this.type,
      data: data.data.present ? data.data.value : this.data,
      explanation:
          data.explanation.present ? data.explanation.value : this.explanation,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      order: data.order.present ? data.order.value : this.order,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuestionTable(')
          ..write('id: $id, ')
          ..write('lessonId: $lessonId, ')
          ..write('questionText: $questionText, ')
          ..write('type: $type, ')
          ..write('data: $data, ')
          ..write('explanation: $explanation, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('order: $order, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, lessonId, questionText, type, data,
      explanation, createdAt, updatedAt, deleted, order, isSynced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuestionTable &&
          other.id == this.id &&
          other.lessonId == this.lessonId &&
          other.questionText == this.questionText &&
          other.type == this.type &&
          other.data == this.data &&
          other.explanation == this.explanation &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deleted == this.deleted &&
          other.order == this.order &&
          other.isSynced == this.isSynced);
}

class QuestionsCompanion extends UpdateCompanion<QuestionTable> {
  final Value<String> id;
  final Value<String> lessonId;
  final Value<String> questionText;
  final Value<String> type;
  final Value<String> data;
  final Value<String?> explanation;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> deleted;
  final Value<int?> order;
  final Value<bool> isSynced;
  final Value<int> rowid;
  const QuestionsCompanion({
    this.id = const Value.absent(),
    this.lessonId = const Value.absent(),
    this.questionText = const Value.absent(),
    this.type = const Value.absent(),
    this.data = const Value.absent(),
    this.explanation = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.order = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  QuestionsCompanion.insert({
    required String id,
    required String lessonId,
    required String questionText,
    required String type,
    required String data,
    this.explanation = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.order = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        lessonId = Value(lessonId),
        questionText = Value(questionText),
        type = Value(type),
        data = Value(data);
  static Insertable<QuestionTable> custom({
    Expression<String>? id,
    Expression<String>? lessonId,
    Expression<String>? questionText,
    Expression<String>? type,
    Expression<String>? data,
    Expression<String>? explanation,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? deleted,
    Expression<int>? order,
    Expression<bool>? isSynced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lessonId != null) 'lesson_id': lessonId,
      if (questionText != null) 'question_text': questionText,
      if (type != null) 'type': type,
      if (data != null) 'data': data,
      if (explanation != null) 'explanation': explanation,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deleted != null) 'deleted': deleted,
      if (order != null) 'order': order,
      if (isSynced != null) 'is_synced': isSynced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  QuestionsCompanion copyWith(
      {Value<String>? id,
      Value<String>? lessonId,
      Value<String>? questionText,
      Value<String>? type,
      Value<String>? data,
      Value<String?>? explanation,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<bool>? deleted,
      Value<int?>? order,
      Value<bool>? isSynced,
      Value<int>? rowid}) {
    return QuestionsCompanion(
      id: id ?? this.id,
      lessonId: lessonId ?? this.lessonId,
      questionText: questionText ?? this.questionText,
      type: type ?? this.type,
      data: data ?? this.data,
      explanation: explanation ?? this.explanation,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
      order: order ?? this.order,
      isSynced: isSynced ?? this.isSynced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (lessonId.present) {
      map['lesson_id'] = Variable<String>(lessonId.value);
    }
    if (questionText.present) {
      map['question_text'] = Variable<String>(questionText.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (data.present) {
      map['data'] = Variable<String>(data.value);
    }
    if (explanation.present) {
      map['explanation'] = Variable<String>(explanation.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (order.present) {
      map['order'] = Variable<int>(order.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuestionsCompanion(')
          ..write('id: $id, ')
          ..write('lessonId: $lessonId, ')
          ..write('questionText: $questionText, ')
          ..write('type: $type, ')
          ..write('data: $data, ')
          ..write('explanation: $explanation, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('order: $order, ')
          ..write('isSynced: $isSynced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TeachersTable teachers = $TeachersTable(this);
  late final $SyncLogsTable syncLogs = $SyncLogsTable(this);
  late final $GradesTable grades = $GradesTable(this);
  late final $SemestersTable semesters = $SemestersTable(this);
  late final $SubjectsTable subjects = $SubjectsTable(this);
  late final $UnitsTable units = $UnitsTable(this);
  late final $LessonsTable lessons = $LessonsTable(this);
  late final $QuestionsTable questions = $QuestionsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        teachers,
        syncLogs,
        grades,
        semesters,
        subjects,
        units,
        lessons,
        questions
      ];
}

typedef $$TeachersTableCreateCompanionBuilder = TeachersCompanion Function({
  required String id,
  required String username,
  Value<String?> phone,
  Value<String?> fullName,
  required String password,
  Value<String> role,
  Value<String?> specialization,
  Value<List<String>?> assignedSubjects,
  Value<bool> isSynced,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  Value<bool> deleted,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});
typedef $$TeachersTableUpdateCompanionBuilder = TeachersCompanion Function({
  Value<String> id,
  Value<String> username,
  Value<String?> phone,
  Value<String?> fullName,
  Value<String> password,
  Value<String> role,
  Value<String?> specialization,
  Value<List<String>?> assignedSubjects,
  Value<bool> isSynced,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  Value<bool> deleted,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});

class $$TeachersTableFilterComposer
    extends Composer<_$AppDatabase, $TeachersTable> {
  $$TeachersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fullName => $composableBuilder(
      column: $table.fullName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get password => $composableBuilder(
      column: $table.password, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get specialization => $composableBuilder(
      column: $table.specialization,
      builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<List<String>?, List<String>, String>
      get assignedSubjects => $composableBuilder(
          column: $table.assignedSubjects,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));
}

class $$TeachersTableOrderingComposer
    extends Composer<_$AppDatabase, $TeachersTable> {
  $$TeachersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fullName => $composableBuilder(
      column: $table.fullName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get password => $composableBuilder(
      column: $table.password, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get specialization => $composableBuilder(
      column: $table.specialization,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get assignedSubjects => $composableBuilder(
      column: $table.assignedSubjects,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));
}

class $$TeachersTableAnnotationComposer
    extends Composer<_$AppDatabase, $TeachersTable> {
  $$TeachersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<String> get password =>
      $composableBuilder(column: $table.password, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get specialization => $composableBuilder(
      column: $table.specialization, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>?, String>
      get assignedSubjects => $composableBuilder(
          column: $table.assignedSubjects, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$TeachersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TeachersTable,
    Teacher,
    $$TeachersTableFilterComposer,
    $$TeachersTableOrderingComposer,
    $$TeachersTableAnnotationComposer,
    $$TeachersTableCreateCompanionBuilder,
    $$TeachersTableUpdateCompanionBuilder,
    (Teacher, BaseReferences<_$AppDatabase, $TeachersTable, Teacher>),
    Teacher,
    PrefetchHooks Function()> {
  $$TeachersTableTableManager(_$AppDatabase db, $TeachersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TeachersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TeachersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TeachersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> username = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String?> fullName = const Value.absent(),
            Value<String> password = const Value.absent(),
            Value<String> role = const Value.absent(),
            Value<String?> specialization = const Value.absent(),
            Value<List<String>?> assignedSubjects = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TeachersCompanion(
            id: id,
            username: username,
            phone: phone,
            fullName: fullName,
            password: password,
            role: role,
            specialization: specialization,
            assignedSubjects: assignedSubjects,
            isSynced: isSynced,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deleted: deleted,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String username,
            Value<String?> phone = const Value.absent(),
            Value<String?> fullName = const Value.absent(),
            required String password,
            Value<String> role = const Value.absent(),
            Value<String?> specialization = const Value.absent(),
            Value<List<String>?> assignedSubjects = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TeachersCompanion.insert(
            id: id,
            username: username,
            phone: phone,
            fullName: fullName,
            password: password,
            role: role,
            specialization: specialization,
            assignedSubjects: assignedSubjects,
            isSynced: isSynced,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deleted: deleted,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TeachersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TeachersTable,
    Teacher,
    $$TeachersTableFilterComposer,
    $$TeachersTableOrderingComposer,
    $$TeachersTableAnnotationComposer,
    $$TeachersTableCreateCompanionBuilder,
    $$TeachersTableUpdateCompanionBuilder,
    (Teacher, BaseReferences<_$AppDatabase, $TeachersTable, Teacher>),
    Teacher,
    PrefetchHooks Function()>;
typedef $$SyncLogsTableCreateCompanionBuilder = SyncLogsCompanion Function({
  Value<int> id,
  required String entity,
  Value<String?> parentId,
  required DateTime lastSyncAt,
});
typedef $$SyncLogsTableUpdateCompanionBuilder = SyncLogsCompanion Function({
  Value<int> id,
  Value<String> entity,
  Value<String?> parentId,
  Value<DateTime> lastSyncAt,
});

class $$SyncLogsTableFilterComposer
    extends Composer<_$AppDatabase, $SyncLogsTable> {
  $$SyncLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entity => $composableBuilder(
      column: $table.entity, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get parentId => $composableBuilder(
      column: $table.parentId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastSyncAt => $composableBuilder(
      column: $table.lastSyncAt, builder: (column) => ColumnFilters(column));
}

class $$SyncLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncLogsTable> {
  $$SyncLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entity => $composableBuilder(
      column: $table.entity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get parentId => $composableBuilder(
      column: $table.parentId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastSyncAt => $composableBuilder(
      column: $table.lastSyncAt, builder: (column) => ColumnOrderings(column));
}

class $$SyncLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncLogsTable> {
  $$SyncLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entity =>
      $composableBuilder(column: $table.entity, builder: (column) => column);

  GeneratedColumn<String> get parentId =>
      $composableBuilder(column: $table.parentId, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncAt => $composableBuilder(
      column: $table.lastSyncAt, builder: (column) => column);
}

class $$SyncLogsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SyncLogsTable,
    SyncLog,
    $$SyncLogsTableFilterComposer,
    $$SyncLogsTableOrderingComposer,
    $$SyncLogsTableAnnotationComposer,
    $$SyncLogsTableCreateCompanionBuilder,
    $$SyncLogsTableUpdateCompanionBuilder,
    (SyncLog, BaseReferences<_$AppDatabase, $SyncLogsTable, SyncLog>),
    SyncLog,
    PrefetchHooks Function()> {
  $$SyncLogsTableTableManager(_$AppDatabase db, $SyncLogsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> entity = const Value.absent(),
            Value<String?> parentId = const Value.absent(),
            Value<DateTime> lastSyncAt = const Value.absent(),
          }) =>
              SyncLogsCompanion(
            id: id,
            entity: entity,
            parentId: parentId,
            lastSyncAt: lastSyncAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String entity,
            Value<String?> parentId = const Value.absent(),
            required DateTime lastSyncAt,
          }) =>
              SyncLogsCompanion.insert(
            id: id,
            entity: entity,
            parentId: parentId,
            lastSyncAt: lastSyncAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SyncLogsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SyncLogsTable,
    SyncLog,
    $$SyncLogsTableFilterComposer,
    $$SyncLogsTableOrderingComposer,
    $$SyncLogsTableAnnotationComposer,
    $$SyncLogsTableCreateCompanionBuilder,
    $$SyncLogsTableUpdateCompanionBuilder,
    (SyncLog, BaseReferences<_$AppDatabase, $SyncLogsTable, SyncLog>),
    SyncLog,
    PrefetchHooks Function()>;
typedef $$GradesTableCreateCompanionBuilder = GradesCompanion Function({
  required String id,
  required String name,
  required int order,
  Value<String?> description,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  Value<bool> isSynced,
  Value<bool> deleted,
  Value<int> rowid,
});
typedef $$GradesTableUpdateCompanionBuilder = GradesCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<int> order,
  Value<String?> description,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  Value<bool> isSynced,
  Value<bool> deleted,
  Value<int> rowid,
});

final class $$GradesTableReferences
    extends BaseReferences<_$AppDatabase, $GradesTable, Grade> {
  $$GradesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SemestersTable, List<Semester>>
      _semestersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.semesters,
          aliasName: $_aliasNameGenerator(db.grades.id, db.semesters.gradeId));

  $$SemestersTableProcessedTableManager get semestersRefs {
    final manager = $$SemestersTableTableManager($_db, $_db.semesters)
        .filter((f) => f.gradeId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_semestersRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$SubjectsTable, List<Subject>> _subjectsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.subjects,
          aliasName: $_aliasNameGenerator(db.grades.id, db.subjects.gradeId));

  $$SubjectsTableProcessedTableManager get subjectsRefs {
    final manager = $$SubjectsTableTableManager($_db, $_db.subjects)
        .filter((f) => f.gradeId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_subjectsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$GradesTableFilterComposer
    extends Composer<_$AppDatabase, $GradesTable> {
  $$GradesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get order => $composableBuilder(
      column: $table.order, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnFilters(column));

  Expression<bool> semestersRefs(
      Expression<bool> Function($$SemestersTableFilterComposer f) f) {
    final $$SemestersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.semesters,
        getReferencedColumn: (t) => t.gradeId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SemestersTableFilterComposer(
              $db: $db,
              $table: $db.semesters,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> subjectsRefs(
      Expression<bool> Function($$SubjectsTableFilterComposer f) f) {
    final $$SubjectsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.subjects,
        getReferencedColumn: (t) => t.gradeId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SubjectsTableFilterComposer(
              $db: $db,
              $table: $db.subjects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$GradesTableOrderingComposer
    extends Composer<_$AppDatabase, $GradesTable> {
  $$GradesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get order => $composableBuilder(
      column: $table.order, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnOrderings(column));
}

class $$GradesTableAnnotationComposer
    extends Composer<_$AppDatabase, $GradesTable> {
  $$GradesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get order =>
      $composableBuilder(column: $table.order, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  Expression<T> semestersRefs<T extends Object>(
      Expression<T> Function($$SemestersTableAnnotationComposer a) f) {
    final $$SemestersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.semesters,
        getReferencedColumn: (t) => t.gradeId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SemestersTableAnnotationComposer(
              $db: $db,
              $table: $db.semesters,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> subjectsRefs<T extends Object>(
      Expression<T> Function($$SubjectsTableAnnotationComposer a) f) {
    final $$SubjectsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.subjects,
        getReferencedColumn: (t) => t.gradeId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SubjectsTableAnnotationComposer(
              $db: $db,
              $table: $db.subjects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$GradesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GradesTable,
    Grade,
    $$GradesTableFilterComposer,
    $$GradesTableOrderingComposer,
    $$GradesTableAnnotationComposer,
    $$GradesTableCreateCompanionBuilder,
    $$GradesTableUpdateCompanionBuilder,
    (Grade, $$GradesTableReferences),
    Grade,
    PrefetchHooks Function({bool semestersRefs, bool subjectsRefs})> {
  $$GradesTableTableManager(_$AppDatabase db, $GradesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GradesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GradesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GradesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> order = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GradesCompanion(
            id: id,
            name: name,
            order: order,
            description: description,
            createdAt: createdAt,
            updatedAt: updatedAt,
            isSynced: isSynced,
            deleted: deleted,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required int order,
            Value<String?> description = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GradesCompanion.insert(
            id: id,
            name: name,
            order: order,
            description: description,
            createdAt: createdAt,
            updatedAt: updatedAt,
            isSynced: isSynced,
            deleted: deleted,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$GradesTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {semestersRefs = false, subjectsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (semestersRefs) db.semesters,
                if (subjectsRefs) db.subjects
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (semestersRefs)
                    await $_getPrefetchedData<Grade, $GradesTable, Semester>(
                        currentTable: table,
                        referencedTable:
                            $$GradesTableReferences._semestersRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$GradesTableReferences(db, table, p0)
                                .semestersRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.gradeId == item.id),
                        typedResults: items),
                  if (subjectsRefs)
                    await $_getPrefetchedData<Grade, $GradesTable, Subject>(
                        currentTable: table,
                        referencedTable:
                            $$GradesTableReferences._subjectsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$GradesTableReferences(db, table, p0).subjectsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.gradeId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$GradesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $GradesTable,
    Grade,
    $$GradesTableFilterComposer,
    $$GradesTableOrderingComposer,
    $$GradesTableAnnotationComposer,
    $$GradesTableCreateCompanionBuilder,
    $$GradesTableUpdateCompanionBuilder,
    (Grade, $$GradesTableReferences),
    Grade,
    PrefetchHooks Function({bool semestersRefs, bool subjectsRefs})>;
typedef $$SemestersTableCreateCompanionBuilder = SemestersCompanion Function({
  required String id,
  required String name,
  required int order,
  required String gradeId,
  Value<String?> description,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  Value<bool> isSynced,
  Value<bool> deleted,
  Value<int> rowid,
});
typedef $$SemestersTableUpdateCompanionBuilder = SemestersCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<int> order,
  Value<String> gradeId,
  Value<String?> description,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  Value<bool> isSynced,
  Value<bool> deleted,
  Value<int> rowid,
});

final class $$SemestersTableReferences
    extends BaseReferences<_$AppDatabase, $SemestersTable, Semester> {
  $$SemestersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GradesTable _gradeIdTable(_$AppDatabase db) => db.grades
      .createAlias($_aliasNameGenerator(db.semesters.gradeId, db.grades.id));

  $$GradesTableProcessedTableManager get gradeId {
    final $_column = $_itemColumn<String>('grade_id')!;

    final manager = $$GradesTableTableManager($_db, $_db.grades)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_gradeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$SubjectsTable, List<Subject>> _subjectsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.subjects,
          aliasName:
              $_aliasNameGenerator(db.semesters.id, db.subjects.semesterId));

  $$SubjectsTableProcessedTableManager get subjectsRefs {
    final manager = $$SubjectsTableTableManager($_db, $_db.subjects)
        .filter((f) => f.semesterId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_subjectsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$SemestersTableFilterComposer
    extends Composer<_$AppDatabase, $SemestersTable> {
  $$SemestersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get order => $composableBuilder(
      column: $table.order, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnFilters(column));

  $$GradesTableFilterComposer get gradeId {
    final $$GradesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.gradeId,
        referencedTable: $db.grades,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GradesTableFilterComposer(
              $db: $db,
              $table: $db.grades,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> subjectsRefs(
      Expression<bool> Function($$SubjectsTableFilterComposer f) f) {
    final $$SubjectsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.subjects,
        getReferencedColumn: (t) => t.semesterId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SubjectsTableFilterComposer(
              $db: $db,
              $table: $db.subjects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$SemestersTableOrderingComposer
    extends Composer<_$AppDatabase, $SemestersTable> {
  $$SemestersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get order => $composableBuilder(
      column: $table.order, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnOrderings(column));

  $$GradesTableOrderingComposer get gradeId {
    final $$GradesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.gradeId,
        referencedTable: $db.grades,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GradesTableOrderingComposer(
              $db: $db,
              $table: $db.grades,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SemestersTableAnnotationComposer
    extends Composer<_$AppDatabase, $SemestersTable> {
  $$SemestersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get order =>
      $composableBuilder(column: $table.order, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  $$GradesTableAnnotationComposer get gradeId {
    final $$GradesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.gradeId,
        referencedTable: $db.grades,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GradesTableAnnotationComposer(
              $db: $db,
              $table: $db.grades,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> subjectsRefs<T extends Object>(
      Expression<T> Function($$SubjectsTableAnnotationComposer a) f) {
    final $$SubjectsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.subjects,
        getReferencedColumn: (t) => t.semesterId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SubjectsTableAnnotationComposer(
              $db: $db,
              $table: $db.subjects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$SemestersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SemestersTable,
    Semester,
    $$SemestersTableFilterComposer,
    $$SemestersTableOrderingComposer,
    $$SemestersTableAnnotationComposer,
    $$SemestersTableCreateCompanionBuilder,
    $$SemestersTableUpdateCompanionBuilder,
    (Semester, $$SemestersTableReferences),
    Semester,
    PrefetchHooks Function({bool gradeId, bool subjectsRefs})> {
  $$SemestersTableTableManager(_$AppDatabase db, $SemestersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SemestersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SemestersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SemestersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> order = const Value.absent(),
            Value<String> gradeId = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SemestersCompanion(
            id: id,
            name: name,
            order: order,
            gradeId: gradeId,
            description: description,
            createdAt: createdAt,
            updatedAt: updatedAt,
            isSynced: isSynced,
            deleted: deleted,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required int order,
            required String gradeId,
            Value<String?> description = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SemestersCompanion.insert(
            id: id,
            name: name,
            order: order,
            gradeId: gradeId,
            description: description,
            createdAt: createdAt,
            updatedAt: updatedAt,
            isSynced: isSynced,
            deleted: deleted,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$SemestersTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({gradeId = false, subjectsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (subjectsRefs) db.subjects],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (gradeId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.gradeId,
                    referencedTable:
                        $$SemestersTableReferences._gradeIdTable(db),
                    referencedColumn:
                        $$SemestersTableReferences._gradeIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (subjectsRefs)
                    await $_getPrefetchedData<Semester, $SemestersTable,
                            Subject>(
                        currentTable: table,
                        referencedTable:
                            $$SemestersTableReferences._subjectsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$SemestersTableReferences(db, table, p0)
                                .subjectsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.semesterId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$SemestersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SemestersTable,
    Semester,
    $$SemestersTableFilterComposer,
    $$SemestersTableOrderingComposer,
    $$SemestersTableAnnotationComposer,
    $$SemestersTableCreateCompanionBuilder,
    $$SemestersTableUpdateCompanionBuilder,
    (Semester, $$SemestersTableReferences),
    Semester,
    PrefetchHooks Function({bool gradeId, bool subjectsRefs})>;
typedef $$SubjectsTableCreateCompanionBuilder = SubjectsCompanion Function({
  required String id,
  required String name,
  Value<int?> order,
  required String semesterId,
  required String gradeId,
  Value<String?> description,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  Value<bool> isSynced,
  Value<bool> deleted,
  Value<int> rowid,
});
typedef $$SubjectsTableUpdateCompanionBuilder = SubjectsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<int?> order,
  Value<String> semesterId,
  Value<String> gradeId,
  Value<String?> description,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  Value<bool> isSynced,
  Value<bool> deleted,
  Value<int> rowid,
});

final class $$SubjectsTableReferences
    extends BaseReferences<_$AppDatabase, $SubjectsTable, Subject> {
  $$SubjectsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SemestersTable _semesterIdTable(_$AppDatabase db) =>
      db.semesters.createAlias(
          $_aliasNameGenerator(db.subjects.semesterId, db.semesters.id));

  $$SemestersTableProcessedTableManager get semesterId {
    final $_column = $_itemColumn<String>('semester_id')!;

    final manager = $$SemestersTableTableManager($_db, $_db.semesters)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_semesterIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $GradesTable _gradeIdTable(_$AppDatabase db) => db.grades
      .createAlias($_aliasNameGenerator(db.subjects.gradeId, db.grades.id));

  $$GradesTableProcessedTableManager get gradeId {
    final $_column = $_itemColumn<String>('grade_id')!;

    final manager = $$GradesTableTableManager($_db, $_db.grades)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_gradeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$UnitsTable, List<Unit>> _unitsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.units,
          aliasName: $_aliasNameGenerator(db.subjects.id, db.units.subjectId));

  $$UnitsTableProcessedTableManager get unitsRefs {
    final manager = $$UnitsTableTableManager($_db, $_db.units)
        .filter((f) => f.subjectId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_unitsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$SubjectsTableFilterComposer
    extends Composer<_$AppDatabase, $SubjectsTable> {
  $$SubjectsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get order => $composableBuilder(
      column: $table.order, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnFilters(column));

  $$SemestersTableFilterComposer get semesterId {
    final $$SemestersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.semesterId,
        referencedTable: $db.semesters,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SemestersTableFilterComposer(
              $db: $db,
              $table: $db.semesters,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$GradesTableFilterComposer get gradeId {
    final $$GradesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.gradeId,
        referencedTable: $db.grades,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GradesTableFilterComposer(
              $db: $db,
              $table: $db.grades,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> unitsRefs(
      Expression<bool> Function($$UnitsTableFilterComposer f) f) {
    final $$UnitsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.units,
        getReferencedColumn: (t) => t.subjectId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UnitsTableFilterComposer(
              $db: $db,
              $table: $db.units,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$SubjectsTableOrderingComposer
    extends Composer<_$AppDatabase, $SubjectsTable> {
  $$SubjectsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get order => $composableBuilder(
      column: $table.order, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnOrderings(column));

  $$SemestersTableOrderingComposer get semesterId {
    final $$SemestersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.semesterId,
        referencedTable: $db.semesters,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SemestersTableOrderingComposer(
              $db: $db,
              $table: $db.semesters,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$GradesTableOrderingComposer get gradeId {
    final $$GradesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.gradeId,
        referencedTable: $db.grades,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GradesTableOrderingComposer(
              $db: $db,
              $table: $db.grades,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SubjectsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubjectsTable> {
  $$SubjectsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get order =>
      $composableBuilder(column: $table.order, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  $$SemestersTableAnnotationComposer get semesterId {
    final $$SemestersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.semesterId,
        referencedTable: $db.semesters,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SemestersTableAnnotationComposer(
              $db: $db,
              $table: $db.semesters,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$GradesTableAnnotationComposer get gradeId {
    final $$GradesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.gradeId,
        referencedTable: $db.grades,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GradesTableAnnotationComposer(
              $db: $db,
              $table: $db.grades,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> unitsRefs<T extends Object>(
      Expression<T> Function($$UnitsTableAnnotationComposer a) f) {
    final $$UnitsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.units,
        getReferencedColumn: (t) => t.subjectId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UnitsTableAnnotationComposer(
              $db: $db,
              $table: $db.units,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$SubjectsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SubjectsTable,
    Subject,
    $$SubjectsTableFilterComposer,
    $$SubjectsTableOrderingComposer,
    $$SubjectsTableAnnotationComposer,
    $$SubjectsTableCreateCompanionBuilder,
    $$SubjectsTableUpdateCompanionBuilder,
    (Subject, $$SubjectsTableReferences),
    Subject,
    PrefetchHooks Function({bool semesterId, bool gradeId, bool unitsRefs})> {
  $$SubjectsTableTableManager(_$AppDatabase db, $SubjectsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubjectsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SubjectsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubjectsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int?> order = const Value.absent(),
            Value<String> semesterId = const Value.absent(),
            Value<String> gradeId = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SubjectsCompanion(
            id: id,
            name: name,
            order: order,
            semesterId: semesterId,
            gradeId: gradeId,
            description: description,
            createdAt: createdAt,
            updatedAt: updatedAt,
            isSynced: isSynced,
            deleted: deleted,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<int?> order = const Value.absent(),
            required String semesterId,
            required String gradeId,
            Value<String?> description = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SubjectsCompanion.insert(
            id: id,
            name: name,
            order: order,
            semesterId: semesterId,
            gradeId: gradeId,
            description: description,
            createdAt: createdAt,
            updatedAt: updatedAt,
            isSynced: isSynced,
            deleted: deleted,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$SubjectsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {semesterId = false, gradeId = false, unitsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (unitsRefs) db.units],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (semesterId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.semesterId,
                    referencedTable:
                        $$SubjectsTableReferences._semesterIdTable(db),
                    referencedColumn:
                        $$SubjectsTableReferences._semesterIdTable(db).id,
                  ) as T;
                }
                if (gradeId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.gradeId,
                    referencedTable:
                        $$SubjectsTableReferences._gradeIdTable(db),
                    referencedColumn:
                        $$SubjectsTableReferences._gradeIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (unitsRefs)
                    await $_getPrefetchedData<Subject, $SubjectsTable, Unit>(
                        currentTable: table,
                        referencedTable:
                            $$SubjectsTableReferences._unitsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$SubjectsTableReferences(db, table, p0).unitsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.subjectId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$SubjectsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SubjectsTable,
    Subject,
    $$SubjectsTableFilterComposer,
    $$SubjectsTableOrderingComposer,
    $$SubjectsTableAnnotationComposer,
    $$SubjectsTableCreateCompanionBuilder,
    $$SubjectsTableUpdateCompanionBuilder,
    (Subject, $$SubjectsTableReferences),
    Subject,
    PrefetchHooks Function({bool semesterId, bool gradeId, bool unitsRefs})>;
typedef $$UnitsTableCreateCompanionBuilder = UnitsCompanion Function({
  required String id,
  required String name,
  Value<int?> order,
  required String subjectId,
  Value<String?> description,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  Value<bool> isSynced,
  Value<bool> deleted,
  Value<int> rowid,
});
typedef $$UnitsTableUpdateCompanionBuilder = UnitsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<int?> order,
  Value<String> subjectId,
  Value<String?> description,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  Value<bool> isSynced,
  Value<bool> deleted,
  Value<int> rowid,
});

final class $$UnitsTableReferences
    extends BaseReferences<_$AppDatabase, $UnitsTable, Unit> {
  $$UnitsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SubjectsTable _subjectIdTable(_$AppDatabase db) => db.subjects
      .createAlias($_aliasNameGenerator(db.units.subjectId, db.subjects.id));

  $$SubjectsTableProcessedTableManager get subjectId {
    final $_column = $_itemColumn<String>('subject_id')!;

    final manager = $$SubjectsTableTableManager($_db, $_db.subjects)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_subjectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$UnitsTableFilterComposer extends Composer<_$AppDatabase, $UnitsTable> {
  $$UnitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get order => $composableBuilder(
      column: $table.order, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnFilters(column));

  $$SubjectsTableFilterComposer get subjectId {
    final $$SubjectsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.subjectId,
        referencedTable: $db.subjects,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SubjectsTableFilterComposer(
              $db: $db,
              $table: $db.subjects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$UnitsTableOrderingComposer
    extends Composer<_$AppDatabase, $UnitsTable> {
  $$UnitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get order => $composableBuilder(
      column: $table.order, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnOrderings(column));

  $$SubjectsTableOrderingComposer get subjectId {
    final $$SubjectsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.subjectId,
        referencedTable: $db.subjects,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SubjectsTableOrderingComposer(
              $db: $db,
              $table: $db.subjects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$UnitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UnitsTable> {
  $$UnitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get order =>
      $composableBuilder(column: $table.order, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  $$SubjectsTableAnnotationComposer get subjectId {
    final $$SubjectsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.subjectId,
        referencedTable: $db.subjects,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SubjectsTableAnnotationComposer(
              $db: $db,
              $table: $db.subjects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$UnitsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UnitsTable,
    Unit,
    $$UnitsTableFilterComposer,
    $$UnitsTableOrderingComposer,
    $$UnitsTableAnnotationComposer,
    $$UnitsTableCreateCompanionBuilder,
    $$UnitsTableUpdateCompanionBuilder,
    (Unit, $$UnitsTableReferences),
    Unit,
    PrefetchHooks Function({bool subjectId})> {
  $$UnitsTableTableManager(_$AppDatabase db, $UnitsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UnitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UnitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UnitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int?> order = const Value.absent(),
            Value<String> subjectId = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UnitsCompanion(
            id: id,
            name: name,
            order: order,
            subjectId: subjectId,
            description: description,
            createdAt: createdAt,
            updatedAt: updatedAt,
            isSynced: isSynced,
            deleted: deleted,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<int?> order = const Value.absent(),
            required String subjectId,
            Value<String?> description = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UnitsCompanion.insert(
            id: id,
            name: name,
            order: order,
            subjectId: subjectId,
            description: description,
            createdAt: createdAt,
            updatedAt: updatedAt,
            isSynced: isSynced,
            deleted: deleted,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$UnitsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({subjectId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (subjectId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.subjectId,
                    referencedTable: $$UnitsTableReferences._subjectIdTable(db),
                    referencedColumn:
                        $$UnitsTableReferences._subjectIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$UnitsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UnitsTable,
    Unit,
    $$UnitsTableFilterComposer,
    $$UnitsTableOrderingComposer,
    $$UnitsTableAnnotationComposer,
    $$UnitsTableCreateCompanionBuilder,
    $$UnitsTableUpdateCompanionBuilder,
    (Unit, $$UnitsTableReferences),
    Unit,
    PrefetchHooks Function({bool subjectId})>;
typedef $$LessonsTableCreateCompanionBuilder = LessonsCompanion Function({
  required String id,
  required String title,
  required String content,
  required String unitId,
  Value<int?> order,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  Value<bool> isSynced,
  Value<bool> deleted,
  Value<int> rowid,
});
typedef $$LessonsTableUpdateCompanionBuilder = LessonsCompanion Function({
  Value<String> id,
  Value<String> title,
  Value<String> content,
  Value<String> unitId,
  Value<int?> order,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  Value<bool> isSynced,
  Value<bool> deleted,
  Value<int> rowid,
});

class $$LessonsTableFilterComposer
    extends Composer<_$AppDatabase, $LessonsTable> {
  $$LessonsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unitId => $composableBuilder(
      column: $table.unitId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get order => $composableBuilder(
      column: $table.order, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnFilters(column));
}

class $$LessonsTableOrderingComposer
    extends Composer<_$AppDatabase, $LessonsTable> {
  $$LessonsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unitId => $composableBuilder(
      column: $table.unitId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get order => $composableBuilder(
      column: $table.order, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnOrderings(column));
}

class $$LessonsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LessonsTable> {
  $$LessonsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get unitId =>
      $composableBuilder(column: $table.unitId, builder: (column) => column);

  GeneratedColumn<int> get order =>
      $composableBuilder(column: $table.order, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);
}

class $$LessonsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LessonsTable,
    LessonTable,
    $$LessonsTableFilterComposer,
    $$LessonsTableOrderingComposer,
    $$LessonsTableAnnotationComposer,
    $$LessonsTableCreateCompanionBuilder,
    $$LessonsTableUpdateCompanionBuilder,
    (LessonTable, BaseReferences<_$AppDatabase, $LessonsTable, LessonTable>),
    LessonTable,
    PrefetchHooks Function()> {
  $$LessonsTableTableManager(_$AppDatabase db, $LessonsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LessonsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LessonsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LessonsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<String> unitId = const Value.absent(),
            Value<int?> order = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LessonsCompanion(
            id: id,
            title: title,
            content: content,
            unitId: unitId,
            order: order,
            createdAt: createdAt,
            updatedAt: updatedAt,
            isSynced: isSynced,
            deleted: deleted,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String title,
            required String content,
            required String unitId,
            Value<int?> order = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LessonsCompanion.insert(
            id: id,
            title: title,
            content: content,
            unitId: unitId,
            order: order,
            createdAt: createdAt,
            updatedAt: updatedAt,
            isSynced: isSynced,
            deleted: deleted,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LessonsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LessonsTable,
    LessonTable,
    $$LessonsTableFilterComposer,
    $$LessonsTableOrderingComposer,
    $$LessonsTableAnnotationComposer,
    $$LessonsTableCreateCompanionBuilder,
    $$LessonsTableUpdateCompanionBuilder,
    (LessonTable, BaseReferences<_$AppDatabase, $LessonsTable, LessonTable>),
    LessonTable,
    PrefetchHooks Function()>;
typedef $$QuestionsTableCreateCompanionBuilder = QuestionsCompanion Function({
  required String id,
  required String lessonId,
  required String questionText,
  required String type,
  required String data,
  Value<String?> explanation,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<bool> deleted,
  Value<int?> order,
  Value<bool> isSynced,
  Value<int> rowid,
});
typedef $$QuestionsTableUpdateCompanionBuilder = QuestionsCompanion Function({
  Value<String> id,
  Value<String> lessonId,
  Value<String> questionText,
  Value<String> type,
  Value<String> data,
  Value<String?> explanation,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<bool> deleted,
  Value<int?> order,
  Value<bool> isSynced,
  Value<int> rowid,
});

class $$QuestionsTableFilterComposer
    extends Composer<_$AppDatabase, $QuestionsTable> {
  $$QuestionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lessonId => $composableBuilder(
      column: $table.lessonId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get questionText => $composableBuilder(
      column: $table.questionText, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get data => $composableBuilder(
      column: $table.data, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get explanation => $composableBuilder(
      column: $table.explanation, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get order => $composableBuilder(
      column: $table.order, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnFilters(column));
}

class $$QuestionsTableOrderingComposer
    extends Composer<_$AppDatabase, $QuestionsTable> {
  $$QuestionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lessonId => $composableBuilder(
      column: $table.lessonId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get questionText => $composableBuilder(
      column: $table.questionText,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get data => $composableBuilder(
      column: $table.data, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get explanation => $composableBuilder(
      column: $table.explanation, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get order => $composableBuilder(
      column: $table.order, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnOrderings(column));
}

class $$QuestionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuestionsTable> {
  $$QuestionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get lessonId =>
      $composableBuilder(column: $table.lessonId, builder: (column) => column);

  GeneratedColumn<String> get questionText => $composableBuilder(
      column: $table.questionText, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);

  GeneratedColumn<String> get explanation => $composableBuilder(
      column: $table.explanation, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<int> get order =>
      $composableBuilder(column: $table.order, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);
}

class $$QuestionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $QuestionsTable,
    QuestionTable,
    $$QuestionsTableFilterComposer,
    $$QuestionsTableOrderingComposer,
    $$QuestionsTableAnnotationComposer,
    $$QuestionsTableCreateCompanionBuilder,
    $$QuestionsTableUpdateCompanionBuilder,
    (
      QuestionTable,
      BaseReferences<_$AppDatabase, $QuestionsTable, QuestionTable>
    ),
    QuestionTable,
    PrefetchHooks Function()> {
  $$QuestionsTableTableManager(_$AppDatabase db, $QuestionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuestionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuestionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuestionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> lessonId = const Value.absent(),
            Value<String> questionText = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> data = const Value.absent(),
            Value<String?> explanation = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<int?> order = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              QuestionsCompanion(
            id: id,
            lessonId: lessonId,
            questionText: questionText,
            type: type,
            data: data,
            explanation: explanation,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deleted: deleted,
            order: order,
            isSynced: isSynced,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String lessonId,
            required String questionText,
            required String type,
            required String data,
            Value<String?> explanation = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<int?> order = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              QuestionsCompanion.insert(
            id: id,
            lessonId: lessonId,
            questionText: questionText,
            type: type,
            data: data,
            explanation: explanation,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deleted: deleted,
            order: order,
            isSynced: isSynced,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$QuestionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $QuestionsTable,
    QuestionTable,
    $$QuestionsTableFilterComposer,
    $$QuestionsTableOrderingComposer,
    $$QuestionsTableAnnotationComposer,
    $$QuestionsTableCreateCompanionBuilder,
    $$QuestionsTableUpdateCompanionBuilder,
    (
      QuestionTable,
      BaseReferences<_$AppDatabase, $QuestionsTable, QuestionTable>
    ),
    QuestionTable,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TeachersTableTableManager get teachers =>
      $$TeachersTableTableManager(_db, _db.teachers);
  $$SyncLogsTableTableManager get syncLogs =>
      $$SyncLogsTableTableManager(_db, _db.syncLogs);
  $$GradesTableTableManager get grades =>
      $$GradesTableTableManager(_db, _db.grades);
  $$SemestersTableTableManager get semesters =>
      $$SemestersTableTableManager(_db, _db.semesters);
  $$SubjectsTableTableManager get subjects =>
      $$SubjectsTableTableManager(_db, _db.subjects);
  $$UnitsTableTableManager get units =>
      $$UnitsTableTableManager(_db, _db.units);
  $$LessonsTableTableManager get lessons =>
      $$LessonsTableTableManager(_db, _db.lessons);
  $$QuestionsTableTableManager get questions =>
      $$QuestionsTableTableManager(_db, _db.questions);
}
