// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'time_stamp_object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimeStampObject _$TimeStampObjectFromJson(Map<String, dynamic> json) =>
    TimeStampObject(
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
    );

Map<String, dynamic> _$TimeStampObjectToJson(TimeStampObject instance) =>
    <String, dynamic>{
      'creationDate': instance.creationDate?.toIso8601String(),
      'modifiedDate': instance.modifiedDate?.toIso8601String(),
      'createdById': instance.createdById,
      'modifiedById': instance.modifiedById,
      'formattedCreationDate': instance.formattedCreationDate,
      'formattedModifiedDate': instance.formattedModifiedDate,
    };
