// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'actor_insert_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActorInsertRequest _$ActorInsertRequestFromJson(Map<String, dynamic> json) =>
    ActorInsertRequest(
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      imagePlainText: json['imagePlainText'] as String,
      birthDate: json['birthDate'] == null
          ? null
          : DateTime.parse(json['birthDate'] as String),
      countryId: (json['countryId'] as num).toInt(),
      imDbLink: json['imDbLink'] as String,
      biography: json['biography'] as String,
    );

Map<String, dynamic> _$ActorInsertRequestToJson(ActorInsertRequest instance) =>
    <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'imagePlainText': instance.imagePlainText,
      'birthDate': instance.birthDate?.toIso8601String(),
      'countryId': instance.countryId,
      'imDbLink': instance.imDbLink,
      'biography': instance.biography,
    };
