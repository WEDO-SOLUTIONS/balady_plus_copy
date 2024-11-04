class DeathInfo {
  String? deathDate;
  String? gregorianDeathDate;
  int? countryId;
  int? cityId;
  int? hospitalId;
  bool? caseContagious;
  bool? deathByQasas;

  DeathInfo({
    this.deathDate,
    this.gregorianDeathDate,
    this.countryId,
    this.cityId,
    this.hospitalId,
    this.caseContagious,
    this.deathByQasas,
  });

  Map<String, dynamic> toJson() => {
        'deathDate': deathDate,
        'gregorianDeathDate': gregorianDeathDate,
        'countryId': countryId,
        'cityId': cityId,
        'hospitalId': hospitalId,
        'caseContagious': caseContagious,
        'deathByQasas': deathByQasas,
      };
}
