import 'package:json_annotation/json_annotation.dart';

import 'base_search_object.dart';

part 'movie_search_object.g.dart';

@JsonSerializable()
class MovieSearchObject extends BaseSearchObject {
  final String? title;
  final int? categoryId;
  final double? priceGTE;
  final double? priceLTE;
  final bool? isDirectorIncluded;
  final bool? isCountryIncluded;
  final bool? isMovieReviewsIncluded;
  final bool? isMovieCategoriesIncluded;
  final bool? isMovieActorsIncluded;
  final bool? isAdministratorPanel;

  MovieSearchObject({
    super.pageNumber,
    super.pageSize,
    super.orderBy,
    super.isDescending,
    this.title,
    this.categoryId,
    this.priceGTE,
    this.priceLTE,
    this.isDirectorIncluded,
    this.isCountryIncluded,
    this.isMovieReviewsIncluded,
    this.isMovieCategoriesIncluded,
    this.isMovieActorsIncluded,
    this.isAdministratorPanel
  });

  factory MovieSearchObject.fromJson(Map<String, dynamic> json) => _$MovieSearchObjectFromJson(json);
  Map<String, dynamic> toJson() => _$MovieSearchObjectToJson(this);
}