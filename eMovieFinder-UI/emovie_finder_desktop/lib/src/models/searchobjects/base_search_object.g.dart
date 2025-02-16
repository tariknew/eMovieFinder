// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_search_object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseSearchObject _$BaseSearchObjectFromJson(Map<String, dynamic> json) =>
    BaseSearchObject(
      pageNumber: (json['pageNumber'] as num?)?.toInt(),
      pageSize: (json['pageSize'] as num?)?.toInt(),
      orderBy: json['orderBy'] as String?,
      isDescending: json['isDescending'] as bool?,
    );

Map<String, dynamic> _$BaseSearchObjectToJson(BaseSearchObject instance) =>
    <String, dynamic>{
      'pageNumber': instance.pageNumber,
      'pageSize': instance.pageSize,
      'orderBy': instance.orderBy,
      'isDescending': instance.isDescending,
    };
