import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:path_provider/path_provider.dart';

/// A forecast payload together with where, when and in which language it was requested.
class WeatherForecastSnapshot {
  const WeatherForecastSnapshot({
    required this.latitude,
    required this.longitude,
    required this.fetchedAt,
    required this.languageCode,
    required this.payload,
  });

  final double latitude;
  final double longitude;
  final DateTime fetchedAt;
  final String languageCode;

  /// Raw `data.result` object of the forecast response.
  final Map<String, dynamic> payload;

  Duration get age => DateTime.now().difference(fetchedAt);

  Map<String, dynamic> toJson() => {
    'v': _version,
    'latitude': latitude,
    'longitude': longitude,
    'fetchedAt': fetchedAt.millisecondsSinceEpoch,
    'languageCode': languageCode,
    'payload': payload,
  };

  static WeatherForecastSnapshot? fromJson(Object? json) {
    if (json is! Map<String, dynamic> || json['v'] != _version) {
      return null;
    }
    final latitude = json['latitude'];
    final longitude = json['longitude'];
    final fetchedAt = json['fetchedAt'];
    final languageCode = json['languageCode'];
    final payload = json['payload'];
    if (latitude is! num ||
        longitude is! num ||
        fetchedAt is! int ||
        languageCode is! String ||
        payload is! Map<String, dynamic>) {
      return null;
    }
    return WeatherForecastSnapshot(
      latitude: latitude.toDouble(),
      longitude: longitude.toDouble(),
      fetchedAt: DateTime.fromMillisecondsSinceEpoch(fetchedAt),
      languageCode: languageCode,
      payload: payload,
    );
  }

  static const _version = 1;
}

/// Keeps the last forecast on disk so a cold start can reuse it instead of requesting it again.
///
/// Encoding, decoding and file IO run on a background isolate: the payload (5 days of hourly data) is large enough
/// to cost frames on the UI isolate.
abstract final class WeatherForecastCache {
  static const _fileName = 'weather_forecast_cache.json';

  static Future<WeatherForecastSnapshot?> read() async {
    final path = await _path();
    final json = await Isolate.run(() async {
      final file = File(path);
      if (!file.existsSync()) {
        return null;
      }
      return jsonDecode(await file.readAsString());
    });
    return WeatherForecastSnapshot.fromJson(json);
  }

  static Future<void> write(WeatherForecastSnapshot snapshot) async {
    final path = await _path();
    final json = snapshot.toJson();
    await Isolate.run(() => File(path).writeAsString(jsonEncode(json), flush: true));
  }

  static Future<String> _path() async => '${(await getApplicationSupportDirectory()).path}/$_fileName';
}
