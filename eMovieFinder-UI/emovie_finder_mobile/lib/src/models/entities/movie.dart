import 'package:json_annotation/json_annotation.dart';

import 'package:emovie_finder_mobile/src/models/utilities/time_stamp_object.dart';
import 'country.dart';
import 'director.dart';
import 'movieactor.dart';
import 'moviecategory.dart';
import 'moviereview.dart';

part 'movie.g.dart';

@JsonSerializable()
class Movie extends TimeStampObject {
  final int? id;
  final String? title;
  final DateTime? releaseDate;
  final int? duration;
  final int? directorId;
  final int? countryId;
  final String? trailerLink;
  final dynamic image;
  final String? storyLine;
  final double? price;
  final double? doubleFinalMoviePrice;
  final dynamic discount;
  final double? averageRating;
  final dynamic movieState;
  final String? formattedMovieState;
  final String? formattedAverageRating;
  final String? formattedPrice;
  final String? formattedDiscount;
  final String? formattedReleaseDate;
  final String? formattedDuration;
  final String? categoriesNames;
  final String? directorName;
  final String? formattedFinalMoviePrice;
  final Director? director;
  final Country? country;
  final List<MovieCategory>? movieCategories;
  final List<MovieReview>? movieReviews;
  final List<MovieActor>? movieActors;

  Movie({
    super.creationDate,
    super.modifiedDate,
    super.createdById,
    super.modifiedById,
    super.formattedCreationDate,
    super.formattedModifiedDate,
    this.id,
    this.title,
    this.releaseDate,
    this.duration,
    this.directorId,
    this.countryId,
    this.trailerLink,
    this.image,
    this.storyLine,
    this.price,
    this.doubleFinalMoviePrice,
    this.discount,
    this.averageRating,
    this.movieState,
    this.formattedMovieState,
    this.formattedAverageRating,
    this.formattedPrice,
    this.formattedDiscount,
    this.formattedReleaseDate,
    this.formattedDuration,
    this.categoriesNames,
    this.directorName,
    this.formattedFinalMoviePrice,
    this.director,
    this.country,
    this.movieCategories,
    this.movieReviews,
    this.movieActors
  });

  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);
  Map<String, dynamic> toJson() => _$MovieToJson(this);
}