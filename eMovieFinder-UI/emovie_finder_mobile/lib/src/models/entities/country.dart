import 'package:json_annotation/json_annotation.dart';

import 'package:emovie_finder_mobile/src/models/utilities/time_stamp_object.dart';

part 'country.g.dart';

@JsonSerializable()
class Country extends TimeStampObject {
  final int? id;
  final String? countryName;

  Country({
    super.creationDate,
    super.modifiedDate,
    super.createdById,
    super.modifiedById,
    super.formattedCreationDate,
    super.formattedModifiedDate,
    this.id,
    this.countryName
  });

  factory Country.fromJson(Map<String, dynamic> json) => _$CountryFromJson(json);
  Map<String, dynamic> toJson() => _$CountryToJson(this);
}