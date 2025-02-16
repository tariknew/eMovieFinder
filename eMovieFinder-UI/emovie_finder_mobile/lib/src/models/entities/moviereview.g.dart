// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moviereview.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieReview _$MovieReviewFromJson(Map<String, dynamic> json) => MovieReview(
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
      rating: (json['rating'] as num?)?.toDouble(),
      comment: json['comment'] as String?,
      userId: (json['userId'] as num?)?.toInt(),
      movieId: (json['movieId'] as num?)?.toInt(),
      formattedAverageRating: json['formattedAverageRating'] as String?,
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MovieReviewToJson(MovieReview instance) =>
    <String, dynamic>{
      'creationDate': instance.creationDate?.toIso8601String(),
      'modifiedDate': instance.modifiedDate?.toIso8601String(),
      'createdById': instance.createdById,
      'modifiedById': instance.modifiedById,
      'formattedCreationDate': instance.formattedCreationDate,
      'formattedModifiedDate': instance.formattedModifiedDate,
      'id': instance.id,
      'rating': instance.rating,
      'comment': instance.comment,
      'userId': instance.userId,
      'movieId': instance.movieId,
      'formattedAverageRating': instance.formattedAverageRating,
      'user': instance.user,
    };
