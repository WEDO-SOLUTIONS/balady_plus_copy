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

          /////////////////////////
          //  paths: getList(json['geometry']["rings"]

          paths: [
            GeoPointMessage(
                latitude: 26.369406393621627, longitude: 50.19933225597286),
            GeoPointMessage(
                latitude: 26.373032789329308, longitude: 50.19579384705713),
            GeoPointMessage(
                latitude: 26.373032789329308, longitude: 50.19579384705713),
            GeoPointMessage(
                latitude: 26.374354635533997, longitude: 50.19360020012975)
          ]

          // not tested yat
          );
}
