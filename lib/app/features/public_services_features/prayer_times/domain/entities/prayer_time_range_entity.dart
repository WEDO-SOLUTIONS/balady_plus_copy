import 'package:equatable/equatable.dart';

class PrayerTimeRangeEntity extends Equatable {
  final String asr;
  final String day;
  final String fajr;
  final String gharobAlQamar;
  final String isha;
  final String magrib;
  final String month;
  final String sharoqAlQamar;
  final String shqaroq;
  final String timezone;
  final String year;
  final String zuhr;

  const PrayerTimeRangeEntity({
    required this.asr,
    required this.day,
    required this.fajr,
    required this.gharobAlQamar,
    required this.isha,
    required this.magrib,
    required this.month,
    required this.sharoqAlQamar,
    required this.shqaroq,
    required this.timezone,
    required this.year,
    required this.zuhr,
  });

  DateTime get asrDateTime => DateTime(
        int.parse(year),
        int.parse(month),
        int.parse(day),
        int.parse(asr.split(":").first),
        int.parse(asr.split(":").last),
      );
  DateTime get fajrDateTime => DateTime(
        int.parse(year),
        int.parse(month),
        int.parse(day),
        int.parse(fajr.split(":").first),
        int.parse(fajr.split(":").last),
      );
  DateTime get ishaDateTime => DateTime(
        int.parse(year),
        int.parse(month),
        int.parse(day),
        int.parse(isha.split(":").first),
        int.parse(isha.split(":").last),
      );
  DateTime get magribDateTime => DateTime(
        int.parse(year),
        int.parse(month),
        int.parse(day),
        int.parse(magrib.split(":").first),
        int.parse(magrib.split(":").last),
      );
  DateTime get zuhrDateTime => DateTime(
        int.parse(year),
        int.parse(month),
        int.parse(day),
        int.parse(zuhr.split(":").first),
        int.parse(zuhr.split(":").last),
      );

  int get asrId => int.parse("$year$month$day${"003"}");
  int get fajrId => int.parse("$year$month$day${"001"}");
  int get ishaId => int.parse("$year$month$day${"005"}");
  int get magribId => int.parse("$year$month$day${"004"}");
  int get zuhrId => int.parse("$year$month$day${"002"}");

  @override
  List<Object> get props => [
        asr,
        day,
        fajr,
        gharobAlQamar,
        isha,
        magrib,
        month,
        sharoqAlQamar,
        shqaroq,
        timezone,
        year,
        zuhr,
      ];

  PrayerTimeRangeEntity copyWith({
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
  }) {
    return PrayerTimeRangeEntity(
      asr: asr ?? this.asr,
      day: day ?? this.day,
      fajr: fajr ?? this.fajr,
      gharobAlQamar: gharobAlQamar ?? this.gharobAlQamar,
      isha: isha ?? this.isha,
      magrib: magrib ?? this.magrib,
      month: month ?? this.month,
      sharoqAlQamar: sharoqAlQamar ?? this.sharoqAlQamar,
      shqaroq: shqaroq ?? this.shqaroq,
      timezone: timezone ?? this.timezone,
      year: year ?? this.year,
      zuhr: zuhr ?? this.zuhr,
    );
  }

  factory PrayerTimeRangeEntity.fromJson(Map<String, dynamic> json) =>
      PrayerTimeRangeEntity(
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

  Map<String, dynamic> toJson() => {
        "Asr": asr,
        "Day": day,
        "Fajr": fajr,
        "GharobAlQamar": gharobAlQamar,
        "Isha": isha,
        "Magrib": magrib,
        "Month": month,
        "SharoqAlQamar": sharoqAlQamar,
        "Shqaroq": shqaroq,
        "Timezone": timezone,
        "Year": year,
        "Zuhr": zuhr,
      };
}
