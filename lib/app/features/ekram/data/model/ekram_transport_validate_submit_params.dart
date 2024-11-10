
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

  EkramTransportValidateSubmitParams({this.subMunicipalityId, this.subMunicipalityName, this.municipalityId, this.municipalityName, this.districtId, this.districtName, this.streetId, this.streetName, this.centerPoint, this.krookyUrl, this.locationAddress, this.amanaCode});

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
    if(json["locationAddress"] is String) {
      locationAddress = json["locationAddress"];
    }
    amanaCode = json["amanaCode"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["subMunicipalityId"] = subMunicipalityId;
    _data["subMunicipalityName"] = subMunicipalityName;
    _data["municipalityId"] = municipalityId;
    _data["municipalityName"] = municipalityName;
    _data["districtId"] = districtId;
    _data["districtName"] = districtName;
    _data["streetId"] = streetId;
    _data["streetName"] = streetName;
    _data["centerPoint"] = centerPoint;
    _data["krookyUrl"] = krookyUrl;
    _data["locationAddress"] = locationAddress;
    _data["amanaCode"] = amanaCode;
    return _data;
  }
}