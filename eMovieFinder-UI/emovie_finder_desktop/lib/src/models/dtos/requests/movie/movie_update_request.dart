import 'package:json_annotation/json_annotation.dart';

part 'movie_update_request.g.dart';

@JsonSerializable()
class MovieUpdateRequest {
  final String? title;
  final DateTime? releaseDate;
  final dynamic duration;
  final int? directorId;
  final List<dynamic>? categories;
  final List<dynamic>? actors;
  final int? countryId;
  final String? trailerLink;
  final String? imagePlainText;
  final String? storyLine;
  final dynamic price;
  final int? movieState;
  final dynamic discount;
  final dynamic averageRating;

  MovieUpdateRequest({
    this.title,
    this.releaseDate,
    this.duration,
    this.directorId,
    this.categories,
    this.actors,
    this.countryId,
    this.trailerLink,
    this.imagePlainText,
    this.storyLine,
    this.price,
    this.movieState,
    this.discount,
    this.averageRating
  });

  factory MovieUpdateRequest.fromJson(Map<String, dynamic> json) => _$MovieUpdateRequestFromJson(json);
  Map<String, dynamic> toJson() => _$MovieUpdateRequestToJson(this);
}