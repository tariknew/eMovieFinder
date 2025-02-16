// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_favourite_insert_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieFavouriteInsertRequest _$MovieFavouriteInsertRequestFromJson(
        Map<String, dynamic> json) =>
    MovieFavouriteInsertRequest(
      userId: (json['userId'] as num).toInt(),
      movieId: (json['movieId'] as num).toInt(),
    );

Map<String, dynamic> _$MovieFavouriteInsertRequestToJson(
        MovieFavouriteInsertRequest instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'movieId': instance.movieId,
    };
