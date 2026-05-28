// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authenticated_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthenticatedUser _$AuthenticatedUserFromJson(Map<String, dynamic> json) =>
    _AuthenticatedUser(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      role: $enumDecode(_$UserRoleEnumMap, json['role']),
      token: json['token'] as String,
    );

Map<String, dynamic> _$AuthenticatedUserToJson(_AuthenticatedUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'role': _$UserRoleEnumMap[instance.role]!,
      'token': instance.token,
    };

const _$UserRoleEnumMap = {
  UserRole.admin: 'admin',
  UserRole.stage1: 'stage1',
  UserRole.stage2: 'stage2',
  UserRole.stage3: 'stage3',
  UserRole.stage4: 'stage4',
  UserRole.stage5: 'stage5',
};
