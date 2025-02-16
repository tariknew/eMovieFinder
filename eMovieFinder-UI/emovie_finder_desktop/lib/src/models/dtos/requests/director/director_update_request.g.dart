// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'director_update_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DirectorUpdateRequest _$DirectorUpdateRequestFromJson(
        Map<String, dynamic> json) =>
    DirectorUpdateRequest(
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      birthDate: json['birthDate'] == null
          ? null
          : DateTime.parse(json['birthDate'] as String),
    );

Map<String, dynamic> _$DirectorUpdateRequestToJson(
        DirectorUpdateRequest instance) =>
    <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'birthDate': instance.birthDate?.toIso8601String(),
    };
