import 'package:json_annotation/json_annotation.dart';

import '../utilities/time_stamp_object.dart';
import 'identityuser.dart';

part 'user.g.dart';

@JsonSerializable()
class User extends TimeStampObject {
  final int? id;
  final dynamic image;
  final int? identityUserId;
  final String? username;
  final String? email;
  final String? combinedRoles;
  final IdentityUser? identityUser;

  User({
    super.creationDate,
    super.modifiedDate,
    super.createdById,
    super.modifiedById,
    super.formattedCreationDate,
    super.formattedModifiedDate,
    this.id,
    this.image,
    this.identityUserId,
    this.username,
    this.email,
    this.combinedRoles,
    this.identityUser
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}