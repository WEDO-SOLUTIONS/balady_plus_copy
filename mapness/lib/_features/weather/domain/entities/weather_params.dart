// ignore_for_file: public_member_api_docs, sort_constructors_first
class WeatherParams {
  double? longitude;
  double? latitude;
  int numberOfDays;
  String? languageCode;
  String? alert;
  String? key;

  WeatherParams(
      {this.longitude,
      this.latitude,
      required this.numberOfDays,
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
        key: key ?? this.key);
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
