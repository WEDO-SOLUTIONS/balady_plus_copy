import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:mapness/shared/config/environment_config.dart';
import 'package:mapness/shared/utils/common_function.dart';

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

    final hashedUrl = proxy != null ? EnvironmentConfig.momrahStaging().weatherApi : domain;

    final query = params.entries.map((entry) => '${entry.key}=${entry.value}').join('&');

    final url = '$hashedUrl$weatherServices$query';

    final hasToken = CommonProperties.token.isNotEmpty;

    return hashRequest(url, 'GET', authorization: hasToken);
  }

  Map<String, dynamic> toMap() => {
        if (latitude != null && longitude != null) 'q': '$latitude,$longitude',
        'days': '$numberOfDays',
        if (languageCode != null) 'lang': '$languageCode',
        if (alert != null) 'alerts': '$alert',
      };
}
