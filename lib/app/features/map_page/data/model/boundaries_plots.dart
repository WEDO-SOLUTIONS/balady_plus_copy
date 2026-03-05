import 'package:dgis_map/library.dart';

import '../data_sources/point_layers_data.dart';

List<BoundariesPlots> boundariesPlotsFromJson(List list) =>
    List<BoundariesPlots>.from(list.map((x) => BoundariesPlots.fromJson(x)));

class BoundariesPlots extends PointLayersData {
  final List<GeoPointMessage> paths;
  final int color;

  BoundariesPlots(
      {required this.paths, required id, required name, required type, required description, this.color = 0xFF828282})
      : super(
          id: id,
          name: name,
          description: description,
          type: type,
        );

  factory BoundariesPlots.fromJson(Map<String, dynamic> json) => BoundariesPlots(
        id: json['attributes']["OBJECTID"].toString(),
        name: json['attributes']["SUBDIVISIONPLANNAME_AR"] ?? '',
        description: json['attributes']["SUBTYPEDESCRIPTION"] ?? '',
        type: json['attributes']["AREANAME_SPLIT"] ?? '',

        /////////////////////////
        paths: getList(json['geometry']["rings"]), // not tested yat
      );
}
