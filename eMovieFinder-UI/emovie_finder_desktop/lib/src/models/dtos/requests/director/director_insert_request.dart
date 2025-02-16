import 'package:json_annotation/json_annotation.dart';

part 'director_insert_request.g.dart';

@JsonSerializable()
class DirectorInsertRequest {
  final String firstName;
  final String lastName;
  final DateTime? birthDate;

  DirectorInsertRequest({
    required this.firstName,
    required this.lastName,
    this.birthDate
  });

  factory DirectorInsertRequest.fromJson(Map<String, dynamic> json) => _$DirectorInsertRequestFromJson(json);
  Map<String, dynamic> toJson() => _$DirectorInsertRequestToJson(this);
}