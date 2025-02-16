// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_review_insert_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieReviewInsertRequest _$MovieReviewInsertRequestFromJson(
        Map<String, dynamic> json) =>
    MovieReviewInsertRequest(
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'] as String,
      userId: (json['userId'] as num).toInt(),
      movieId: (json['movieId'] as num).toInt(),
    );

Map<String, dynamic> _$MovieReviewInsertRequestToJson(
        MovieReviewInsertRequest instance) =>
    <String, dynamic>{
      'rating': instance.rating,
      'comment': instance.comment,
      'userId': instance.userId,
      'movieId': instance.movieId,
    };
