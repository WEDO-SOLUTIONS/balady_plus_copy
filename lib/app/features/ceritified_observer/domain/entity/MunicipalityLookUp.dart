class MunicipalityLookUp {
  MunicipalityLookUp({
    this.municipalityName,
    this.municipalityID,
  });

  MunicipalityLookUp.fromJson(dynamic json) {
    municipalityName = json['MunicipalityName'];
    municipalityID = json['MunicipalityID'];
  }

  String? municipalityName;
  String? municipalityID;

  MunicipalityLookUp copyWith({
    String? municipalityName,
    String? municipalityID,
  }) =>
      MunicipalityLookUp(
        municipalityName: municipalityName ?? this.municipalityName,
        municipalityID: municipalityID ?? this.municipalityID,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['MunicipalityName'] = municipalityName;
    map['MunicipalityID'] = municipalityID;
    return map;
  }
}
