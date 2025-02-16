import 'package:json_annotation/json_annotation.dart';

import 'base_search_object.dart';

part 'cart_search_object.g.dart';

@JsonSerializable()
class CartSearchObject extends BaseSearchObject {
  final int? userId;
  final int? movieId;
  final String? userName;
  final String? movieTitle;
  final bool? isUserIncluded;
  final bool? isCartItemIncluded;

  CartSearchObject({
    super.pageNumber,
    super.pageSize,
    super.orderBy,
    super.isDescending,
    this.userId,
    this.movieId,
    this.userName,
    this.movieTitle,
    this.isUserIncluded,
    this.isCartItemIncluded
  });

  factory CartSearchObject.fromJson(Map<String, dynamic> json) => _$CartSearchObjectFromJson(json);
  Map<String, dynamic> toJson() => _$CartSearchObjectToJson(this);
}