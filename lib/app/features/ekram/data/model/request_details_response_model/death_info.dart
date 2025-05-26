import 'age.dart';

class DeathInfo {
  String? deathDate;
  String? gregorianDeathDate;
  int countryId;
  String? countryName;
  bool? localCountry;
  int? regionId;
  String? regionName;
  int? cityId;
  String? cityName;
  int? hospitalId;
  String? hospitalName;
  bool? showHospitalOther;
  String? hospitalOther;
  bool? caseContagious;
  bool? deathByQasas;
  Age? age;
  int? corpseArrivalCityId;
  String? cityOther;
  DeathInfo({
    this.deathDate,
    this.gregorianDeathDate,
    this.countryId = 1,
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
    this.corpseArrivalCityId,
    this.cityOther,
    this.hospitalOther,
  });

  factory DeathInfo.fromJson(Map<String, dynamic> json) => DeathInfo(
        deathDate: json['deathDate'] as String?,
        gregorianDeathDate: json['gregorianDeathDate'] as String?,
        countryId:  json['countryId'] == null? 1: json['countryId'] as int,
        countryName: json['countryName'] as String?,
        localCountry: json['localCountry'] as bool?,
        regionId: json['regionId'] as int?,
        regionName: json['regionName'] as String?,
        cityId: json['cityId'] as int?,
        corpseArrivalCityId: json['corpseArrivalCityId'] as int?,
        hospitalOther:json["hospitalOther"]as String?,
        cityOther: json['cityOther'] as String?,
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
         "corpseArrivalCityId":corpseArrivalCityId,
        'cityId': cityId,
        'cityName': cityName,
        'cityOther': cityOther,
        'hospitalOther': hospitalOther,
        'hospitalId': hospitalId,
        'hospitalName': hospitalName,
        'showHospitalOther': showHospitalOther,
        'caseContagious': caseContagious,
        'deathByQasas': deathByQasas,
        'age': null,
      };

  DeathInfo copyWith({  String? deathDate,
    String? gregorianDeathDate,
    int ?countryId,
    String? countryName,
    bool? localCountry,
    int? regionId,
    String? regionName,
    int? cityId,
    int? corpseArrivalCityId,
    String? cityOther,
    String? hospitalOther,
    String? cityName,
    int? hospitalId,
    String? hospitalName,
    bool? showHospitalOther,
    bool? caseContagious,
    bool? deathByQasas,
    Age? age,
  }) => DeathInfo(
    deathDate: deathDate ?? this.deathDate,
    gregorianDeathDate: gregorianDeathDate ?? this.gregorianDeathDate,
    countryId: countryId ?? this.countryId,
    countryName: countryName ?? this.countryName,
    localCountry: localCountry ?? this.localCountry,
    regionId: regionId ?? this.regionId,
    regionName: regionName ?? this.regionName,
    cityId: cityId ?? this.cityId,
    corpseArrivalCityId: corpseArrivalCityId ?? this.corpseArrivalCityId,
    cityName: cityName ?? this.cityName,
    hospitalOther:hospitalOther??this.hospitalOther,
    cityOther: cityOther ?? this.cityOther,
    hospitalId: hospitalId ?? this.hospitalId,
    hospitalName: hospitalName ?? this.hospitalName,
    showHospitalOther: showHospitalOther ?? this.showHospitalOther,
    caseContagious: caseContagious ?? this.caseContagious,
    deathByQasas: deathByQasas ?? this.deathByQasas,
    age: age ?? this.age,
  );



  bool isCityChanged(int? newCityId) {
    if (newCityId != null) {
      if (countryId == 1) {
        if (cityId != newCityId) {
          return true;
        }
      } else {
        if (corpseArrivalCityId != newCityId) {
          return true;
        }
      }
    }
    return false;
  }
  bool isCountryChanged(int? newCountryId) {
    if (newCountryId != null) {
      if (countryId != newCountryId) {
        return true;
      }
    }
    return false;
  }

  bool isHostpitalChanged(int? newId) {
    if (newId != null) {
      if (hospitalId != newId) {
        return true;
      }
    }
    return false;
  }
}
