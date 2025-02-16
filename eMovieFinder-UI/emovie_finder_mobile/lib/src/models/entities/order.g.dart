// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) => Order(
      id: (json['id'] as num?)?.toInt(),
      userId: (json['userId'] as num?)?.toInt(),
      orderDate: json['orderDate'] == null
          ? null
          : DateTime.parse(json['orderDate'] as String),
      formattedOrderDate: json['formattedOrderDate'] as String?,
      finalMoviePrice: json['finalMoviePrice'] as String?,
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      orderMovies: (json['orderMovies'] as List<dynamic>?)
          ?.map((e) => OrderMovie.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'orderDate': instance.orderDate?.toIso8601String(),
      'formattedOrderDate': instance.formattedOrderDate,
      'finalMoviePrice': instance.finalMoviePrice,
      'user': instance.user,
      'orderMovies': instance.orderMovies,
    };
