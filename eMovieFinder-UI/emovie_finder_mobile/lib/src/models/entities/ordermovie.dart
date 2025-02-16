import 'package:json_annotation/json_annotation.dart';

import 'movie.dart';

part 'ordermovie.g.dart';

@JsonSerializable()
class OrderMovie {
  final int? id;
  final int? orderId;
  final int? movieId;
  final String? formattedFinalMoviePrice;
  final String? formattedMovieTitle;
  final Movie? movie;

  OrderMovie({
    this.id,
    this.orderId,
    this.movieId,
    this.formattedFinalMoviePrice,
    this.formattedMovieTitle,
    this.movie
  });

  factory OrderMovie.fromJson(Map<String, dynamic> json) => _$OrderMovieFromJson(json);
  Map<String, dynamic> toJson() => _$OrderMovieToJson(this);
}