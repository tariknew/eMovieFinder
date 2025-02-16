import 'package:json_annotation/json_annotation.dart';

part 'time_stamp_object.g.dart';

@JsonSerializable()
class TimeStampObject{
  final DateTime? creationDate;
  final DateTime? modifiedDate;
  final int? createdById;
  final int? modifiedById;
  final String? formattedCreationDate;
  final String? formattedModifiedDate;

  TimeStampObject({
    this.creationDate,
    this.modifiedDate,
    this.createdById,
    this.modifiedById,
    this.formattedCreationDate,
    this.formattedModifiedDate
  });

  factory TimeStampObject.fromJson(Map<String, dynamic> json) => _$TimeStampObjectFromJson(json);
  Map<String, dynamic> toJson() => _$TimeStampObjectToJson(this);
}