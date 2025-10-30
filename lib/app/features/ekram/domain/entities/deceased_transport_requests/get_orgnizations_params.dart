class GetOrgnizationsParams {
  int deathCityId;
  int transportLocationId;
  int cemeteryId;
  String burialDate;
  int burailTimeId;
  GetOrgnizationsParams({
    required this.deathCityId,
    required this.transportLocationId,
    required this.cemeteryId,
    required this.burialDate,
    required this.burailTimeId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'deathCityId': deathCityId,
      'transportLocationId': transportLocationId,
      'cemeteryId': cemeteryId,
      'burialDate': burialDate,
      'burailTimeId': burailTimeId,
    };
  }
}
