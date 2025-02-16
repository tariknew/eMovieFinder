// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Movie _$MovieFromJson(Map<String, dynamic> json) => Movie(
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
      title: json['title'] as String?,
      releaseDate: json['releaseDate'] == null
          ? null
          : DateTime.parse(json['releaseDate'] as String),
      duration: (json['duration'] as num?)?.toInt(),
      directorId: (json['directorId'] as num?)?.toInt(),
      countryId: (json['countryId'] as num?)?.toInt(),
      trailerLink: json['trailerLink'] as String?,
      image: json['image'],
      storyLine: json['storyLine'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      doubleFinalMoviePrice:
          (json['doubleFinalMoviePrice'] as num?)?.toDouble(),
      discount: json['discount'],
      averageRating: (json['averageRating'] as num?)?.toDouble(),
      movieState: json['movieState'],
      formattedMovieState: json['formattedMovieState'] as String?,
      formattedAverageRating: json['formattedAverageRating'] as String?,
      formattedPrice: json['formattedPrice'] as String?,
      formattedDiscount: json['formattedDiscount'] as String?,
      formattedReleaseDate: json['formattedReleaseDate'] as String?,
      formattedDuration: json['formattedDuration'] as String?,
      categoriesNames: json['categoriesNames'] as String?,
      directorName: json['directorName'] as String?,
      formattedFinalMoviePrice: json['formattedFinalMoviePrice'] as String?,
      director: json['director'] == null
          ? null
          : Director.fromJson(json['director'] as Map<String, dynamic>),
      country: json['country'] == null
          ? null
          : Country.fromJson(json['country'] as Map<String, dynamic>),
      movieCategories: (json['movieCategories'] as List<dynamic>?)
          ?.map((e) => MovieCategory.fromJson(e as Map<String, dynamic>))
          .toList(),
      movieReviews: (json['movieReviews'] as List<dynamic>?)
          ?.map((e) => MovieReview.fromJson(e as Map<String, dynamic>))
          .toList(),
      movieActors: (json['movieActors'] as List<dynamic>?)
          ?.map((e) => MovieActor.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MovieToJson(Movie instance) => <String, dynamic>{
      'creationDate': instance.creationDate?.toIso8601String(),
      'modifiedDate': instance.modifiedDate?.toIso8601String(),
      'createdById': instance.createdById,
      'modifiedById': instance.modifiedById,
      'formattedCreationDate': instance.formattedCreationDate,
      'formattedModifiedDate': instance.formattedModifiedDate,
      'id': instance.id,
      'title': instance.title,
      'releaseDate': instance.releaseDate?.toIso8601String(),
      'duration': instance.duration,
      'directorId': instance.directorId,
      'countryId': instance.countryId,
      'trailerLink': instance.trailerLink,
      'image': instance.image,
      'storyLine': instance.storyLine,
      'price': instance.price,
      'doubleFinalMoviePrice': instance.doubleFinalMoviePrice,
      'discount': instance.discount,
      'averageRating': instance.averageRating,
      'movieState': instance.movieState,
      'formattedMovieState': instance.formattedMovieState,
      'formattedAverageRating': instance.formattedAverageRating,
      'formattedPrice': instance.formattedPrice,
      'formattedDiscount': instance.formattedDiscount,
      'formattedReleaseDate': instance.formattedReleaseDate,
      'formattedDuration': instance.formattedDuration,
      'categoriesNames': instance.categoriesNames,
      'directorName': instance.directorName,
      'formattedFinalMoviePrice': instance.formattedFinalMoviePrice,
      'director': instance.director,
      'country': instance.country,
      'movieCategories': instance.movieCategories,
      'movieReviews': instance.movieReviews,
      'movieActors': instance.movieActors,
    };
