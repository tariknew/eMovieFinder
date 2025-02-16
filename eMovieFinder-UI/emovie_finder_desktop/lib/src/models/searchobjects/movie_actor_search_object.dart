import 'package:json_annotation/json_annotation.dart';
import 'base_search_object.dart';
part 'movie_actor_search_object.g.dart';

@JsonSerializable()
class MovieActorSearchObject extends BaseSearchObject {
  final bool? isMovieIncluded;
  final bool? isActorIncluded;

  MovieActorSearchObject({
    super.pageNumber,
    super.pageSize,
    super.orderBy,
    super.isDescending,
    this.isMovieIncluded,
    this.isActorIncluded
  });

  factory MovieActorSearchObject.fromJson(Map<String, dynamic> json) => _$MovieActorSearchObjectFromJson(json);
  Map<String, dynamic> toJson() => _$MovieActorSearchObjectToJson(this);
}