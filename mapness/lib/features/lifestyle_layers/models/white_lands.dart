import 'package:dgis_map/library.dart';
import 'package:mapness/features/lifestyle_layers/models/map_enums.dart';
import 'package:mapness/features/lifestyle_layers/models/point_layers_data.dart';

List<WhiteLands> whiteLandsFromJson(List list) => List<WhiteLands>.from(
      list.map((e) => WhiteLands.fromJson(e as Map<String, dynamic>)),
    );

class WhiteLands extends PointLayersData {
  final int color;
  final int strokeColor;
  final List<GeoPointMessage> paths;
  final String? amananame;
  final String? munname;
  final String? parcelCode;
  final String? status;
  final String? streetName;
  final String? parcelArea;
  final String? cityName;
  final String? parcelNo;
  final dynamic parcelLength;
  final String? phase;

  static const defaultColor = 0x26000000;
  static const disabledColor = 0x3342D991;
  static const defaultStrokeColor = 0xFF000000;
  static const disabledStrokeColor = 0xFF0B7E47;

  const WhiteLands({
    required this.paths,
    required super.id,
    required super.name,
    required super.type,
    required super.description,
    this.color = defaultColor,
    this.strokeColor = defaultStrokeColor,
    this.amananame,
    this.munname,
    this.phase,
    this.parcelCode,
    this.status,
    this.streetName,
    this.parcelArea,
    this.cityName,
    this.parcelNo,
    this.parcelLength,
  }) : super(layerType: GISMapLayers.bsWhiteParcelS);

  factory WhiteLands.fromJson(Map<String, dynamic> json) {
    final attributes = json['attributes'] as Map<String, dynamic>;
    final isStatusOne = attributes['STATUS'] == '1';

    return WhiteLands(
      id: attributes['OBJECTID'].toString(),
      name: attributes['PARCELNAME'] ?? '',
      description: attributes['DESCRIPTION'] ?? '',
      type: attributes['PLANNO'] ?? '',
      color: isStatusOne ? disabledColor : defaultColor,
      strokeColor: isStatusOne ? disabledStrokeColor : defaultStrokeColor,
      amananame: attributes['AMANANAME'] ?? '',
      munname: attributes['MUNNAME'] ?? '',
      parcelCode: attributes['PARCELCODE'] ?? '',
      streetName: attributes['STREETNAME'] ?? '',
      parcelArea: attributes['PARCELAREA'] ?? '',
      cityName: attributes['CITYNAME'] ?? '',
      parcelNo: attributes['PARCELNO'] ?? '',
      parcelLength: attributes['PARCELLENGTH'] ?? '',
      phase: attributes['PHASE'],
      // ignore: avoid_dynamic_calls
      paths: getList(json['geometry']['rings']),
    );
  }
}
