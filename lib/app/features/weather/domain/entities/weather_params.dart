// ignore_for_file: public_member_api_docs, sort_constructors_first
class WeatherParams {
  double? longitude;
  double? latitude;
  int? numberOfDays = 7;
  String? languageCode = "ar";
  String? alert = "yes";
  String? key = '7fb258f132b04a298ae154452233007';

  WeatherParams(
      {this.longitude,
      this.latitude,
      this.numberOfDays,
      this.languageCode,
      this.alert,
      this.key});

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
      if (numberOfDays != null) "days": '$numberOfDays',
      if (languageCode != null) "lang": '$languageCode',
      if (alert != null) "alerts": '$alert',
    };
  }
}
