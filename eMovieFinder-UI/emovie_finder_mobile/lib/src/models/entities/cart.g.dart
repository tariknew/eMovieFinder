// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cart _$CartFromJson(Map<String, dynamic> json) => Cart(
      creationDate: json['creationDate'] == null
          ? null
          : DateTime.parse(json['creationDate'] as String),
      modifiedDate: json['modifiedDate'] == null
          ? null
          : DateTime.parse(json['modifiedDate'] as String),
      createdById: (json['createdById'] as num?)?.toInt(),
      modifiedById: (json['modifiedById'] as num?)?.toInt(),
      formattedCreationDate: json['formattedCreationDate'] as String?,
      formattedModifiedDate: json['formattedModifiedDate'] as String?,
      id: (json['id'] as num?)?.toInt(),
      userId: (json['userId'] as num?)?.toInt(),
      cartTotalPrice: json['cartTotalPrice'],
      formattedCartTotalPrice: json['formattedCartTotalPrice'] as String?,
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      cartItems: (json['cartItems'] as List<dynamic>?)
          ?.map((e) => CartItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CartToJson(Cart instance) => <String, dynamic>{
      'creationDate': instance.creationDate?.toIso8601String(),
      'modifiedDate': instance.modifiedDate?.toIso8601String(),
      'createdById': instance.createdById,
      'modifiedById': instance.modifiedById,
      'formattedCreationDate': instance.formattedCreationDate,
      'formattedModifiedDate': instance.formattedModifiedDate,
      'id': instance.id,
      'userId': instance.userId,
      'cartTotalPrice': instance.cartTotalPrice,
      'formattedCartTotalPrice': instance.formattedCartTotalPrice,
      'user': instance.user,
      'cartItems': instance.cartItems,
    };
