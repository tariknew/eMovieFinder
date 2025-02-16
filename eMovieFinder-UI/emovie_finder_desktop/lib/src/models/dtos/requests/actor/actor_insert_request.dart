import 'package:json_annotation/json_annotation.dart';

part 'actor_insert_request.g.dart';

@JsonSerializable()
class ActorInsertRequest {
  final String firstName;
  final String lastName;
  final String imagePlainText;
  final DateTime? birthDate;
  final int countryId;
  final String imDbLink;
  final String biography;

  ActorInsertRequest({
    required this.firstName,
    required this.lastName,
    required this.imagePlainText,
    required this.birthDate,
    required this.countryId,
    required this.imDbLink,
    required this.biography
  });

  factory ActorInsertRequest.fromJson(Map<String, dynamic> json) => _$ActorInsertRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ActorInsertRequestToJson(this);
}