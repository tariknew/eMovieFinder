import 'package:json_annotation/json_annotation.dart';

part 'base_response.g.dart';

@JsonSerializable()
class BaseResponseModel {
  final int? statusCode;
  final dynamic data;

  BaseResponseModel({
    this.statusCode,
    this.data,
  });

  factory BaseResponseModel.fromJson(Map<String, dynamic> json) => _$BaseResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$BaseResponseModelToJson(this);
}
