import 'package:dgis_map/wfs/data/feature_item.dart';
import 'package:json_annotation/json_annotation.dart';

part 'feature_collection.g.dart';

@JsonSerializable(explicitToJson: true)
class FeatureCollection {
  factory FeatureCollection.fromJson(Map<String, dynamic> json) =>
      _$FeatureCollectionFromJson(json);

  const FeatureCollection({
    required this.type,
    required this.features,
  });

  @JsonKey(name: "type")
  final String type;
  @JsonKey(name: "features")
  final List<FeatureItem> features;

  Map<String, dynamic> toJson() => _$FeatureCollectionToJson(this);
}
