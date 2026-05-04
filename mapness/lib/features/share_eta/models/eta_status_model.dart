import 'package:freezed_annotation/freezed_annotation.dart';

part 'eta_status_model.freezed.dart';

@freezed
abstract class EtaStatusModel with _$EtaStatusModel {
  factory EtaStatusModel({
    required bool status,
    String? streamId,
    String? streamToken,
    DateTime? estimatedTime,
  }) = _EtaStatusModel;
}
