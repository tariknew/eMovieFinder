import 'package:json_annotation/json_annotation.dart';

import 'package:emovie_finder_mobile/src/models/entities/user.dart';
import 'ordermovie.dart';

part 'order.g.dart';

@JsonSerializable()
class Order {
  final int? id;
  final int? userId;
  final DateTime? orderDate;
  final String? formattedOrderDate;
  final String? finalMoviePrice;
  final User? user;
  final List<OrderMovie>? orderMovies;

  Order({
    this.id,
    this.userId,
    this.orderDate,
    this.formattedOrderDate,
    this.finalMoviePrice,
    this.user,
    this.orderMovies
  });

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
  Map<String, dynamic> toJson() => _$OrderToJson(this);
}