// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_search_object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieSearchObject _$MovieSearchObjectFromJson(Map<String, dynamic> json) =>
    MovieSearchObject(
      pageNumber: (json['pageNumber'] as num?)?.toInt(),
      pageSize: (json['pageSize'] as num?)?.toInt(),
      orderBy: json['orderBy'] as String?,
      isDescending: json['isDescending'] as bool?,
      title: json['title'] as String?,
      categoryId: (json['categoryId'] as num?)?.toInt(),
      priceGTE: (json['priceGTE'] as num?)?.toDouble(),
      priceLTE: (json['priceLTE'] as num?)?.toDouble(),
      isDirectorIncluded: json['isDirectorIncluded'] as bool?,
      isCountryIncluded: json['isCountryIncluded'] as bool?,
      isMovieReviewsIncluded: json['isMovieReviewsIncluded'] as bool?,
      isMovieCategoriesIncluded: json['isMovieCategoriesIncluded'] as bool?,
      isMovieActorsIncluded: json['isMovieActorsIncluded'] as bool?,
      isAdministratorPanel: json['isAdministratorPanel'] as bool?,
    );

Map<String, dynamic> _$MovieSearchObjectToJson(MovieSearchObject instance) =>
    <String, dynamic>{
      'pageNumber': instance.pageNumber,
      'pageSize': instance.pageSize,
      'orderBy': instance.orderBy,
      'isDescending': instance.isDescending,
      'title': instance.title,
      'categoryId': instance.categoryId,
      'priceGTE': instance.priceGTE,
      'priceLTE': instance.priceLTE,
      'isDirectorIncluded': instance.isDirectorIncluded,
      'isCountryIncluded': instance.isCountryIncluded,
      'isMovieReviewsIncluded': instance.isMovieReviewsIncluded,
      'isMovieCategoriesIncluded': instance.isMovieCategoriesIncluded,
      'isMovieActorsIncluded': instance.isMovieActorsIncluded,
      'isAdministratorPanel': instance.isAdministratorPanel,
    };
