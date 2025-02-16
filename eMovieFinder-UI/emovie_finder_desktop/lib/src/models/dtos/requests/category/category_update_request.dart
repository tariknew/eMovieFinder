import 'package:json_annotation/json_annotation.dart';

part 'category_update_request.g.dart';

@JsonSerializable()
class CategoryUpdateRequest {
  final String? categoryName;

  CategoryUpdateRequest({
    this.categoryName
  });

  factory CategoryUpdateRequest.fromJson(Map<String, dynamic> json) => _$CategoryUpdateRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryUpdateRequestToJson(this);
}