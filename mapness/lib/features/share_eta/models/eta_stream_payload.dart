// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mapness/features/share_eta/models/eta_route_info.dart';

part 'eta_stream_payload.freezed.dart';
part 'eta_stream_payload.g.dart';

@freezed
abstract class EtaStreamPayload with _$EtaStreamPayload {
  /// Constructs an instance of [EtaStreamPayload].
  @JsonSerializable(explicitToJson: true)
  const factory EtaStreamPayload({
    @JsonKey(name: 'duration_minutes') final int? durationMinutes,
    final String? type,
    final EtaRoutePayload? metadata,
  }) = _EtaStreamPayload;

  /// Constructs an instance of [EtaStreamPayload] from a JSON map.
  factory EtaStreamPayload.fromJson(Map<String, dynamic> json) => _$EtaStreamPayloadFromJson(json);
}
