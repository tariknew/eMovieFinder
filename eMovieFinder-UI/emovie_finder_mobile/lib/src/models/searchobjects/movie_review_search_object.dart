import 'package:json_annotation/json_annotation.dart';

import 'base_search_object.dart';

part 'movie_review_search_object.g.dart';

@JsonSerializable()
class MovieReviewSearchObject extends BaseSearchObject {
  final int? userId;
  final int? movieId;
  final bool? isUserIncluded;
  final bool? isMovieIncluded;

  MovieReviewSearchObject({
    super.pageNumber,
    super.pageSize,
    super.orderBy,
    super.isDescending,
    this.userId,
    this.movieId,
    this.isUserIncluded,
    this.isMovieIncluded,
  });

  factory MovieReviewSearchObject.fromJson(Map<String, dynamic> json) => _$MovieReviewSearchObjectFromJson(json);
  Map<String, dynamic> toJson() => _$MovieReviewSearchObjectToJson(this);
}