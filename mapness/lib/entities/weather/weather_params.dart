// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:mapness/_features/lifestyle_layers/data/common_function.dart';
import 'package:mapness/shared/config/environment_config.dart';

class WeatherParams {
  double? longitude;
  double? latitude;
  int numberOfDays;
  String? languageCode;
  String? alert;
  String domain;
  String? proxy;

  WeatherParams({
    required this.numberOfDays,
    required this.domain,
    this.longitude,
    this.latitude,
    this.proxy,
    this.languageCode = 'ar',
    this.alert = 'yes',
  });

  String? getVerifyingKey() {
    const weatherServices = 'v1/weather-services/forecast?';
    final params = toMap();

    var hashedUrl =
        proxy != null ? '${EnvironmentConfig.momrahStaging().weatherApi}$weatherServices' : '$domain$weatherServices';

    params.forEach((key, value) => hashedUrl += '$key=$value&');
    hashedUrl = hashedUrl.substring(0, hashedUrl.length - 1);

    return hashRequest(hashedUrl, 'GET');
  }

  Map<String, dynamic> toMap() => {
        if (latitude != null && longitude != null) 'q': '$latitude,$longitude',
        'days': '$numberOfDays',
        if (languageCode != null) 'lang': '$languageCode',
        if (alert != null) 'alerts': '$alert',
      };
}
