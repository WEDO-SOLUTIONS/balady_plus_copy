import 'package:json_annotation/json_annotation.dart';

part 'search_region.g.dart';

@JsonSerializable()
class SearchRegion {
  final String id;
  final String name;
  final String type;
  final String? country;
  final String? countryId;
  final String? region;
  final String? regionId;
  final String? city;
  final String? cityId;
  final String? timeZone;

  const SearchRegion({
    required this.id,
    required this.name,
    required this.type,
    this.country,
    this.countryId,
    this.region,
    this.regionId,
    this.city,
    this.cityId,
    this.timeZone,
  });

  factory SearchRegion.fromJson(Map<String, dynamic> json) => _$SearchRegionFromJson(json);

  Map<String, dynamic> toJson() => _$SearchRegionToJson(this);
}

@JsonSerializable()
class SearchRegionResponse {
  final List<SearchRegion> items;
  final int total;

  const SearchRegionResponse({
    required this.items,
    required this.total,
  });

  factory SearchRegionResponse.fromJson(Map<String, dynamic> json) => _$SearchRegionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SearchRegionResponseToJson(this);
}
