import 'package:json_annotation/json_annotation.dart';

part 'poi_marker_rcmc.g.dart';

@JsonSerializable()
class PoiMarkerRcmc {
  final String id;
  final int categoryId;
  final String categoryName;
  final String title;
  final String? description;
  final double latitude;
  final double longitude;
  final String? address;
  final String? contactInfo;

  PoiMarkerRcmc({
    required this.id,
    required this.categoryId,
    required this.categoryName,
    required this.title,
    required this.latitude,
    required this.longitude,
    this.description,
    this.address,
    this.contactInfo,
  });

  factory PoiMarkerRcmc.fromJson(Map<String, dynamic> json) => _$PoiMarkerRcmcFromJson(json);

  Map<String, dynamic> toJson() => _$PoiMarkerRcmcToJson(this);
}
