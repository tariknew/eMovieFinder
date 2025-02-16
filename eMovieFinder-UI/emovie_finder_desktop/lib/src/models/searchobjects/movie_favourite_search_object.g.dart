// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_favourite_search_object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieFavouriteSearchObject _$MovieFavouriteSearchObjectFromJson(
        Map<String, dynamic> json) =>
    MovieFavouriteSearchObject(
      pageNumber: (json['pageNumber'] as num?)?.toInt(),
      pageSize: (json['pageSize'] as num?)?.toInt(),
      orderBy: json['orderBy'] as String?,
      isDescending: json['isDescending'] as bool?,
      movieTitle: json['movieTitle'] as String?,
      movieId: (json['movieId'] as num?)?.toInt(),
      userId: (json['userId'] as num?)?.toInt(),
      isUserIncluded: json['isUserIncluded'] as bool?,
      isMovieIncluded: json['isMovieIncluded'] as bool?,
    );

Map<String, dynamic> _$MovieFavouriteSearchObjectToJson(
        MovieFavouriteSearchObject instance) =>
    <String, dynamic>{
      'pageNumber': instance.pageNumber,
      'pageSize': instance.pageSize,
      'orderBy': instance.orderBy,
      'isDescending': instance.isDescending,
      'movieTitle': instance.movieTitle,
      'movieId': instance.movieId,
      'userId': instance.userId,
      'isUserIncluded': instance.isUserIncluded,
      'isMovieIncluded': instance.isMovieIncluded,
    };
