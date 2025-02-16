import 'package:json_annotation/json_annotation.dart';
import 'base_search_object.dart';
part 'actor_search_object.g.dart';

@JsonSerializable()
class ActorSearchObject extends BaseSearchObject {
  ActorSearchObject({
    super.pageNumber,
    super.pageSize,
    super.orderBy,
    super.isDescending
  });

  factory ActorSearchObject.fromJson(Map<String, dynamic> json) => _$ActorSearchObjectFromJson(json);
  Map<String, dynamic> toJson() => _$ActorSearchObjectToJson(this);
}