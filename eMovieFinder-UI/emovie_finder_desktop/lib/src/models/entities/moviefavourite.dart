import 'package:json_annotation/json_annotation.dart';
import '../utilities/time_stamp_object.dart';
import 'movie.dart';
import 'user.dart';

part 'moviefavourite.g.dart';

@JsonSerializable()
class MovieFavourite extends TimeStampObject {
  final int? id;
  final int? userId;
  final int? movieId;
  final Movie? movie;
  final User? user;

  MovieFavourite({
    super.creationDate,
    super.modifiedDate,
    super.createdById,
    super.modifiedById,
    super.formattedCreationDate,
    super.formattedModifiedDate,
    this.id,
    this.userId,
    this.movieId,
    this.movie,
    this.user
  });

  factory MovieFavourite.fromJson(Map<String, dynamic> json) => _$MovieFavouriteFromJson(json);
  Map<String, dynamic> toJson() => _$MovieFavouriteToJson(this);
}