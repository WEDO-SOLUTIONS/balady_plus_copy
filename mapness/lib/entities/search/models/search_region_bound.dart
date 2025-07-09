import 'package:json_annotation/json_annotation.dart';

part 'search_region_bound.g.dart';

@JsonSerializable()
class SearchRegionPolygon {
  final String id;
  final String type;
  final String name;
  final List<Coordinate>? polygon;

  const SearchRegionPolygon({
    required this.id,
    required this.type,
    required this.name,
    this.polygon,
  });

  factory SearchRegionPolygon.fromJson(Map<String, dynamic> json) => _$SearchRegionPolygonFromJson(json);

  Map<String, dynamic> toJson() => _$SearchRegionPolygonToJson(this);
}

@JsonSerializable()
class Coordinate {
  final double lat;
  final double lng;

  const Coordinate({
    required this.lat,
    required this.lng,
  });

  factory Coordinate.fromJson(Map<String, dynamic> json) => _$CoordinateFromJson(json);

  Map<String, dynamic> toJson() => _$CoordinateToJson(this);
}

extension SearchRegionPolygonExtension on SearchRegionPolygon {
  bool get isRiyadh => id == '216';
}
