import 'package:json_annotation/json_annotation.dart';

part 'category_insert_request.g.dart';

@JsonSerializable()
class CategoryInsertRequest {
  final String categoryName;

  CategoryInsertRequest({
    required this.categoryName
  });

  factory CategoryInsertRequest.fromJson(Map<String, dynamic> json) => _$CategoryInsertRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryInsertRequestToJson(this);
}