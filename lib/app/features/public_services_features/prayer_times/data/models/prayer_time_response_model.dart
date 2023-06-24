import '../../../../../core/utils/utils_exports.dart' show Prayers;
import '../../prayer_times_exports.dart'
    show PrayerTimeModel, PrayerTimesResponse;

class PrayerTimesResponseModel extends PrayerTimesResponse {
  const PrayerTimesResponseModel({
    required super.date,
    required super.fajr,
    required super.dhuhr,
    required super.asr,
    required super.maghrib,
    required super.isha,
  });
  factory PrayerTimesResponseModel.fromMap(Map<String, dynamic> map) {
    return PrayerTimesResponseModel(
      date: DateTime(
        int.parse(map['Year']),
        int.parse(map['Month']),
        int.parse(map['Day']),
      ),
      fajr: PrayerTimeModel.fromTime(
        time: map["Fajr"],
        prayer: Prayers.fajr,
      ),
      dhuhr: PrayerTimeModel.fromTime(
        time: map["Zuhr"],
        prayer: Prayers.dhuhr,
      ),
      asr: PrayerTimeModel.fromTime(
        time: map["Asr"],
        prayer: Prayers.asr,
      ),
      maghrib: PrayerTimeModel.fromTime(
        time: map["Magrib"],
        prayer: Prayers.maghrib,
      ),
      isha: PrayerTimeModel.fromTime(
        time: map["Isha"],
        prayer: Prayers.isha,
      ),
    );
  }
}
