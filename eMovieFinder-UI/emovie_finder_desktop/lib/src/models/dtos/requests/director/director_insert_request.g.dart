// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'director_insert_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DirectorInsertRequest _$DirectorInsertRequestFromJson(
        Map<String, dynamic> json) =>
    DirectorInsertRequest(
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      birthDate: json['birthDate'] == null
          ? null
          : DateTime.parse(json['birthDate'] as String),
    );

Map<String, dynamic> _$DirectorInsertRequestToJson(
        DirectorInsertRequest instance) =>
    <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'birthDate': instance.birthDate?.toIso8601String(),
    };
