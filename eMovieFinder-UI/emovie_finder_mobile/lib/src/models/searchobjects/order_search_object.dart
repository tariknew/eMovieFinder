import 'package:json_annotation/json_annotation.dart';

import 'base_search_object.dart';

part 'order_search_object.g.dart';

@JsonSerializable()
class OrderSearchObject extends BaseSearchObject {
  final int? userId;
  final bool? isUserIncluded;
  final bool? isOrderMovieIncluded;

  OrderSearchObject({
    super.pageNumber,
    super.pageSize,
    super.orderBy,
    super.isDescending,
    this.userId,
    this.isUserIncluded,
    this.isOrderMovieIncluded
  });

  factory OrderSearchObject.fromJson(Map<String, dynamic> json) => _$OrderSearchObjectFromJson(json);
  Map<String, dynamic> toJson() => _$OrderSearchObjectToJson(this);
}