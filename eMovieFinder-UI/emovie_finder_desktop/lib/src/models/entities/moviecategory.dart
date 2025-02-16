import 'package:json_annotation/json_annotation.dart';

import '../utilities/time_stamp_object.dart';
import 'category.dart';

part 'moviecategory.g.dart';

@JsonSerializable()
class MovieCategory extends TimeStampObject {
  final int? id;
  final int? movieId;
  final int? categoryId;
  final Category? category;

  MovieCategory({
    super.creationDate,
    super.modifiedDate,
    super.createdById,
    super.modifiedById,
    super.formattedCreationDate,
    super.formattedModifiedDate,
    this.id,
    this.movieId,
    this.categoryId,
    this.category
  });

  factory MovieCategory.fromJson(Map<String, dynamic> json) => _$MovieCategoryFromJson(json);
  Map<String, dynamic> toJson() => _$MovieCategoryToJson(this);
}