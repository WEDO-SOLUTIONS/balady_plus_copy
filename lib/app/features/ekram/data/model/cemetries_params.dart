class CemetriesParams {
  int? deathCountryId;
  int? deathCityId;
  int? burialCityId;
  int? specialTransportReasonId;
  int? prayId;
  String? burialDate;
  String? burialTime;
  String? deathDate;
  int? graveTypeId;
  dynamic age;

  CemetriesParams({
   required this.deathCountryId,
   required this.deathCityId,
   required this.burialCityId,
   required this.specialTransportReasonId,
   required this.prayId,
   required this.burialTime,
   required this.burialDate,
   required this.deathDate,
   required this.graveTypeId,
   required this.age,
  });



  Map<String, dynamic> toJson() => {
        'deathCountryId': deathCountryId,
        'deathCityId': deathCityId,
        'burialCityId': burialCityId,
        'specialTransportReasonId': specialTransportReasonId,
        'prayId': prayId,
        'prayOther': burialTime,
        'burialDate': burialDate,
        'deathDate': deathDate,
        'graveTypeId': graveTypeId,
        'age': age,
      };
}
