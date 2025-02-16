import 'package:json_annotation/json_annotation.dart';
import 'base_search_object.dart';
part 'director_search_object.g.dart';

@JsonSerializable()
class DirectorSearchObject extends BaseSearchObject {
  DirectorSearchObject({
    super.pageNumber,
    super.pageSize,
    super.orderBy,
    super.isDescending
  });

  factory DirectorSearchObject.fromJson(Map<String, dynamic> json) => _$DirectorSearchObjectFromJson(json);
  Map<String, dynamic> toJson() => _$DirectorSearchObjectToJson(this);
}