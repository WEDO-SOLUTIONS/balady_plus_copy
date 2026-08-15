import 'package:freezed_annotation/freezed_annotation.dart';

part 'health_check_dto.freezed.dart';

part 'health_check_dto.g.dart';

@freezed
abstract class HealthChecksDto with _$HealthChecksDto {
  factory HealthChecksDto({
    required final bool postgres,
    required final bool redis,
  }) = _HealthChecksDto;

  factory HealthChecksDto.fromJson(Map<String, dynamic> json) => _$HealthChecksDtoFromJson(json);
}

@freezed
abstract class HealthCheckDto with _$HealthCheckDto {
  factory HealthCheckDto({
    required final String status,
    required final HealthChecksDto checks,
    required final List<String> degraded,
    required final DateTime timestamp,
  }) = _HealthCheckDto;

  factory HealthCheckDto.fromJson(Map<String, dynamic> json) => _$HealthCheckDtoFromJson(json);
}
