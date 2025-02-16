// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_search_object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserSearchObject _$UserSearchObjectFromJson(Map<String, dynamic> json) =>
    UserSearchObject(
      pageNumber: (json['pageNumber'] as num?)?.toInt(),
      pageSize: (json['pageSize'] as num?)?.toInt(),
      orderBy: json['orderBy'] as String?,
      isDescending: json['isDescending'] as bool?,
      username: json['username'] as String?,
      isIdentityUserIncluded: json['isIdentityUserIncluded'] as bool?,
    );

Map<String, dynamic> _$UserSearchObjectToJson(UserSearchObject instance) =>
    <String, dynamic>{
      'pageNumber': instance.pageNumber,
      'pageSize': instance.pageSize,
      'orderBy': instance.orderBy,
      'isDescending': instance.isDescending,
      'username': instance.username,
      'isIdentityUserIncluded': instance.isIdentityUserIncluded,
    };
