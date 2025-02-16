import 'package:json_annotation/json_annotation.dart';

part 'user_update_request.g.dart';

@JsonSerializable()
class UserUpdateRequest {
  final String? username;
  final String? email;
  final String? password;
  final dynamic roles;
  final String? imagePlainText;
  final bool? isLockoutEnabled;

  UserUpdateRequest({
    this.username,
    this.email,
    this.password,
    this.roles,
    this.imagePlainText,
    this.isLockoutEnabled
  });

  factory UserUpdateRequest.fromJson(Map<String, dynamic> json) => _$UserUpdateRequestFromJson(json);
  Map<String, dynamic> toJson() => _$UserUpdateRequestToJson(this);
}