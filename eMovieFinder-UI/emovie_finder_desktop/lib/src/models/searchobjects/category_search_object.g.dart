// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_search_object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategorySearchObject _$CategorySearchObjectFromJson(
        Map<String, dynamic> json) =>
    CategorySearchObject(
      pageNumber: (json['pageNumber'] as num?)?.toInt(),
      pageSize: (json['pageSize'] as num?)?.toInt(),
      orderBy: json['orderBy'] as String?,
      isDescending: json['isDescending'] as bool?,
    );

Map<String, dynamic> _$CategorySearchObjectToJson(
        CategorySearchObject instance) =>
    <String, dynamic>{
      'pageNumber': instance.pageNumber,
      'pageSize': instance.pageSize,
      'orderBy': instance.orderBy,
      'isDescending': instance.isDescending,
    };
