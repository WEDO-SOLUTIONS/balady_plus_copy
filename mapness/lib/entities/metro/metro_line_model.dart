// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'metro_line_model.freezed.dart';
part 'metro_line_model.g.dart';

@freezed
abstract class MetroLineModel with _$MetroLineModel {
  @JsonSerializable(explicitToJson: true)
  const factory MetroLineModel({
    final String? color,
    final List<MetroLinePoint>? points,
  }) = _MetroLineModel;

  factory MetroLineModel.fromJson(Map<String, dynamic> json) => _$MetroLineModelFromJson(json);
}

@freezed
abstract class MetroLinePoint with _$MetroLinePoint {
  const factory MetroLinePoint({
    final double? lat,
    final double? lon,
  }) = _MetroLinePoint;

  factory MetroLinePoint.fromJson(Map<String, dynamic> json) => _$MetroLinePointFromJson(json);
}
