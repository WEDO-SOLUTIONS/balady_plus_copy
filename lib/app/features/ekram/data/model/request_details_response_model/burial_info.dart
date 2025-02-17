
import 'package:balady_plus/app/features/new_appointment/presentation/core/models/lookup_list_model.dart';

class BurialInfo {
  String? permitNumber;
  String? burialDate;
  String? gregorianBurialDate;
  int? prayId;
 // LookUpItem? pray;
  String? prayName;
  String? burialTime;
  String? ghuslMethod;
  int? cityId;
  String? cityName;
  String? burialDestination;
  String? burialDestinationName;
  int? approvalStatusId;
  String? approvalStatusName;
  String? approvalDate;
  bool? isBurialInsideDeathCity;

  BurialInfo({
    this.permitNumber,
    this.burialDate,
    this.gregorianBurialDate,
    this.prayId,
   // this.pray,
    this.prayName,
    this.burialTime,
    this.ghuslMethod,
    this.cityId,
    this.cityName,
    this.burialDestination,
    this.burialDestinationName,
    this.approvalStatusId,
    this.approvalStatusName,
    this.approvalDate,
    this.isBurialInsideDeathCity,
  });

  factory BurialInfo.fromJson(Map<String, dynamic> json) => BurialInfo(
        permitNumber: json['permitNumber'] as String?,
        burialDate: json['burialDate'] as String?,
        gregorianBurialDate: json['gregorianBurialDate'] as String?,
        prayId: json['prayId'] as int?,
        prayName: json['prayName'] as String?,
        burialTime: json['prayOther'] as String?,
        ghuslMethod: json['ghuslMethod'] as String?,
        cityId: json['cityId'] as int?,
        cityName: json['cityName'] as String?,
        burialDestination: json['burialDestination'] as String?,
        burialDestinationName: json['burialDestinationName'] as String?,
        approvalStatusId: json['approvalStatusId'] as int?,
        approvalStatusName: json['approvalStatusName'] as String?,
        approvalDate: json['approvalDate'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'permitNumber': permitNumber,
        'burialDate': burialDate,
        'gregorianBurialDate': gregorianBurialDate,
        'prayId': prayId,
        'prayOther': burialTime,
        'prayName': prayName,
        'ghuslMethod': ghuslMethod,
        'cityId': cityId,
        'cityName': cityName,
        'burialDestination': burialDestination,
        'burialDestinationName': burialDestinationName,
        'approvalStatusId': approvalStatusId,
        'approvalStatusName': approvalStatusName,
        'approvalDate': approvalDate,
        'isBurialInsideDeathCity': isBurialInsideDeathCity,
      };


  BurialInfo copyWith({
    String? permitNumber,
    String? burialDate,
    String? gregorianBurialDate,
    int? prayId,
    LookUpItem? pray,
    String? prayName,
    String? burialTime,
    String? ghuslMethod,
    int? cityId,
    String? cityName,
    String? burialDestination,
    String? burialDestinationName,
    int? approvalStatusId,
    String? approvalStatusName,
    String? approvalDate,
    bool? isBurialInsideDeathCity,
  }) =>
      BurialInfo(
        permitNumber: permitNumber ?? this.permitNumber,
        burialDate: burialDate ?? this.burialDate,
        gregorianBurialDate: gregorianBurialDate ?? this.gregorianBurialDate,
        prayId: prayId ?? this.prayId,
      //  pray: pray ?? this.pray,
        prayName: prayName ?? this.prayName,
        burialTime: burialTime ?? this.burialTime,
        ghuslMethod: ghuslMethod ?? this.ghuslMethod,
        cityId: cityId ?? this.cityId,
        cityName: cityName ?? this.cityName,
        burialDestination: burialDestination ?? this.burialDestination,
        burialDestinationName: burialDestinationName ?? this.burialDestinationName,
        approvalStatusId: approvalStatusId ?? this.approvalStatusId,
        approvalStatusName: approvalStatusName ?? this.approvalStatusName,
        approvalDate: approvalDate ?? this.approvalDate,
        isBurialInsideDeathCity: isBurialInsideDeathCity ?? this.isBurialInsideDeathCity,
      );

        bool isPrayerChanged(int? newId) {
    if (newId != null) {
      if (prayId != newId) {
        return true;
      }
    }
    return false;
  }
        bool isCityChanged(int? newId) {
    if (newId != null) {
      if (cityId != newId) {
        return true;
      }
    }
    return false;
  }

}
