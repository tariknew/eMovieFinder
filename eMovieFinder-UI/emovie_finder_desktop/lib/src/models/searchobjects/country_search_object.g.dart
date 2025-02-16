// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country_search_object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CountrySearchObject _$CountrySearchObjectFromJson(Map<String, dynamic> json) =>
    CountrySearchObject(
      pageNumber: (json['pageNumber'] as num?)?.toInt(),
      pageSize: (json['pageSize'] as num?)?.toInt(),
      orderBy: json['orderBy'] as String?,
      isDescending: json['isDescending'] as bool?,
    );

Map<String, dynamic> _$CountrySearchObjectToJson(
        CountrySearchObject instance) =>
    <String, dynamic>{
      'pageNumber': instance.pageNumber,
      'pageSize': instance.pageSize,
      'orderBy': instance.orderBy,
      'isDescending': instance.isDescending,
    };
