import 'package:dgis_map/library.dart';

import '../data_sources/point_layers_data.dart';

List<WhiteLands> whiteLandsFromJson(List list) => List<WhiteLands>.from(list.map((x) => WhiteLands.fromJson(x)));

class WhiteLands extends PointLayersData {
  final int color;
  final int strokeColor;

  final List<GeoPointMessage> paths;

  final String? amanaName;
  final String? munName;
  final String? parcelCode;
  final String? status;
  final String? streetName;
  final String? parcelArea;
  final String? cityName;
  final String? parcelNo;
  final dynamic parcelLength;
  final String? phase;

  WhiteLands({
    required this.paths,
    required super.id,
    required super.name,
    required super.type,
    required super.description,
    this.color = 0x26000000,
    this.strokeColor = 0xFF000000,
    this.amanaName,
    this.munName,
    this.phase,
    this.parcelCode,
    this.status,
    this.streetName,
    this.parcelArea,
    this.cityName,
    this.parcelNo,
    this.parcelLength,
  });

  factory WhiteLands.fromJson(Map<String, dynamic> json) => WhiteLands(
    id: json['attributes']["OBJECTID"].toString(),
    name: json['attributes']["PARCELNAME"] ?? '',
    description: json['attributes']["DESCRIPTION"] ?? '',
    type: json['attributes']["PLANNO"] ?? '',
    color: json['attributes']["STATUS"] == "1" ? 0x3342D991 : 0x26000000,
    strokeColor: json['attributes']["STATUS"] == "1" ? 0xFF0B7E47 : 0xFF000000,
    amanaName: json['attributes']["AMANANAME"] ?? '',
    munName: json['attributes']["MUNNAME"] ?? '',
    parcelCode: json['attributes']["PARCELCODE"] ?? '',
    streetName: json['attributes']["STREETNAME"] ?? '',
    parcelArea: json['attributes']["PARCELAREA"] ?? '',
    cityName: json['attributes']["CITYNAME"] ?? '',
    parcelNo: json['attributes']["PARCELNO"] ?? '',
    parcelLength: json['attributes']["PARCELLENGTH"] ?? '',
    phase: json['attributes']['PHASE'],
    /////////////////////////
    paths: getList(json['geometry']["rings"]),

    // not tested yat
  );
}
