import 'package:dgis_map/library.dart';

import '../data_sources/point_layers_data.dart';

List<LandsFenced> landsFencedFromJson(List list) => List<LandsFenced>.from(list.map((x) => LandsFenced.fromJson(x)));

class LandsFenced extends PointLayersData {
  final List<GeoPointMessage> paths;
  final int color;

  LandsFenced({
    required this.paths,
    required super.id,
    required super.name,
    required super.type,
    required super.description,
    this.color = 0xFF828282,
    //  required latLng,
  });

  factory LandsFenced.fromJson(Map<String, dynamic> json) => LandsFenced(
    id: json['attributes']["OBJECTID"].toString(),
    name: json['attributes']["AREANAME"] ?? '',
    description: json['attributes']["AREANAME_SPLIT"] ?? '',
    type: json['attributes']["DESCRIPTION"] ?? '',
    color: int.parse("0xFF${json['attributes']["COLOR"].toString().replaceAll("#", "")}"),

    // not Have Center Point
    /*latLng: GeoPointMessage(
      latitude:
      double.parse(json['attributes']["COORDINATE_Y"].toString()),
      longitude:
      double.parse(json['attributes']["COORDINATE_X"].toString()),
    ),*/
    /////////////////////////
    paths: getList(json['geometry']["rings"]), // not tested yat
  );
}
