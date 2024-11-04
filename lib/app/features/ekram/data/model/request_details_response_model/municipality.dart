class Municipality {
  String? subMunicipalityId;
  int? baladiaId;
  String? subMunicipalityName;
  String? municipalityId;
  int? amanaId;
  String? municipalityName;
  int? cityId;
  String? cityName;

  Municipality({
    this.subMunicipalityId,
    this.baladiaId,
    this.subMunicipalityName,
    this.municipalityId,
    this.amanaId,
    this.municipalityName,
    this.cityId,
    this.cityName,
  });

  factory Municipality.fromJson(Map<String, dynamic> json) => Municipality(
        subMunicipalityId: json['subMunicipalityId'] as String?,
        baladiaId: json['baladiaId'] as int?,
        subMunicipalityName: json['subMunicipalityName'] as String?,
        municipalityId: json['municipalityId'] as String?,
        amanaId: json['amanaId'] as int?,
        municipalityName: json['municipalityName'] as String?,
        cityId: json['cityId'] as int?,
        cityName: json['cityName'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'subMunicipalityId': subMunicipalityId,
        'baladiaId': baladiaId,
        'subMunicipalityName': subMunicipalityName,
        'municipalityId': municipalityId,
        'amanaId': amanaId,
        'municipalityName': municipalityName,
        'cityId': cityId,
        'cityName': cityName,
      };
}
