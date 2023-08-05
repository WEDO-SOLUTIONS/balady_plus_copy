import 'package:equatable/equatable.dart';

import '../../../../../core/utils/utils_exports.dart' show Prayers;
import '../../prayer_times_exports.dart' show PrayerTimeEntity;

class PrayerTimesResponse extends Equatable {
  final DateTime date;
  final PrayerTimeEntity fajr;
  final PrayerTimeEntity dhuhr;
  final PrayerTimeEntity asr;
  final PrayerTimeEntity maghrib;
  final PrayerTimeEntity isha;

  const PrayerTimesResponse({
    required this.date,
    required this.fajr,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
  });

  String fotmattedTimeFor(Prayers prayer) {
    switch (prayer) {
      case Prayers.fajr:
        return fajr.formattedTime();
      case Prayers.dhuhr:
        return dhuhr.formattedTime();
      case Prayers.asr:
        return asr.formattedTime();
      case Prayers.maghrib:
        return maghrib.formattedTime();
      case Prayers.isha:
        return isha.formattedTime();
    }
  }

  @override
  List<Object?> get props => [
        date,
        fajr,
        dhuhr,
        asr,
        maghrib,
        isha,
      ];
}
