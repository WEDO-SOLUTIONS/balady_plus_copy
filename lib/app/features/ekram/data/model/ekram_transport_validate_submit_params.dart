class EkramTransportValidateSubmitParams {
  dynamic subMunicipalityId;
  dynamic subMunicipalityName;
  dynamic municipalityId;
  dynamic municipalityName;
  dynamic districtId;
  dynamic districtName;
  dynamic streetId;
  dynamic streetName;
  dynamic centerPoint;
  dynamic krookyUrl;
  String? locationAddress;
  dynamic amanaCode;

  EkramTransportValidateSubmitParams(
      {this.subMunicipalityId,
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
      this.amanaCode});

  EkramTransportValidateSubmitParams.fromJson(Map<String, dynamic> json) {
    subMunicipalityId = json["subMunicipalityId"];
    subMunicipalityName = json["subMunicipalityName"];
    municipalityId = json["municipalityId"];
    municipalityName = json["municipalityName"];
    districtId = json["districtId"];
    districtName = json["districtName"];
    streetId = json["streetId"];
    streetName = json["streetName"];
    centerPoint = json["centerPoint"];
    krookyUrl = json["krookyUrl"];
    if (json["locationAddress"] is String) {
      locationAddress = json["locationAddress"];
    }
    amanaCode = json["amanaCode"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["subMunicipalityId"] = null;
    data["subMunicipalityName"] = null;
    data["municipalityId"] = null;
    data["municipalityName"] = null;
    data["districtId"] = null;
    data["districtName"] = null;
    data["streetId"] = null;
    data["streetName"] = null;
    data["centerPoint"] = null;
    data["krookyUrl"] = null;
    data["locationAddress"] = null;
    data["amanaCode"] = null;
    return data;
  }
}
