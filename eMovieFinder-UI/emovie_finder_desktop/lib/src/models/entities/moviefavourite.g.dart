// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moviefavourite.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieFavourite _$MovieFavouriteFromJson(Map<String, dynamic> json) =>
    MovieFavourite(
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
      userId: (json['userId'] as num?)?.toInt(),
      movieId: (json['movieId'] as num?)?.toInt(),
      movie: json['movie'] == null
          ? null
          : Movie.fromJson(json['movie'] as Map<String, dynamic>),
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MovieFavouriteToJson(MovieFavourite instance) =>
    <String, dynamic>{
      'creationDate': instance.creationDate?.toIso8601String(),
      'modifiedDate': instance.modifiedDate?.toIso8601String(),
      'createdById': instance.createdById,
      'modifiedById': instance.modifiedById,
      'formattedCreationDate': instance.formattedCreationDate,
      'formattedModifiedDate': instance.formattedModifiedDate,
      'id': instance.id,
      'userId': instance.userId,
      'movieId': instance.movieId,
      'movie': instance.movie,
      'user': instance.user,
    };
