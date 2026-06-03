part of 'metrics_logger.dart';

@freezed
abstract class MetricsDbDto with _$MetricsDbDto {
  const factory MetricsDbDto({
    required DateTime timestamp,
    required String eventType,
    required List<MetricsLoggerService> services,
    int? id,
    Map<String, dynamic>? payload,
    MapnessLogLevel? logLevel,
  }) = _MetricsDbDto;

  const MetricsDbDto._();

  factory MetricsDbDto.fromJson(Map<String, dynamic> json) => _$MetricsDbDtoFromJson(json);

  String toFileString() {
    final json = toJson();
    // escape payload json for string representation
    if (payload != null) {
      json['payload'] = jsonEncode(payload);
    }
    return jsonEncode(json);
  }
}

enum MetricsLoggerService { firebase, uxCam, sentry, adjust, bss, unknown }
