import 'package:json_annotation/json_annotation.dart';

part 'user_register_request.g.dart';

@JsonSerializable()
class UserRegisterRequest {
  final String username;
  final String email;
  final String password;
  final String confirmPassword;
  final String? imagePlainText;

  UserRegisterRequest({
    required this.username,
    required this.email,
    required this.password,
    required this.confirmPassword,
    this.imagePlainText
  });

  factory UserRegisterRequest.fromJson(Map<String, dynamic> json) => _$UserRegisterRequestFromJson(json);
  Map<String, dynamic> toJson() => _$UserRegisterRequestToJson(this);
}