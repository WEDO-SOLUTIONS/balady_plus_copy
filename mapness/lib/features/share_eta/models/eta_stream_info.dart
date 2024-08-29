// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'eta_stream_info.freezed.dart';
part 'eta_stream_info.g.dart';

@freezed
abstract class EtaStreamInfo with _$EtaStreamInfo {
  factory EtaStreamInfo({
    @JsonKey(name: 'stream_id') String? streamId,
    @JsonKey(name: 'stream_token') String? streamToken,
    @JsonKey(name: 'finishes_at') String? finishesAt,
    @JsonKey(name: 'duration_minutes') int? durationMinutes,
  }) = _EtaStreamInfo;

  factory EtaStreamInfo.fromJson(Map<String, dynamic> json) => _$EtaStreamInfoFromJson(json);
}
