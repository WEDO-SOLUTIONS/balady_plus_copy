import 'package:dgis_map/esri/data/layer_item.dart';
import 'package:json_annotation/json_annotation.dart';

part 'layer_collection.g.dart';

@JsonSerializable()
class LayerCollection {
  factory LayerCollection.fromJson(Map<String, dynamic> json) =>
      _$LayerCollectionFromJson(json);

  LayerCollection(this.layers);

  final List<LayerItem> layers;

  Map<String, dynamic> toJson() => _$LayerCollectionToJson(this);
}
