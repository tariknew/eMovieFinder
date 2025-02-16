import 'package:json_annotation/json_annotation.dart';

import 'package:emovie_finder_mobile/src/models/utilities/time_stamp_object.dart';
import 'package:emovie_finder_mobile/src/models/entities/movie.dart';

part 'cartitem.g.dart';

@JsonSerializable()
class CartItem extends TimeStampObject {
  final int? id;
  final int? cartId;
  final int? movieId;
  final dynamic finalMoviePrice;
  final String? formattedFinalMoviePrice;
  final Movie? movie;

  CartItem({
    super.creationDate,
    super.modifiedDate,
    super.createdById,
    super.modifiedById,
    super.formattedCreationDate,
    super.formattedModifiedDate,
    this.id,
    this.cartId,
    this.movieId,
    this.finalMoviePrice,
    this.formattedFinalMoviePrice,
    this.movie
  });

  factory CartItem.fromJson(Map<String, dynamic> json) => _$CartItemFromJson(json);
  Map<String, dynamic> toJson() => _$CartItemToJson(this);
}