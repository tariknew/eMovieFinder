// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_delete_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartDeleteRequest _$CartDeleteRequestFromJson(Map<String, dynamic> json) =>
    CartDeleteRequest(
      cartId: (json['cartId'] as num).toInt(),
      movieId: (json['movieId'] as num).toInt(),
    );

Map<String, dynamic> _$CartDeleteRequestToJson(CartDeleteRequest instance) =>
    <String, dynamic>{
      'cartId': instance.cartId,
      'movieId': instance.movieId,
    };
