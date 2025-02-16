// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'director_search_object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DirectorSearchObject _$DirectorSearchObjectFromJson(
        Map<String, dynamic> json) =>
    DirectorSearchObject(
      pageNumber: (json['pageNumber'] as num?)?.toInt(),
      pageSize: (json['pageSize'] as num?)?.toInt(),
      orderBy: json['orderBy'] as String?,
      isDescending: json['isDescending'] as bool?,
    );

Map<String, dynamic> _$DirectorSearchObjectToJson(
        DirectorSearchObject instance) =>
    <String, dynamic>{
      'pageNumber': instance.pageNumber,
      'pageSize': instance.pageSize,
      'orderBy': instance.orderBy,
      'isDescending': instance.isDescending,
    };
