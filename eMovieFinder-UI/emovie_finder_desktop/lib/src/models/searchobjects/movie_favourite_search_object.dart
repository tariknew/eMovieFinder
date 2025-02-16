import 'package:json_annotation/json_annotation.dart';

import 'base_search_object.dart';

part 'movie_favourite_search_object.g.dart';

@JsonSerializable()
class MovieFavouriteSearchObject extends BaseSearchObject {
  final String? movieTitle;
  final int? movieId;
  final int? userId;
  final bool? isUserIncluded;
  final bool? isMovieIncluded;

  MovieFavouriteSearchObject({
    super.pageNumber,
    super.pageSize,
    super.orderBy,
    super.isDescending,
    this.movieTitle,
    this.movieId,
    this.userId,
    this.isUserIncluded,
    this.isMovieIncluded,
  });

  factory MovieFavouriteSearchObject.fromJson(Map<String, dynamic> json) => _$MovieFavouriteSearchObjectFromJson(json);
  Map<String, dynamic> toJson() => _$MovieFavouriteSearchObjectToJson(this);
}