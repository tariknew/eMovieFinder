import 'package:json_annotation/json_annotation.dart';

import '../utilities/time_stamp_object.dart';

part 'moviereview.g.dart';

@JsonSerializable()
class MovieReview extends TimeStampObject {
  final int? id;
  final double? rating;
  final String? comment;
  final int? userId;
  final int? movieId;
  final String? formattedAverageRating;

  MovieReview({
    super.creationDate,
    super.modifiedDate,
    super.createdById,
    super.modifiedById,
    super.formattedCreationDate,
    super.formattedModifiedDate,
    this.id,
    this.rating,
    this.comment,
    this.userId,
    this.movieId,
    this.formattedAverageRating
  });

  factory MovieReview.fromJson(Map<String, dynamic> json) => _$MovieReviewFromJson(json);
  Map<String, dynamic> toJson() => _$MovieReviewToJson(this);
}