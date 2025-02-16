import 'package:json_annotation/json_annotation.dart';

part 'movie_actor_update_request.g.dart';

@JsonSerializable()
class MovieActorUpdateRequest {
  final int? movieId;
  final int? actorId;
  final String? characterName;

  MovieActorUpdateRequest({
    this.movieId,
    this.actorId,
    this.characterName
  });

  factory MovieActorUpdateRequest.fromJson(Map<String, dynamic> json) => _$MovieActorUpdateRequestFromJson(json);
  Map<String, dynamic> toJson() => _$MovieActorUpdateRequestToJson(this);
}