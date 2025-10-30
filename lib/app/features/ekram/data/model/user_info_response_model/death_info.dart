class DeathInfo {
  dynamic deathReportNumber;
  String? deathDate;
  int? hijriDeathDate;
  int? gregDeathDate;
  int? countryId;
  String? countryName;
  int? regionId;
  String? regionName;
  int? cityId;
  String? cityName;
  dynamic cityOther;
  dynamic hospitalId;
  dynamic hospitalName;
  dynamic hospitalOther;
  dynamic deathCause;
  bool? caseContagious;

  DeathInfo({
    this.deathReportNumber,
    this.deathDate,
    this.hijriDeathDate,
    this.gregDeathDate,
    this.countryId,
    this.countryName,
    this.regionId,
    this.regionName,
    this.cityId,
    this.cityName,
    this.cityOther,
    this.hospitalId,
    this.hospitalName,
    this.hospitalOther,
    this.deathCause,
    this.caseContagious,
  });

  factory DeathInfo.fromJson(Map<String, dynamic> json) => DeathInfo(
        deathReportNumber: json['deathReportNumber'] as dynamic,
        deathDate: json['deathDate'] as String?,
        hijriDeathDate: json['hijriDeathDate'] as int?,
        gregDeathDate: json['gregDeathDate'] as int?,
        countryId: json['countryId'] as int?,
        countryName: json['countryName'] as String?,
        regionId: json['regionId'] as int?,
        regionName: json['regionName'] as String?,
        cityId: json['cityId'] as int?,
        cityName: json['cityName'] as String?,
        cityOther: json['cityOther'] as dynamic,
        hospitalId: json['hospitalId'] as dynamic,
        hospitalName: json['hospitalName'] as dynamic,
        hospitalOther: json['hospitalOther'] as dynamic,
        deathCause: json['deathCause'] as dynamic,
        caseContagious: json['caseContagious'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        'deathReportNumber': deathReportNumber,
        'deathDate': deathDate,
        'hijriDeathDate': hijriDeathDate,
        'gregDeathDate': gregDeathDate,
        'countryId': countryId,
        'countryName': countryName,
        'regionId': regionId,
        'regionName': regionName,
        'cityId': cityId,
        'cityName': cityName,
        'cityOther': cityOther,
        'hospitalId': hospitalId,
        'hospitalName': hospitalName,
        'hospitalOther': hospitalOther,
        'deathCause': deathCause,
        'caseContagious': caseContagious,
      };
}
