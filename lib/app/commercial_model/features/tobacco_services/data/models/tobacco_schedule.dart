import 'package:balady_plus/app/commercial_model/features/tobacco_services/data/models/facility.dart';

class TobaccoSchedule {
  Facility facilityInfo;
  Map<int, List<DisclosureSchedule>> disclosureSchedules;
  Map<int, List<Disclosures>> disclosures;
  List<int> years;

  TobaccoSchedule({
    required this.facilityInfo,
    required this.disclosureSchedules,
    required this.disclosures,
    required this.years,
  });

  factory TobaccoSchedule.fromJson(Map<String, dynamic> json) {
    TobaccoSchedule tobaccoSchedule = TobaccoSchedule(
      facilityInfo: Facility.fromJson(json["facilityInfo"]),
      disclosureSchedules: {},
      disclosures: {},
      years: [],
    );

    for (var x in (json["disclosureSchedules"] ?? [])) {
      DisclosureSchedule disclosureSchedule = DisclosureSchedule.fromJson(x);
      if (tobaccoSchedule.disclosureSchedules[disclosureSchedule.year] ==
          null) {
        tobaccoSchedule.disclosureSchedules[disclosureSchedule.year] = [
          disclosureSchedule
        ];
        tobaccoSchedule.years.add(disclosureSchedule.year);
      } else {
        tobaccoSchedule.disclosureSchedules[disclosureSchedule.year]!
            .add(disclosureSchedule);
      }
    }
    for (var x in (json["disclosures"] ?? [])) {
      Disclosures disclosureSchedule = Disclosures.fromJson(x);
      if (tobaccoSchedule.disclosures[disclosureSchedule.year] == null) {
        tobaccoSchedule.disclosures[disclosureSchedule.year] = [
          disclosureSchedule
        ];
        if (!tobaccoSchedule.years.contains(disclosureSchedule.year)) {
          tobaccoSchedule.years.add(disclosureSchedule.year);
        }
      } else {
        tobaccoSchedule.disclosures[disclosureSchedule.year]!
            .add(disclosureSchedule);
      }
    }
    tobaccoSchedule.years.sort((x, y) => y.compareTo(x));
    return tobaccoSchedule;
  }
}

class DisclosureSchedule {
  String? disclosureScheduleId;
  int year;
  int month;
  double percentage;
  DateTime? createdDate;

  DisclosureSchedule({
    required this.disclosureScheduleId,
    required this.percentage,
    required this.year,
    required this.month,
    required this.createdDate,
  });

  factory DisclosureSchedule.fromJson(Map<String, dynamic> json) =>
      DisclosureSchedule(
        disclosureScheduleId: json["disclosureScheduleId"],
        percentage: (json["percentage"] ?? 0) + 1.0,
        year: json["year"] ?? 0,
        month: json["month"] ?? 0,
        createdDate: json["createdDate"] != null
            ? DateTime.parse(json["createdDate"])
            : null,
      );
}

class Disclosures {
  String? invoiceStatus;
  String? disclosureType;
  int year;
  int month;
  double percentage;
  double totalAmount;
  double tax;
  DateTime? createdDate;

  Disclosures({
    required this.invoiceStatus,
    required this.disclosureType,
    required this.percentage,
    required this.totalAmount,
    required this.tax,
    required this.year,
    required this.month,
    required this.createdDate,
  });

  factory Disclosures.fromJson(Map<String, dynamic> json) => Disclosures(
        invoiceStatus: json["invoiceStatus"],
        disclosureType: json["disclosureType"],
        percentage: (json["percentage"] ?? 0) + 0.0,
        totalAmount: (json["totalAmount"] ?? 0) + 0.0,
        tax: (json["tax"] ?? 0) + 0.0,
        year: json["year"] ?? 0,
        month: json["month"] ?? 0,
        createdDate: json["createdDate"] != null
            ? DateTime.parse(json["createdDate"])
            : null,
      );
}
