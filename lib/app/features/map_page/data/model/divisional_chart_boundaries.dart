import 'package:dgis_map/library.dart';

import '../data_sources/point_layers_data.dart';

List<DivisionalChartBoundaries> divisionalChartBoundariesFromJson(List list) =>
    List<DivisionalChartBoundaries>.from(list.map((x) => DivisionalChartBoundaries.fromJson(x)));

class DivisionalChartBoundaries extends PointLayersData {
  final List<GeoPointMessage> paths;
  final int color;
  final int strokeColor;
  String? SUBDIVISIONPLAN_ID;
  String? BLOCK_ID;
  String? SUBDIVISIONPARCELNUMBER;

  DivisionalChartBoundaries({
    required this.paths,
    required super.id,
    required super.name,
    required super.type,
    required super.description,
    this.SUBDIVISIONPLAN_ID,
    this.BLOCK_ID,
    this.SUBDIVISIONPARCELNUMBER,
    latLng,
    this.color = 0x26000000,
    this.strokeColor = 0xFF000000,
  });

  factory DivisionalChartBoundaries.fromJson(Map<String, dynamic> json) => DivisionalChartBoundaries(
    id: json['attributes']["OBJECTID"].toString(),
    name: json['attributes']["SUBDIVISIONNAME_AR"] ?? '',
    description: json['attributes']["DATAOWNER"] ?? '',
    type: json['attributes']["AREANAME_SPLIT"] ?? '',
    color: 0x26000000,
    strokeColor: 0xFF000000,
    SUBDIVISIONPARCELNUMBER: json['attributes']["SUBDIVISIONPARCELNUMBER"] ?? '',
    BLOCK_ID: json['attributes']["BLOCK_ID"] ?? '',
    SUBDIVISIONPLAN_ID: json['attributes']["SUBDIVISIONPLAN_ID"] ?? '',

    /////////////////////////
    paths: getList(json['geometry']["rings"]), // not tested yat
  );
}
