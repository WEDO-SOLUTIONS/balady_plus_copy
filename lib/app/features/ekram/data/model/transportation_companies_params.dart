class TransportationCompaniesParams {
  int? cemeteryId;
  int? deathCityId;

  TransportationCompaniesParams({this.cemeteryId, this.deathCityId});

  Map<String, dynamic> toJson() => {
        'cemeteryId': cemeteryId,
        'deathCityId': deathCityId,
      };
}
