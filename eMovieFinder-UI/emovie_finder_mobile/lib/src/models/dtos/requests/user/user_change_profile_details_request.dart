import 'package:json_annotation/json_annotation.dart';

part 'user_change_profile_details_request.g.dart';

@JsonSerializable()
class UserChangeProfileDetailsRequest {
  final int? identityUserId;
  final String? email;
  final String? currentPassword;
  final String? newPassword;
  final String? imagePlainText;

  UserChangeProfileDetailsRequest({
    this.identityUserId,
    this.email,
    this.currentPassword,
    this.newPassword,
    this.imagePlainText
  });

  factory UserChangeProfileDetailsRequest.fromJson(Map<String, dynamic> json) => _$UserChangeProfileDetailsRequestFromJson(json);
  Map<String, dynamic> toJson() => _$UserChangeProfileDetailsRequestToJson(this);
}