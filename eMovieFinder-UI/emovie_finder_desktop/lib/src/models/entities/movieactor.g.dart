// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movieactor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieActor _$MovieActorFromJson(Map<String, dynamic> json) => MovieActor(
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
      movieId: (json['movieId'] as num?)?.toInt(),
      actorId: (json['actorId'] as num?)?.toInt(),
      characterName: json['characterName'] as String?,
      actor: json['actor'] == null
          ? null
          : Actor.fromJson(json['actor'] as Map<String, dynamic>),
      movieTitle: json['movieTitle'] as String?,
    );

Map<String, dynamic> _$MovieActorToJson(MovieActor instance) =>
    <String, dynamic>{
      'creationDate': instance.creationDate?.toIso8601String(),
      'modifiedDate': instance.modifiedDate?.toIso8601String(),
      'createdById': instance.createdById,
      'modifiedById': instance.modifiedById,
      'formattedCreationDate': instance.formattedCreationDate,
      'formattedModifiedDate': instance.formattedModifiedDate,
      'id': instance.id,
      'movieId': instance.movieId,
      'actorId': instance.actorId,
      'characterName': instance.characterName,
      'actor': instance.actor,
      'movieTitle': instance.movieTitle,
    };
