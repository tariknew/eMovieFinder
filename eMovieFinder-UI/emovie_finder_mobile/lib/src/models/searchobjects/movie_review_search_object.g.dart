// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_review_search_object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieReviewSearchObject _$MovieReviewSearchObjectFromJson(
        Map<String, dynamic> json) =>
    MovieReviewSearchObject(
      pageNumber: (json['pageNumber'] as num?)?.toInt(),
      pageSize: (json['pageSize'] as num?)?.toInt(),
      orderBy: json['orderBy'] as String?,
      isDescending: json['isDescending'] as bool?,
      userId: (json['userId'] as num?)?.toInt(),
      movieId: (json['movieId'] as num?)?.toInt(),
      isUserIncluded: json['isUserIncluded'] as bool?,
      isMovieIncluded: json['isMovieIncluded'] as bool?,
    );

Map<String, dynamic> _$MovieReviewSearchObjectToJson(
        MovieReviewSearchObject instance) =>
    <String, dynamic>{
      'pageNumber': instance.pageNumber,
      'pageSize': instance.pageSize,
      'orderBy': instance.orderBy,
      'isDescending': instance.isDescending,
      'userId': instance.userId,
      'movieId': instance.movieId,
      'isUserIncluded': instance.isUserIncluded,
      'isMovieIncluded': instance.isMovieIncluded,
    };
