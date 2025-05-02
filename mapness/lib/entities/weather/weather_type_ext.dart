import 'package:dgis_map/library.dart';
import 'package:intl/intl.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';

extension WeatherMapTypeExt on WeatherMapType {
  String measureUnit() => switch (this) {
        WeatherMapType.precipitation => 'mm',
        WeatherMapType.temperature => '℃',
      };
  String layerName() => switch (this) {
        WeatherMapType.precipitation => 'heatmap',
        WeatherMapType.temperature => 'heatmap',
      };
  List<String> measures() => switch (this) {
        WeatherMapType.precipitation => [
            '30',
            '25',
            '20',
            '15',
            '10',
            '7',
            '5',
            '3',
            '2',
            '1.5',
            '1',
            '0.5',
            '0.2',
          ],
        WeatherMapType.temperature => [
            '48',
            '44',
            '40',
            '36',
            '32',
            '28',
            '24',
            '20',
            '16',
            '12',
            '8',
            '4',
            '0',
            '-4',
          ],
      };

  String iconRes() => switch (this) {
        WeatherMapType.precipitation => Assets.icons.svg.weather.umbrellaEmpty.keyName,
        WeatherMapType.temperature => Assets.icons.svg.weather.thermometerEmpty.keyName,
      };

  // ignore_for_file: missing_whitespace_between_adjacent_strings
  String get parameters => switch (this) {
        ///{code}~{level}~{time-resolution}~{aggregation}~{type}~{type-parameter}
        WeatherMapType.temperature => '11~'
            '2 m above gnd~'
            'hourly~'
            'none~'
            'contourSteps~'
            '-10.0~rgba(52,140,237,1.0)~'
            '-8.0~rgba(68,177,246,1.0)~'
            '-6.0~rgba(81,203,250,1.0)~'
            '-4.0~rgba(128,224,247,1.0)~'
            '-2.0~rgba(160,234,247,1.0)~'
            '0.0~rgba(0,239,124,1.0)~'
            '2.0~rgba(0,228,82,1.0)~'
            '4.0~rgba(0,200,72,1.0)~'
            '6.0~rgba(16,184,122,1.0)~'
            '8.0~rgba(41,123,93,1.0)~'
            '10.0~rgba(0,114,41,1.0)~'
            '12.0~rgba(60,161,44,1.0)~'
            '14.0~rgba(121,208,48,1.0)~'
            '16.0~rgba(181,255,51,1.0)~'
            '18.0~rgba(216,247,161,1.0)~'
            '20.0~rgba(255,246,0,1.0)~'
            '22.0~rgba(248,223,11,1.0)~'
            '24.0~rgba(253,202,12,1.0)~'
            '26.0~rgba(252,172,5,1.0)~'
            '28.0~rgba(248,141,0,1.0)~'
            '30.0~rgba(255,102,0,1.0)~',
        WeatherMapType.precipitation => '61~'
            'sfc~'
            'hourly~'
            'none~'
            'contourSteps~'
            // "0.0~rgba(153,230,249,1.0)~"
            '0.1~rgba(31,153,196,1.0)~'
            '0.2~rgba(51,241,150,1.0)~'
            '0.5~rgba(51,241,150,1.0)~'
            '1.0~rgba(52,211,109,1.0)~'
            '1.5~rgba(148,217,89,1.0)~'
            '2.0~rgba(169,249,29,1.0)~'
            '3.0~rgba(255,248,50,1.0)~'
            '5.0~rgba(254,212,61,1.0)~'
            '7.0~rgba(249,164,50,1.0)~'
            '10.0~rgba(253,114,51,1.0)~'
            '15.0~rgba(245,72,50,1.0)~'
            '20.0~rgba(245,70,129,1.0)~'
            '25.0~rgba(245,70,205,1.0)~'
            '30.0~rgba(170,53,77,1.0)~',
      };

  String tileSourceUri() => switch (this) {
        WeatherMapType.precipitation => _tileSourceUri(this),
        WeatherMapType.temperature => _tileSourceUri(this),
      };

  String _tileSourceUri(WeatherMapType type) {
    final format = DateFormat("yyyy-MM-dd'T'HH:mm").format(DateTime.now());
    // const apiKey = 'be72f76237db';
    const apiKey = '74daf4716240';

    return 'https://maps-api.meteoblue.com/v1/map/raster/NEMSAUTO/'
        '$format/'
        '${type.parameters}/'
        '{z}/{x}/{y}?'
        'temperatureUnit=C'
        '&apikey=$apiKey';
  }
}
