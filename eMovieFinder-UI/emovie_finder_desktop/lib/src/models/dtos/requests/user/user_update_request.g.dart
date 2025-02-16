// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_update_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserUpdateRequest _$UserUpdateRequestFromJson(Map<String, dynamic> json) =>
    UserUpdateRequest(
      username: json['username'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      roles: json['roles'],
      imagePlainText: json['imagePlainText'] as String?,
      isLockoutEnabled: json['isLockoutEnabled'] as bool?,
    );

Map<String, dynamic> _$UserUpdateRequestToJson(UserUpdateRequest instance) =>
    <String, dynamic>{
      'username': instance.username,
      'email': instance.email,
      'password': instance.password,
      'roles': instance.roles,
      'imagePlainText': instance.imagePlainText,
      'isLockoutEnabled': instance.isLockoutEnabled,
    };
