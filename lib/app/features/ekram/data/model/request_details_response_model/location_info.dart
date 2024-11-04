class LocationInfo {
  String? subMunicipalityId;
  String? subMunicipalityName;
  String? municipalityId;
  String? municipalityName;
  dynamic districtId;
  dynamic districtName;
  dynamic streetId;
  dynamic streetName;
  dynamic centerPoint;
  dynamic krookyUrl;
  dynamic locationAddress;
  String? amanaCode;

  LocationInfo({
    this.subMunicipalityId,
    this.subMunicipalityName,
    this.municipalityId,
    this.municipalityName,
    this.districtId,
    this.districtName,
    this.streetId,
    this.streetName,
    this.centerPoint,
    this.krookyUrl,
    this.locationAddress,
    this.amanaCode,
  });

  factory LocationInfo.fromJson(Map<String, dynamic> json) => LocationInfo(
        subMunicipalityId: json['subMunicipalityId'] as String?,
        subMunicipalityName: json['subMunicipalityName'] as String?,
        municipalityId: json['municipalityId'] as String?,
        municipalityName: json['municipalityName'] as String?,
        districtId: json['districtId'] as dynamic,
        districtName: json['districtName'] as dynamic,
        streetId: json['streetId'] as dynamic,
        streetName: json['streetName'] as dynamic,
        centerPoint: json['centerPoint'] as dynamic,
        krookyUrl: json['krookyUrl'] as dynamic,
        locationAddress: json['locationAddress'] as dynamic,
        amanaCode: json['amanaCode'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'subMunicipalityId': subMunicipalityId,
        'subMunicipalityName': subMunicipalityName,
        'municipalityId': municipalityId,
        'municipalityName': municipalityName,
        'districtId': districtId,
        'districtName': districtName,
        'streetId': streetId,
        'streetName': streetName,
        'centerPoint': centerPoint,
        'krookyUrl': krookyUrl,
        'locationAddress': locationAddress,
        'amanaCode': amanaCode,
      };
}
