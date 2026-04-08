// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'model.freezed.dart';
part 'model.g.dart';

@freezed
abstract class MakkahBusModel with _$MakkahBusModel {
  @JsonSerializable(explicitToJson: true)
  const factory MakkahBusModel({
    final String? id,
    final String? nameArabic,
    final String? nameEnglish,
    final String? colorCode,
    final String? colorName,
    final List<List<double>>? coordinates, // [lon, lat] pairs
  }) = _MakkahBusModel;

  factory MakkahBusModel.fromJson(Map<String, dynamic> json) => _$MakkahBusModelFromJson(json);
}
