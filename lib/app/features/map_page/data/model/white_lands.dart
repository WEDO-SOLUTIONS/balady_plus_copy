import 'package:dgis_map/library.dart';

import '../data_sources/point_layers_data.dart';

List<WhiteLands> whiteLandsFromJson(List list) => List<WhiteLands>.from(list.map((x) => WhiteLands.fromJson(x)));

class WhiteLands extends PointLayersData {
  final int color;
  final int strokeColor;

  final List<GeoPointMessage> paths;

  final String? AMANANAME;
  final String? MUNNAME;
  final String? PARCELCODE;
  final String? STATUS;
  final String? STREETNAME;
  final String? PARCELAREA;
  final String? CITYNAME;
  final String? PARCELNO;
  final dynamic PARCELLENGTH;
  final String? PHASE;

  WhiteLands({
    required this.paths,
    required id,
    required name,
    required type,
    required description,
    this.color = 0x26000000,
    this.strokeColor = 0xFF000000,
    this.AMANANAME,
    this.MUNNAME,
    this.PHASE,
    this.PARCELCODE,
    this.STATUS,
    this.STREETNAME,
    this.PARCELAREA,
    this.CITYNAME,
    this.PARCELNO,
    this.PARCELLENGTH,
  }) : super(id: id, name: name, description: description, type: type);

  factory WhiteLands.fromJson(Map<String, dynamic> json) => WhiteLands(
    id: json['attributes']["OBJECTID"].toString(),
    name: json['attributes']["PARCELNAME"] ?? '',
    description: json['attributes']["DESCRIPTION"] ?? '',
    type: json['attributes']["PLANNO"] ?? '',
    color: json['attributes']["STATUS"] == "1" ? 0x3342D991 : 0x26000000,
    strokeColor: json['attributes']["STATUS"] == "1" ? 0xFF0B7E47 : 0xFF000000,
    AMANANAME: json['attributes']["AMANANAME"] ?? '',
    MUNNAME: json['attributes']["MUNNAME"] ?? '',
    PARCELCODE: json['attributes']["PARCELCODE"] ?? '',
    STREETNAME: json['attributes']["STREETNAME"] ?? '',
    PARCELAREA: json['attributes']["PARCELAREA"] ?? '',
    CITYNAME: json['attributes']["CITYNAME"] ?? '',
    PARCELNO: json['attributes']["PARCELNO"] ?? '',
    PARCELLENGTH: json['attributes']["PARCELLENGTH"] ?? '',
    PHASE: json['attributes']['PHASE'],
    /////////////////////////
    paths: getList(json['geometry']["rings"]),

    // not tested yat
  );
}
