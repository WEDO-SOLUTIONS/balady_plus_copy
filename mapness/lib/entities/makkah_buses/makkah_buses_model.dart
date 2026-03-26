// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'makkah_buses_model.freezed.dart';
part 'makkah_buses_model.g.dart';

@freezed
abstract class MakkahBusesModel with _$MakkahBusesModel {
  @JsonSerializable(explicitToJson: true)
  const factory MakkahBusesModel({
    final String? id,
    final String? nameArabic,
    final String? nameEnglish,
    final String? colorCode,
    final String? colorName,
    final List<List<double>>? coordinates, // [lon, lat] pairs
  }) = _MakkahBusesModel;

  factory MakkahBusesModel.fromJson(Map<String, dynamic> json) => _$MakkahBusesModelFromJson(json);
}
