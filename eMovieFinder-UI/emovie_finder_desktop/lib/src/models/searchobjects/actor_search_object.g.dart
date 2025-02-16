// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'actor_search_object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActorSearchObject _$ActorSearchObjectFromJson(Map<String, dynamic> json) =>
    ActorSearchObject(
      pageNumber: (json['pageNumber'] as num?)?.toInt(),
      pageSize: (json['pageSize'] as num?)?.toInt(),
      orderBy: json['orderBy'] as String?,
      isDescending: json['isDescending'] as bool?,
    );

Map<String, dynamic> _$ActorSearchObjectToJson(ActorSearchObject instance) =>
    <String, dynamic>{
      'pageNumber': instance.pageNumber,
      'pageSize': instance.pageSize,
      'orderBy': instance.orderBy,
      'isDescending': instance.isDescending,
    };
