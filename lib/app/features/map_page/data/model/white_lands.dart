import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:dgis_map/library.dart';

import '../data_sources/point_layers_data.dart';

List<WhiteLands> whiteLandsFromJson(List list) =>
    List<WhiteLands>.from(list.map((x) => WhiteLands.fromJson(x)));

class WhiteLands extends PointLayersData {
  final int color;
  final List<GeoPointMessage> paths;

  WhiteLands(
      {required this.paths,
      required id,
      required name,
      required type,
      required description,
      this.color = 0xFF828282})
      : super(
          id: id,
          name: name,
          description: description,
          type: type,
        );

  factory WhiteLands.fromJson(Map<String, dynamic> json) => WhiteLands(
      id: json['attributes']["OBJECTID"].toString(),
      name: json['attributes']["PARCELNAME"] ?? 'name',
      description: json['attributes']["DESCRIPTION"] ?? 'description',
      type: json['attributes']["PLANNO"] ?? 'type',
      color: json['attributes']["STATUS"] == "1" ? 0xFFf27107 : 0xFF828282,
      /////////////////////////
      paths: getList(json['geometry']["rings"])

      // not tested yat
      );
}
