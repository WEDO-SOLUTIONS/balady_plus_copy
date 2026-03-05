import '../../prayer_times_exports.dart';

class PrayerTimeRangeResponseModel extends PrayerTimeRangeEntity {
  PrayerTimeRangeResponseModel({
    String? asr,
    String? day,
    String? fajr,
    String? gharobAlQamar,
    String? isha,
    String? magrib,
    String? month,
    String? sharoqAlQamar,
    String? shqaroq,
    String? timezone,
    String? year,
    String? zuhr,
  }) : super(
          asr: asr ?? "",
          day: day ?? '',
          fajr: fajr ?? '',
          gharobAlQamar: gharobAlQamar ?? '',
          isha: isha ?? '',
          magrib: magrib ?? '',
          month: month ?? '',
          sharoqAlQamar: sharoqAlQamar ?? '',
          shqaroq: shqaroq ?? '',
          timezone: timezone ?? '',
          year: year ?? '',
          zuhr: zuhr ?? '',
        );

  factory PrayerTimeRangeResponseModel.fromJson(Map<String, dynamic> json) => PrayerTimeRangeResponseModel(
        asr: json["Asr"],
        day: json["Day"],
        fajr: json["Fajr"],
        gharobAlQamar: json["GharobAlQamar"],
        isha: json["Isha"],
        magrib: json["Magrib"],
        month: json["Month"],
        sharoqAlQamar: json["SharoqAlQamar"],
        shqaroq: json["Shqaroq"],
        timezone: json["Timezone"],
        year: json["Year"],
        zuhr: json["Zuhr"],
      );
}
