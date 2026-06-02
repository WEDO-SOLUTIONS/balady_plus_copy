// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'line.dart';
part 'model.freezed.dart';
part 'model.g.dart';
part 'station.dart';

typedef StringColorCode = String;

@freezed
abstract class MakkahBusModel with _$MakkahBusModel {
  @JsonSerializable(explicitToJson: true)
  const factory MakkahBusModel({
    final String? id,
    final String? nameArabic,
    final String? nameEnglish,
    final StringColorCode? colorCode,
    final String? colorName,
    final List<List<double>>? coordinates,
  }) = _MakkahBusModel;

  factory MakkahBusModel.fromJson(Map<String, dynamic> json) => _$MakkahBusModelFromJson(json);
}

extension StringColorCodeX on StringColorCode {
  int? get intColorCode => int.tryParse(replaceAll('#', '0xFF'));
}
