import 'package:freezed_annotation/freezed_annotation.dart';

part 'eta_stream_store.freezed.dart';

@freezed
abstract class EtaStreamStore with _$EtaStreamStore {
  const factory EtaStreamStore({
    final String? streamId,
    final String? streamToken,
    final DateTime? estimatedTime,
    final String? xStreamData,
    final int? durationInMinutes,
    final double? latitude,
    final double? longitude,
  }) = _EtaStreamStore;
}
