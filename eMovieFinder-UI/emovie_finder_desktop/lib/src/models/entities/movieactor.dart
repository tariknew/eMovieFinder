import 'package:json_annotation/json_annotation.dart';

import '../utilities/time_stamp_object.dart';
import 'actor.dart';

part 'movieactor.g.dart';

@JsonSerializable()
class MovieActor extends TimeStampObject {
  final int? id;
  final int? movieId;
  final int? actorId;
  final String? characterName;
  final Actor? actor;
  final String? movieTitle;

  MovieActor({
    super.creationDate,
    super.modifiedDate,
    super.createdById,
    super.modifiedById,
    super.formattedCreationDate,
    super.formattedModifiedDate,
    this.id,
    this.movieId,
    this.actorId,
    this.characterName,
    this.actor,
    this.movieTitle
  });

  factory MovieActor.fromJson(Map<String, dynamic> json) => _$MovieActorFromJson(json);
  Map<String, dynamic> toJson() => _$MovieActorToJson(this);
}