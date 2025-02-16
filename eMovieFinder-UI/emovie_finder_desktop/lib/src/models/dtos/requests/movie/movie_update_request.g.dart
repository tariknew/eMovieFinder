// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_update_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieUpdateRequest _$MovieUpdateRequestFromJson(Map<String, dynamic> json) =>
    MovieUpdateRequest(
      title: json['title'] as String?,
      releaseDate: json['releaseDate'] == null
          ? null
          : DateTime.parse(json['releaseDate'] as String),
      duration: json['duration'],
      directorId: (json['directorId'] as num?)?.toInt(),
      categories: json['categories'] as List<dynamic>?,
      actors: json['actors'] as List<dynamic>?,
      countryId: (json['countryId'] as num?)?.toInt(),
      trailerLink: json['trailerLink'] as String?,
      imagePlainText: json['imagePlainText'] as String?,
      storyLine: json['storyLine'] as String?,
      price: json['price'],
      movieState: (json['movieState'] as num?)?.toInt(),
      discount: json['discount'],
      averageRating: json['averageRating'],
    );

Map<String, dynamic> _$MovieUpdateRequestToJson(MovieUpdateRequest instance) =>
    <String, dynamic>{
      'title': instance.title,
      'releaseDate': instance.releaseDate?.toIso8601String(),
      'duration': instance.duration,
      'directorId': instance.directorId,
      'categories': instance.categories,
      'actors': instance.actors,
      'countryId': instance.countryId,
      'trailerLink': instance.trailerLink,
      'imagePlainText': instance.imagePlainText,
      'storyLine': instance.storyLine,
      'price': instance.price,
      'movieState': instance.movieState,
      'discount': instance.discount,
      'averageRating': instance.averageRating,
    };
