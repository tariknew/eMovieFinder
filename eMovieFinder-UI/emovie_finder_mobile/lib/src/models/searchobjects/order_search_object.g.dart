// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_search_object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderSearchObject _$OrderSearchObjectFromJson(Map<String, dynamic> json) =>
    OrderSearchObject(
      pageNumber: (json['pageNumber'] as num?)?.toInt(),
      pageSize: (json['pageSize'] as num?)?.toInt(),
      orderBy: json['orderBy'] as String?,
      isDescending: json['isDescending'] as bool?,
      userId: (json['userId'] as num?)?.toInt(),
      isUserIncluded: json['isUserIncluded'] as bool?,
      isOrderMovieIncluded: json['isOrderMovieIncluded'] as bool?,
    );

Map<String, dynamic> _$OrderSearchObjectToJson(OrderSearchObject instance) =>
    <String, dynamic>{
      'pageNumber': instance.pageNumber,
      'pageSize': instance.pageSize,
      'orderBy': instance.orderBy,
      'isDescending': instance.isDescending,
      'userId': instance.userId,
      'isUserIncluded': instance.isUserIncluded,
      'isOrderMovieIncluded': instance.isOrderMovieIncluded,
    };
