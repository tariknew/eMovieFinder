// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_actor_update_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieActorUpdateRequest _$MovieActorUpdateRequestFromJson(
        Map<String, dynamic> json) =>
    MovieActorUpdateRequest(
      movieId: (json['movieId'] as num?)?.toInt(),
      actorId: (json['actorId'] as num?)?.toInt(),
      characterName: json['characterName'] as String?,
    );

Map<String, dynamic> _$MovieActorUpdateRequestToJson(
        MovieActorUpdateRequest instance) =>
    <String, dynamic>{
      'movieId': instance.movieId,
      'actorId': instance.actorId,
      'characterName': instance.characterName,
    };
