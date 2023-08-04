import 'package:json_annotation/json_annotation.dart';

part 'layer_info.g.dart';

@JsonSerializable()
class FieldInfo {
  factory FieldInfo.fromJson(Map<String, dynamic> json) =>
      _$FieldInfoFromJson(json);

  FieldInfo(this.name, this.type, this.alias);

  String name;
  String type;
  String alias;

  Map<String, dynamic> toJson() => _$FieldInfoToJson(this);
}

@JsonSerializable()
class LayerInfo {
  factory LayerInfo.fromJson(Map<String, dynamic> json) =>
      _$LayerInfoFromJson(json);
  LayerInfo(
      this.id, this.name, this.geometryType, this.fields, this.geometryField);

  int id;
  String name;
  String geometryType;
  List<FieldInfo> fields;
  FieldInfo geometryField;

  Map<String, dynamic> toJson() => _$LayerInfoToJson(this);
}
