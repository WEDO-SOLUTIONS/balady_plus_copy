import 'package:json_annotation/json_annotation.dart';

part 'layer_item.g.dart';

@JsonSerializable()
class LayerItem {
  factory LayerItem.fromJson(Map<String, dynamic> json) =>
      _$LayerItemFromJson(json);
  LayerItem(this.id, this.name);

  int id;
  String name;

  Map<String, dynamic> toJson() => _$LayerItemToJson(this);
}
