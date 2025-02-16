import 'package:json_annotation/json_annotation.dart';

part 'movie_review_insert_request.g.dart';

@JsonSerializable()
class MovieReviewInsertRequest {
  final double rating;
  final String comment;
  final int userId;
  final int movieId;

  MovieReviewInsertRequest({
    required this.rating,
    required this.comment,
    required this.userId,
    required this.movieId
  });

  factory MovieReviewInsertRequest.fromJson(Map<String, dynamic> json) => _$MovieReviewInsertRequestFromJson(json);
  Map<String, dynamic> toJson() => _$MovieReviewInsertRequestToJson(this);
}