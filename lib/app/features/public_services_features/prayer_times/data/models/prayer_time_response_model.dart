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
          map['date']['year'], map['date']['month'], map['date']['day']),
      fajr: PrayerTimeModel.fromMap(
        map['prayTimes']['fajr'] as Map<String, dynamic>,
        prayer: Prayers.fajr,
      ),
      dhuhr: PrayerTimeModel.fromMap(
        map['prayTimes']['dhuhr'] as Map<String, dynamic>,
        prayer: Prayers.dhuhr,
      ),
      asr: PrayerTimeModel.fromMap(
        map['prayTimes']['asr'] as Map<String, dynamic>,
        prayer: Prayers.asr,
      ),
      maghrib: PrayerTimeModel.fromMap(
        map['prayTimes']['maghrib'] as Map<String, dynamic>,
        prayer: Prayers.maghrib,
      ),
      isha: PrayerTimeModel.fromMap(
        map['prayTimes']['isha'] as Map<String, dynamic>,
        prayer: Prayers.isha,
      ),
    );
  }
}
