import 'package:freezed_annotation/freezed_annotation.dart';

part 'thermal_config.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ThermalConfig {
  final int? idleTemperature;
  final int? lightTemperature;
  final int? moderateTemperature;
  final int? severeTemperature;
  final int? criticalTemperature;

  const ThermalConfig({
    required this.idleTemperature,
    required this.lightTemperature,
    required this.moderateTemperature,
    required this.severeTemperature,
    required this.criticalTemperature,
  });

  factory ThermalConfig.fromJson(Map<String, dynamic> json) => _$ThermalConfigFromJson(json);

  static const initial = ThermalConfig(
    idleTemperature: null,
    lightTemperature: 30,
    moderateTemperature: 20,
    severeTemperature: 15,
    criticalTemperature: 10,
  );

  @override
  String toString() =>
      'ThermalConfig($idleTemperature, $lightTemperature, $moderateTemperature, $severeTemperature, $criticalTemperature)';
}
