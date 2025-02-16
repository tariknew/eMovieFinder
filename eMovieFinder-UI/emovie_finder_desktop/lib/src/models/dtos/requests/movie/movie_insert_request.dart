import 'package:json_annotation/json_annotation.dart';

part 'movie_insert_request.g.dart';

@JsonSerializable()
class MovieInsertRequest {
  final String title;
  final DateTime? releaseDate;
  final dynamic duration;
  final int directorId;
  final List<dynamic> categories;
  final List<dynamic> actors;
  final int countryId;
  final String trailerLink;
  final String imagePlainText;
  final String storyLine;
  final dynamic price;
  final int movieState;
  final dynamic discount;

  MovieInsertRequest({
    required this.title,
    this.releaseDate,
    required this.duration,
    required this.directorId,
    required this.categories,
    required this.actors,
    required this.countryId,
    required this.trailerLink,
    required this.imagePlainText,
    required this.storyLine,
    required this.price,
    required this.movieState,
    required this.discount,
  });

  factory MovieInsertRequest.fromJson(Map<String, dynamic> json) => _$MovieInsertRequestFromJson(json);
  Map<String, dynamic> toJson() => _$MovieInsertRequestToJson(this);
}