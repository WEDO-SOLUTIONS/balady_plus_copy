import 'package:dgis_map/library.dart';

import '../data_sources/point_layers_data.dart';

List<LandsFenced> landsFencedFromJson(List list) =>
    List<LandsFenced>.from(list.map((x) => LandsFenced.fromJson(x)));

class LandsFenced extends PointLayersData {
  final List<GeoPointMessage> paths;

  LandsFenced({
    required this.paths,
    required id,
    required name,
    required type,
    required description,
    required latLng,
  }) : super(
    id: id,
    name: name,
    description: description,
    type: type,
    latLng: latLng,
  );

  factory LandsFenced.fromJson(Map<String, dynamic> json) => LandsFenced(
    id: json['attributes']["OBJECTID"].toString(),
    name: json['attributes']["AREANAME"] ?? 'name',
    description: json['attributes']["AREANAME_SPLIT"] ?? 'description',
    type: json['attributes']["DESCRIPTION"] ?? 'type',

    // not Have Center Point
    latLng: GeoPointMessage(
      latitude:
      double.parse(json['attributes']["COORDINATE_Y"].toString()),
      longitude:
      double.parse(json['attributes']["COORDINATE_X"].toString()),
    ),
    /////////////////////////
    paths: getList(json['geometry']["rings"]), // not tested yat
  );
}
