import 'package:dgis_map/esri/data/layer_info.dart';
import 'package:json_annotation/json_annotation.dart';

part 'layer_data.g.dart';

@JsonSerializable()
class SpatialReference {
  factory SpatialReference.fromJson(Map<String, dynamic> json) =>
      _$SpatialReferenceFromJson(json);

  SpatialReference(this.wkid, this.latestWkid);

  int wkid;
  int latestWkid;

  Map<String, dynamic> toJson() => _$SpatialReferenceToJson(this);
}

@JsonSerializable()
class ObjectGeometry {
  factory ObjectGeometry.fromJson(Map<String, dynamic> json) =>
      _$ObjectGeometryFromJson(json);
  // now it is only point object geometry. you should check geometry type first.
  ObjectGeometry(this.x, this.y);

  @JsonKey(fromJson: _fromJson)
  double? x;
  @JsonKey(fromJson: _fromJson)
  double? y;

  Map<String, dynamic> toJson() => _$ObjectGeometryToJson(this);
  // bad thing. we do it only for avoiding bad data problems. some objects have 'NaN' string value instead of floating point number.
  static double? _fromJson(dynamic value) {
    if (value is double) return value;
    return null;
  }
}

@JsonSerializable()
class LayerObject {
  factory LayerObject.fromJson(Map<String, dynamic> json) =>
      _$LayerObjectFromJson(json);

  LayerObject(this.geometry, this.attributes);

  ObjectGeometry geometry;
  Map<String, dynamic> attributes;

  Map<String, dynamic> toJson() => _$LayerObjectToJson(this);
}

@JsonSerializable()
class LayerData {
  factory LayerData.fromJson(Map<String, dynamic> json) =>
      _$LayerDataFromJson(json);

  LayerData(
      this.fields, this.geometryType, this.spatialReference, this.features);

  List<FieldInfo> fields;
  String geometryType;
  SpatialReference spatialReference;
  List<LayerObject> features;

  Map<String, dynamic> toJson() => _$LayerDataToJson(this);
}
