import 'package:json_annotation/json_annotation.dart';

part 'cart_delete_request.g.dart';

@JsonSerializable()
class CartDeleteRequest {
  final int cartId;
  final int movieId;

  CartDeleteRequest({
    required this.cartId,
    required this.movieId
  });

  factory CartDeleteRequest.fromJson(Map<String, dynamic> json) => _$CartDeleteRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CartDeleteRequestToJson(this);
}