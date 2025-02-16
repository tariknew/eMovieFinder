import 'package:json_annotation/json_annotation.dart';
import 'base_search_object.dart';
part 'country_search_object.g.dart';

@JsonSerializable()
class CountrySearchObject extends BaseSearchObject {
  CountrySearchObject({
    super.pageNumber,
    super.pageSize,
    super.orderBy,
    super.isDescending
  });

  factory CountrySearchObject.fromJson(Map<String, dynamic> json) => _$CountrySearchObjectFromJson(json);
  Map<String, dynamic> toJson() => _$CountrySearchObjectToJson(this);
}