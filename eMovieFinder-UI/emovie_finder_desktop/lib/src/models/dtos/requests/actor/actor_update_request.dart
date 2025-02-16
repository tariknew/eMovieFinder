import 'package:json_annotation/json_annotation.dart';

part 'actor_update_request.g.dart';

@JsonSerializable()
class ActorUpdateRequest {
  final String? firstName;
  final String? lastName;
  final String? imagePlainText;
  final DateTime? birthDate;
  final int? countryId;
  final String? imDbLink;
  final String? biography;

  ActorUpdateRequest({
    this.firstName,
    this.lastName,
    this.imagePlainText,
    this.birthDate,
    this.countryId,
    this.imDbLink,
    this.biography
  });

  factory ActorUpdateRequest.fromJson(Map<String, dynamic> json) => _$ActorUpdateRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ActorUpdateRequestToJson(this);
}