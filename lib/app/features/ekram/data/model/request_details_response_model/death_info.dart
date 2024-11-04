import 'age.dart';

class DeathInfo {
  String? deathDate;
  String? gregorianDeathDate;
  int? countryId;
  String? countryName;
  bool? localCountry;
  int? regionId;
  String? regionName;
  int? cityId;
  String? cityName;
  int? hospitalId;
  String? hospitalName;
  bool? showHospitalOther;
  bool? caseContagious;
  bool? deathByQasas;
  Age? age;

  DeathInfo({
    this.deathDate,
    this.gregorianDeathDate,
    this.countryId,
    this.countryName,
    this.localCountry,
    this.regionId,
    this.regionName,
    this.cityId,
    this.cityName,
    this.hospitalId,
    this.hospitalName,
    this.showHospitalOther,
    this.caseContagious,
    this.deathByQasas,
    this.age,
  });

  factory DeathInfo.fromJson(Map<String, dynamic> json) => DeathInfo(
        deathDate: json['deathDate'] as String?,
        gregorianDeathDate: json['gregorianDeathDate'] as String?,
        countryId: json['countryId'] as int?,
        countryName: json['countryName'] as String?,
        localCountry: json['localCountry'] as bool?,
        regionId: json['regionId'] as int?,
        regionName: json['regionName'] as String?,
        cityId: json['cityId'] as int?,
        cityName: json['cityName'] as String?,
        hospitalId: json['hospitalId'] as int?,
        hospitalName: json['hospitalName'] as String?,
        showHospitalOther: json['showHospitalOther'] as bool?,
        caseContagious: json['caseContagious'] as bool?,
        deathByQasas: json['deathByQasas'] as bool?,
        age: json['age'] == null
            ? null
            : Age.fromJson(json['age'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'deathDate': deathDate,
        'gregorianDeathDate': gregorianDeathDate,
        'countryId': countryId,
        'countryName': countryName,
        'localCountry': localCountry,
        'regionId': regionId,
        'regionName': regionName,
        'cityId': cityId,
        'cityName': cityName,
        'hospitalId': hospitalId,
        'hospitalName': hospitalName,
        'showHospitalOther': showHospitalOther,
        'caseContagious': caseContagious,
        'deathByQasas': deathByQasas,
        'age': age?.toJson(),
      };
}
