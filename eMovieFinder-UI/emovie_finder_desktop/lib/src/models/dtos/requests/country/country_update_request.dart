import 'package:json_annotation/json_annotation.dart';

part 'country_update_request.g.dart';

@JsonSerializable()
class CountryUpdateRequest {
  final String? countryName;

  CountryUpdateRequest({
    this.countryName
  });

  factory CountryUpdateRequest.fromJson(Map<String, dynamic> json) => _$CountryUpdateRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CountryUpdateRequestToJson(this);
}