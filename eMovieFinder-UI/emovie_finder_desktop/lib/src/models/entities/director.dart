import 'package:json_annotation/json_annotation.dart';

import '../utilities/time_stamp_object.dart';

part 'director.g.dart';

@JsonSerializable()
class Director extends TimeStampObject {
  final int? id;
  final String? firstName;
  final String? lastName;
  final DateTime? birthDate;
  final String? formattedDirectorRealName;

  Director({
    super.creationDate,
    super.modifiedDate,
    super.createdById,
    super.modifiedById,
    super.formattedCreationDate,
    super.formattedModifiedDate,
    this.id,
    this.firstName,
    this.lastName,
    this.birthDate,
    this.formattedDirectorRealName
  });

  factory Director.fromJson(Map<String, dynamic> json) => _$DirectorFromJson(json);
  Map<String, dynamic> toJson() => _$DirectorToJson(this);
}