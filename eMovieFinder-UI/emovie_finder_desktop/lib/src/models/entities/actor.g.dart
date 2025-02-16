// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'actor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Actor _$ActorFromJson(Map<String, dynamic> json) => Actor(
      creationDate: json['creationDate'] == null
          ? null
          : DateTime.parse(json['creationDate'] as String),
      modifiedDate: json['modifiedDate'] == null
          ? null
          : DateTime.parse(json['modifiedDate'] as String),
      createdById: (json['createdById'] as num?)?.toInt(),
      modifiedById: (json['modifiedById'] as num?)?.toInt(),
      formattedCreationDate: json['formattedCreationDate'] as String?,
      formattedModifiedDate: json['formattedModifiedDate'] as String?,
      id: (json['id'] as num?)?.toInt(),
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      image: json['image'],
      birthDate: json['birthDate'] == null
          ? null
          : DateTime.parse(json['birthDate'] as String),
      countryId: (json['countryId'] as num?)?.toInt(),
      imDbLink: json['imDbLink'] as String?,
      biography: json['biography'] as String?,
      formattedActorBirthDate: json['formattedActorBirthDate'] as String?,
      formattedActorBirthPlace: json['formattedActorBirthPlace'] as String?,
      formattedActorRealName: json['formattedActorRealName'] as String?,
      country: json['country'] == null
          ? null
          : Country.fromJson(json['country'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ActorToJson(Actor instance) => <String, dynamic>{
      'creationDate': instance.creationDate?.toIso8601String(),
      'modifiedDate': instance.modifiedDate?.toIso8601String(),
      'createdById': instance.createdById,
      'modifiedById': instance.modifiedById,
      'formattedCreationDate': instance.formattedCreationDate,
      'formattedModifiedDate': instance.formattedModifiedDate,
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'image': instance.image,
      'birthDate': instance.birthDate?.toIso8601String(),
      'countryId': instance.countryId,
      'imDbLink': instance.imDbLink,
      'biography': instance.biography,
      'formattedActorBirthDate': instance.formattedActorBirthDate,
      'formattedActorBirthPlace': instance.formattedActorBirthPlace,
      'formattedActorRealName': instance.formattedActorRealName,
      'country': instance.country,
    };
