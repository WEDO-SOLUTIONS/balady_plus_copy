// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'eta_info_model.freezed.dart';
part 'eta_info_model.g.dart';

/// Enum representing the type of ETA.
enum EtaType {
  @JsonValue('geolocation')
  geolocation,
  @JsonValue('stream_metadata')
  streamMetadata,
}

/// Model class representing ETA information.
@JsonSerializable(genericArgumentFactories: true, explicitToJson: true)
class EtaInfoModel<T> {
  final EtaType? type;
  final T? payload;

  /// Constructs an instance of [EtaInfoModel].
  EtaInfoModel({
    this.type,
    this.payload,
  });

  /// Constructs an instance of [EtaInfoModel] from a JSON map.
  factory EtaInfoModel.fromJson(Map<String, dynamic> json, T Function(Object?) toJson) =>
      _$EtaInfoModelFromJson(json, toJson);

  /// Converts this [EtaInfoModel] instance to a JSON map.
  Map<String, dynamic> toJson(Object? Function(T) toJson) => _$EtaInfoModelToJson(this, toJson);
}

/// Freezed class representing the payload of ETA information.
@freezed
abstract class EtaInfoPayload with _$EtaInfoPayload {
  /// Constructs an instance of [EtaInfoPayload].
  @JsonSerializable(explicitToJson: true, includeIfNull: false)
  const factory EtaInfoPayload({
    final double? lat,
    final double? lon,
    final int? direction,
    final double? speed,
    final int? period,
    final Eta? eta,
    @JsonKey(name: 'updated_at') final String? updatedAt,
  }) = _EtaInfoPayload;

  /// Constructs an instance of [EtaInfoPayload] from a JSON map.
  factory EtaInfoPayload.fromJson(Map<String, dynamic> json) => _$EtaInfoPayloadFromJson(json);
}

/// Freezed class representing ETA information.
@freezed
abstract class Eta with _$Eta {
  /// Constructs an instance of [Eta].
  const factory Eta({
    @JsonKey(name: 'arrival_at') final String? arrivalAt,
    final double? distance,
  }) = _Eta;

  /// Constructs an instance of [Eta] from a JSON map.
  factory Eta.fromJson(Map<String, dynamic> json) => _$EtaFromJson(json);
}
