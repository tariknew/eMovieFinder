// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_insert_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInsertRequest _$UserInsertRequestFromJson(Map<String, dynamic> json) =>
    UserInsertRequest(
      username: json['username'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      roles: json['roles'],
      imagePlainText: json['imagePlainText'] as String,
    );

Map<String, dynamic> _$UserInsertRequestToJson(UserInsertRequest instance) =>
    <String, dynamic>{
      'username': instance.username,
      'email': instance.email,
      'password': instance.password,
      'roles': instance.roles,
      'imagePlainText': instance.imagePlainText,
    };
