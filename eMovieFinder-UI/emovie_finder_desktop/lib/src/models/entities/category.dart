import 'package:json_annotation/json_annotation.dart';

import '../utilities/time_stamp_object.dart';

part 'category.g.dart';

@JsonSerializable()
class Category extends TimeStampObject {
  final int? id;
  final String? categoryName;

  Category({
    super.creationDate,
    super.modifiedDate,
    super.createdById,
    super.modifiedById,
    super.formattedCreationDate,
    super.formattedModifiedDate,
    this.id,
    this.categoryName
  });

  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}