// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_actor_search_object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieActorSearchObject _$MovieActorSearchObjectFromJson(
        Map<String, dynamic> json) =>
    MovieActorSearchObject(
      pageNumber: (json['pageNumber'] as num?)?.toInt(),
      pageSize: (json['pageSize'] as num?)?.toInt(),
      orderBy: json['orderBy'] as String?,
      isDescending: json['isDescending'] as bool?,
      isMovieIncluded: json['isMovieIncluded'] as bool?,
      isActorIncluded: json['isActorIncluded'] as bool?,
    );

Map<String, dynamic> _$MovieActorSearchObjectToJson(
        MovieActorSearchObject instance) =>
    <String, dynamic>{
      'pageNumber': instance.pageNumber,
      'pageSize': instance.pageSize,
      'orderBy': instance.orderBy,
      'isDescending': instance.isDescending,
      'isMovieIncluded': instance.isMovieIncluded,
      'isActorIncluded': instance.isActorIncluded,
    };
