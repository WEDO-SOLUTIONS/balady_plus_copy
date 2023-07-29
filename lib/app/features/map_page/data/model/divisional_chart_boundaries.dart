import 'package:dgis_map/library.dart';

import '../data_sources/point_layers_data.dart';

List<DivisionalChartBoundaries> divisionalChartBoundariesFromJson(List list) =>
    List<DivisionalChartBoundaries>.from(
        list.map((x) => DivisionalChartBoundaries.fromJson(x)));

class DivisionalChartBoundaries extends PointLayersData {
  final List<GeoPointMessage> paths;
  final int color;
  DivisionalChartBoundaries(
      {required this.paths,
      required id,
      required name,
      required type,
      required description,
      required latLng,
      this.color = 0xFF828282})
      : super(
          id: id,
          name: name,
          description: description,
          type: type,
          latLng: latLng,
        );

  factory DivisionalChartBoundaries.fromJson(Map<String, dynamic> json) =>
      DivisionalChartBoundaries(
        id: json['attributes']["OBJECTID"].toString(),
        name: json['attributes']["SUBDIVISIONNAME_AR"] ?? 'name',
        description: json['attributes']["DATAOWNER"] ?? 'description',
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
