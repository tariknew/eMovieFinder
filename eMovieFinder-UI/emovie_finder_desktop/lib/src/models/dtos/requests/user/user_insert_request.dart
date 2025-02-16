import 'package:json_annotation/json_annotation.dart';

part 'user_insert_request.g.dart';

@JsonSerializable()
class UserInsertRequest {
  final String username;
  final String email;
  final String password;
  final dynamic roles;
  final String imagePlainText;

  UserInsertRequest({
    required this.username,
    required this.email,
    required this.password,
    required this.roles,
    required this.imagePlainText
  });

  factory UserInsertRequest.fromJson(Map<String, dynamic> json) => _$UserInsertRequestFromJson(json);
  Map<String, dynamic> toJson() => _$UserInsertRequestToJson(this);
}