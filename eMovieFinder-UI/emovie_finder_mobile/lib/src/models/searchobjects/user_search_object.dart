import 'package:json_annotation/json_annotation.dart';

import 'base_search_object.dart';

part 'user_search_object.g.dart';

@JsonSerializable()
class UserSearchObject extends BaseSearchObject {
  final String? username;
  final bool? isIdentityUserIncluded;

  UserSearchObject({
    super.pageNumber,
    super.pageSize,
    super.orderBy,
    super.isDescending,
    this.username,
    this.isIdentityUserIncluded
  });

  factory UserSearchObject.fromJson(Map<String, dynamic> json) => _$UserSearchObjectFromJson(json);
  Map<String, dynamic> toJson() => _$UserSearchObjectToJson(this);
}