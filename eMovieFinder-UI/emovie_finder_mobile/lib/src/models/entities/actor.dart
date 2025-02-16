import 'package:json_annotation/json_annotation.dart';

import 'package:emovie_finder_mobile/src/models/utilities/time_stamp_object.dart';
import 'country.dart';

part 'actor.g.dart';

@JsonSerializable()
class Actor extends TimeStampObject {
  final int? id;
  final String? firstName;
  final String? lastName;
  final dynamic image;
  final DateTime? birthDate;
  final int? countryId;
  final String? imDbLink;
  final String? biography;
  final String? formattedActorBirthDate;
  final String? formattedActorBirthPlace;
  final String? formattedActorRealName;
  final Country? country;

  Actor({
    super.creationDate,
    super.modifiedDate,
    super.createdById,
    super.modifiedById,
    super.formattedCreationDate,
    super.formattedModifiedDate,
    this.id,
    this.firstName,
    this.lastName,
    this.image,
    this.birthDate,
    this.countryId,
    this.imDbLink,
    this.biography,
    this.formattedActorBirthDate,
    this.formattedActorBirthPlace,
    this.formattedActorRealName,
    this.country
  });

  factory Actor.fromJson(Map<String, dynamic> json) => _$ActorFromJson(json);
  Map<String, dynamic> toJson() => _$ActorToJson(this);
}