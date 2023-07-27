import 'package:dgis_map/library.dart';

import '../data_sources/point_layers_data.dart';

List<BoundariesPlots> boundariesPlotsFromJson(List list) =>
    List<BoundariesPlots>.from(list.map((x) => BoundariesPlots.fromJson(x)));

class BoundariesPlots extends PointLayersData {
  final List<GeoPointMessage> paths;

  BoundariesPlots({
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

  factory BoundariesPlots.fromJson(Map<String, dynamic> json) => BoundariesPlots(
    id: json['attributes']["OBJECTID"].toString(),
    name: json['attributes']["SUBDIVISIONPLANNAME_AR"] ?? 'name',
    description: json['attributes']["SUBTYPEDESCRIPTION"] ?? 'description',
    type: json['attributes']["AREANAME_SPLIT"] ?? 'type',

    // not Have Center Point
    latLng: GeoPointMessage(
      latitude: 26.22,
      longitude: 46.4444,
    ),
    /////////////////////////
    paths: getList(json['geometry']["rings"]), // not tested yat
  );
}
