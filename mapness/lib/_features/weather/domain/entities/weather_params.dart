// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:mapness/_features/lifestyle_layers/data/common_function.dart';

class WeatherParams {
  double? longitude;
  double? latitude;
  int numberOfDays;
  String? languageCode;
  String? alert;
  String? key;
  String domain;
  String? proxy;

  WeatherParams(
      {this.longitude,
      this.latitude,
      required this.numberOfDays,
      required this.domain,
      this.proxy,
      this.languageCode = "ar",
      this.alert = "yes",
      this.key = '7fb258f132b04a298ae154452233007'});

  WeatherParams copyWith({
    double? longitude,
    double? latitude,
    int? numberOfDays,
    String? key,
  }) {
    return WeatherParams(
      longitude: longitude ?? this.longitude,
      latitude: latitude ?? this.latitude,
      numberOfDays: numberOfDays ?? this.numberOfDays,
      alert: alert,
      languageCode: languageCode,
      key: key ?? this.key,
      domain: domain,
    );
  }

  String? getVerifyingKey() {
    String verifyingKey;

    const gisLayers = 'weather-services/forecast?';

    final params = toMap();

    var hashedUrl;

    if (proxy != null) {
      const domain = 'https://apiservicesstg.balady.gov.sa';
      hashedUrl = "$domain/v1/$gisLayers";
    } else {
      var domainYUrl = domain.replaceAll('/urbi-services/', '');
      hashedUrl = "$domainYUrl/$gisLayers";
    }

    params.forEach((key, value) => hashedUrl += "$key=$value&");
    hashedUrl = hashedUrl.substring(0, hashedUrl.length - 1);
    verifyingKey = hashRequest(hashedUrl, "GET");
    return verifyingKey;
  }

  // create toMap method
  Map<String, dynamic> toMap() {
    return {
      if (latitude != null && longitude != null) "q": "$latitude,$longitude",
      "days": '$numberOfDays',
      if (languageCode != null) "lang": '$languageCode',
      if (alert != null) "alerts": '$alert',
      if (key != null) "key": '$key',
    };
  }
}
