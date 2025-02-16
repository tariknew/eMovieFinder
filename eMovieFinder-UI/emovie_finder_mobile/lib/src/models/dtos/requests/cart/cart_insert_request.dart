import 'package:json_annotation/json_annotation.dart';

part 'cart_insert_request.g.dart';

@JsonSerializable()
class CartInsertRequest {
  final int userId;
  final int movieId;

  CartInsertRequest({
    required this.userId,
    required this.movieId
  });

  factory CartInsertRequest.fromJson(Map<String, dynamic> json) => _$CartInsertRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CartInsertRequestToJson(this);
}