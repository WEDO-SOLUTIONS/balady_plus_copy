class CemetriesParams {
  int? deathCountryId;
  int? deathCityId;
  int? burialCityId;
  dynamic specialTransportReasonId;
  int? prayId;
  String? burialDate;
  String? deathDate;
  int? graveTypeId;
  dynamic age;

  CemetriesParams({
    this.deathCountryId,
    this.deathCityId,
    this.burialCityId,
    this.specialTransportReasonId,
    this.prayId,
    this.burialDate,
    this.deathDate,
    this.graveTypeId,
    this.age,
  });

  factory CemetriesParams.fromJson(Map<String, dynamic> json) {
    return CemetriesParams(
      deathCountryId: json['deathCountryId'] as int?,
      deathCityId: json['deathCityId'] as int?,
      burialCityId: json['burialCityId'] as int?,
      specialTransportReasonId: json['specialTransportReasonId'] as dynamic,
      prayId: json['prayId'] as int?,
      burialDate: json['burialDate'] as String?,
      deathDate: json['deathDate'] as String?,
      graveTypeId: json['graveTypeId'] as int?,
      age: json['age'] as dynamic,
    );
  }

  Map<String, dynamic> toJson() => {
        'deathCountryId': deathCountryId,
        'deathCityId': deathCityId,
        'burialCityId': burialCityId,
        'specialTransportReasonId': specialTransportReasonId,
        'prayId': prayId,
        'burialDate': burialDate,
        'deathDate': deathDate,
        'graveTypeId': graveTypeId,
        'age': age,
      };
}
