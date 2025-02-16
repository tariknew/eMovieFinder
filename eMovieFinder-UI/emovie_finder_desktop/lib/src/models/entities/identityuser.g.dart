// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'identityuser.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IdentityUser _$IdentityUserFromJson(Map<String, dynamic> json) => IdentityUser(
      lockoutEnd: json['lockoutEnd'],
      userName: json['userName'] as String?,
      email: json['email'] as String?,
    );

Map<String, dynamic> _$IdentityUserToJson(IdentityUser instance) =>
    <String, dynamic>{
      'lockoutEnd': instance.lockoutEnd,
      'userName': instance.userName,
      'email': instance.email,
    };
