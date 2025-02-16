import 'package:json_annotation/json_annotation.dart';

import 'package:emovie_finder_mobile/src/models/utilities/time_stamp_object.dart';
import 'package:emovie_finder_mobile/src/models/entities/user.dart';
import 'cartitem.dart';

part 'cart.g.dart';

@JsonSerializable()
class Cart extends TimeStampObject {
  final int? id;
  final int? userId;
  final dynamic cartTotalPrice;
  final String? formattedCartTotalPrice;
  final User? user;
  final List<CartItem>? cartItems;

  Cart({
    super.creationDate,
    super.modifiedDate,
    super.createdById,
    super.modifiedById,
    super.formattedCreationDate,
    super.formattedModifiedDate,
    this.id,
    this.userId,
    this.cartTotalPrice,
    this.formattedCartTotalPrice,
    this.user,
    this.cartItems
  });

  factory Cart.fromJson(Map<String, dynamic> json) => _$CartFromJson(json);
  Map<String, dynamic> toJson() => _$CartToJson(this);
}