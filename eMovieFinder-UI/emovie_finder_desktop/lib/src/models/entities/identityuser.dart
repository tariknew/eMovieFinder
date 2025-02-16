import 'package:json_annotation/json_annotation.dart';

part 'identityuser.g.dart';

@JsonSerializable()
class IdentityUser {
  final dynamic lockoutEnd;
  final String? userName;
  final String? email;

  IdentityUser({
    this.lockoutEnd,
    this.userName,
    this.email
  });

  factory IdentityUser.fromJson(Map<String, dynamic> json) => _$IdentityUserFromJson(json);
  Map<String, dynamic> toJson() => _$IdentityUserToJson(this);
}