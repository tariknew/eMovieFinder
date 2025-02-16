// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_change_profile_details_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserChangeProfileDetailsRequest _$UserChangeProfileDetailsRequestFromJson(
        Map<String, dynamic> json) =>
    UserChangeProfileDetailsRequest(
      identityUserId: (json['identityUserId'] as num?)?.toInt(),
      email: json['email'] as String?,
      currentPassword: json['currentPassword'] as String?,
      newPassword: json['newPassword'] as String?,
      imagePlainText: json['imagePlainText'] as String?,
    );

Map<String, dynamic> _$UserChangeProfileDetailsRequestToJson(
        UserChangeProfileDetailsRequest instance) =>
    <String, dynamic>{
      'identityUserId': instance.identityUserId,
      'email': instance.email,
      'currentPassword': instance.currentPassword,
      'newPassword': instance.newPassword,
      'imagePlainText': instance.imagePlainText,
    };
