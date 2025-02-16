// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_search_object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartSearchObject _$CartSearchObjectFromJson(Map<String, dynamic> json) =>
    CartSearchObject(
      pageNumber: (json['pageNumber'] as num?)?.toInt(),
      pageSize: (json['pageSize'] as num?)?.toInt(),
      orderBy: json['orderBy'] as String?,
      isDescending: json['isDescending'] as bool?,
      userId: (json['userId'] as num?)?.toInt(),
      movieId: (json['movieId'] as num?)?.toInt(),
      userName: json['userName'] as String?,
      movieTitle: json['movieTitle'] as String?,
      isUserIncluded: json['isUserIncluded'] as bool?,
      isCartItemIncluded: json['isCartItemIncluded'] as bool?,
    );

Map<String, dynamic> _$CartSearchObjectToJson(CartSearchObject instance) =>
    <String, dynamic>{
      'pageNumber': instance.pageNumber,
      'pageSize': instance.pageSize,
      'orderBy': instance.orderBy,
      'isDescending': instance.isDescending,
      'userId': instance.userId,
      'movieId': instance.movieId,
      'userName': instance.userName,
      'movieTitle': instance.movieTitle,
      'isUserIncluded': instance.isUserIncluded,
      'isCartItemIncluded': instance.isCartItemIncluded,
    };
