import 'package:json_annotation/json_annotation.dart';

part 'movie_favourite_insert_request.g.dart';

@JsonSerializable()
class MovieFavouriteInsertRequest {
  final int userId;
  final int movieId;

  MovieFavouriteInsertRequest({
    required this.userId,
    required this.movieId
  });

  factory MovieFavouriteInsertRequest.fromJson(Map<String, dynamic> json) => _$MovieFavouriteInsertRequestFromJson(json);
  Map<String, dynamic> toJson() => _$MovieFavouriteInsertRequestToJson(this);
}