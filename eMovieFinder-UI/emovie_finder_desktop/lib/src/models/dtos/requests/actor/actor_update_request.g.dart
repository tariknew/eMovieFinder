// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'actor_update_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActorUpdateRequest _$ActorUpdateRequestFromJson(Map<String, dynamic> json) =>
    ActorUpdateRequest(
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      imagePlainText: json['imagePlainText'] as String?,
      birthDate: json['birthDate'] == null
          ? null
          : DateTime.parse(json['birthDate'] as String),
      countryId: (json['countryId'] as num?)?.toInt(),
      imDbLink: json['imDbLink'] as String?,
      biography: json['biography'] as String?,
    );

Map<String, dynamic> _$ActorUpdateRequestToJson(ActorUpdateRequest instance) =>
    <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'imagePlainText': instance.imagePlainText,
      'birthDate': instance.birthDate?.toIso8601String(),
      'countryId': instance.countryId,
      'imDbLink': instance.imDbLink,
      'biography': instance.biography,
    };
