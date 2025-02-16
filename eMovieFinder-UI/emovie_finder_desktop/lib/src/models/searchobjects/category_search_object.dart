import 'package:json_annotation/json_annotation.dart';
import 'base_search_object.dart';
part 'category_search_object.g.dart';

@JsonSerializable()
class CategorySearchObject extends BaseSearchObject {
  CategorySearchObject({
    super.pageNumber,
    super.pageSize,
    super.orderBy,
    super.isDescending
  });

  factory CategorySearchObject.fromJson(Map<String, dynamic> json) => _$CategorySearchObjectFromJson(json);
  Map<String, dynamic> toJson() => _$CategorySearchObjectToJson(this);
}