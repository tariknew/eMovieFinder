import 'package:json_annotation/json_annotation.dart';

part 'director_update_request.g.dart';

@JsonSerializable()
class DirectorUpdateRequest {
  final String? firstName;
  final String? lastName;
  final DateTime? birthDate;

  DirectorUpdateRequest({
    this.firstName,
    this.lastName,
    this.birthDate
  });

  factory DirectorUpdateRequest.fromJson(Map<String, dynamic> json) => _$DirectorUpdateRequestFromJson(json);
  Map<String, dynamic> toJson() => _$DirectorUpdateRequestToJson(this);
}