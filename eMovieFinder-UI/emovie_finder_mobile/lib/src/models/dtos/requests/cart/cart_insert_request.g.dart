// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_insert_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartInsertRequest _$CartInsertRequestFromJson(Map<String, dynamic> json) =>
    CartInsertRequest(
      userId: (json['userId'] as num).toInt(),
      movieId: (json['movieId'] as num).toInt(),
    );

Map<String, dynamic> _$CartInsertRequestToJson(CartInsertRequest instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'movieId': instance.movieId,
    };
