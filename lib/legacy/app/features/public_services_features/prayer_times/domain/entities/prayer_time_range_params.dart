class PrayerTimeRangeParams {
  final String startDate;
  final String endDate;
  final String dateType;
  final String lat;
  final String lng;
  final String isFormat24Hours;

  PrayerTimeRangeParams({
    required this.startDate,
    required this.endDate,
    required this.dateType,
    required this.lat,
    required this.lng,
    required this.isFormat24Hours,
  });

  Map<String, dynamic> toMap() => {
        "startDate": startDate,
        "endDate": endDate,
        "dateType": dateType,
        "latitude": lat,
        "longitude": lng,
        "isFormat24Hours": isFormat24Hours,
      };
}
