import 'package:dgis_map/library.dart';

import '../data_sources/point_layers_data.dart';

List<WhiteLands> whiteLandsFromJson(List list) =>
    List<WhiteLands>.from(list.map((x) => WhiteLands.fromJson(x)));

class WhiteLands extends PointLayersData {
  final List<GeoPointMessage> paths;

  WhiteLands({
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

  factory WhiteLands.fromJson(Map<String, dynamic> json) => WhiteLands(
    id: json['attributes']["OBJECTID"].toString(),
    name: json['attributes']["PARCELNAME"] ?? 'name',
    description: json['attributes']["DESCRIPTION"] ?? 'description',
    type: json['attributes']["PLANNO"] ?? 'type',

    // not Have Center Point
    latLng: GeoPointMessage(
      latitude: 26.22,
      longitude: 46.4444,
    ),
    /////////////////////////
    paths: getList(json['geometry']["rings"]), // not tested yat
  );
}
