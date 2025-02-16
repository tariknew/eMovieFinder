import 'package:json_annotation/json_annotation.dart';

part 'country_insert_request.g.dart';

@JsonSerializable()
class CountryInsertRequest {
  final String countryName;

  CountryInsertRequest({
    required this.countryName
  });

  factory CountryInsertRequest.fromJson(Map<String, dynamic> json) => _$CountryInsertRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CountryInsertRequestToJson(this);
}