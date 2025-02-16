import 'package:json_annotation/json_annotation.dart';

part 'base_search_object.g.dart';

@JsonSerializable()
class BaseSearchObject {
  final int? pageNumber;
  final int? pageSize;
  final String? orderBy;
  final bool? isDescending;

  BaseSearchObject({
    this.pageNumber,
    this.pageSize,
    this.orderBy,
    this.isDescending,
  });

  factory BaseSearchObject.fromJson(Map<String, dynamic> json) => _$BaseSearchObjectFromJson(json);
  Map<String, dynamic> toJson() => _$BaseSearchObjectToJson(this);
}