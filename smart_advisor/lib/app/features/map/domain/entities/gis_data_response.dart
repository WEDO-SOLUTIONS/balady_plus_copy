class GisDataResponse {
  final String? adminMunicipalityId;
  final String? adminMunicipalityName;
  final String? amanaCode;
  final String? amanaName;
  final String? baladyDistrictId;
  final String? baladyDistrictName;
  final String? cityName;
  final dynamic cleanInfo;
  final dynamic districtId;
  final String? districtName;
  final String? following;
  final bool? isWithinArcheologicalZones;
  final bool? isWithinHpZones;
  final bool? isWithinNeomZones;
  final dynamic lightInfo;
  final String? locationUrl;
  final String? municipalityuniquecode;
  final String? municipalityId;
  final String? municipalityName;
  final String? region;
  final String? streetCode;
  final String? streetName;
  final dynamic subDistrictId;
  final dynamic subDistrictName;
  final String? subMunicipalityId;
  final String? subMunicipalityName;
  final String? subMunicipalityguid;
  final dynamic parcelNo;
  final dynamic planNo;
  final bool? isVillage;

  GisDataResponse(
      {this.adminMunicipalityId,
      this.adminMunicipalityName,
      this.amanaCode,
      this.amanaName,
      this.baladyDistrictId,
      this.baladyDistrictName,
      this.cityName,
      this.cleanInfo,
      this.districtId,
      this.districtName,
      this.following,
      this.isWithinArcheologicalZones,
      this.isWithinHpZones,
      this.isWithinNeomZones,
      this.lightInfo,
      this.locationUrl,
      this.municipalityuniquecode,
      this.municipalityId,
      this.municipalityName,
      this.region,
      this.streetCode,
      this.streetName,
      this.subDistrictId,
      this.subDistrictName,
      this.subMunicipalityId,
      this.subMunicipalityName,
      this.subMunicipalityguid,
      this.parcelNo,
      this.planNo,
      this.isVillage});

  String getFullAddress({
    bool includeStreetName = true,
    bool includeDistrictName = true,
    bool includeSubMunicipalityName = true,
    bool includeAdminMunicipalityName = true,
  }) {
    String address = "";
    var streetName = this.streetName;
    var districtName = this.districtName;
    var subMunicipalityName = this.subMunicipalityName;
    var adminMunicipalityName = this.adminMunicipalityName;

    if (includeStreetName &&
        streetName != null &&
        streetName.toLowerCase() != "null" &&
        streetName.isNotEmpty) address += "$streetName, ";

    if (includeDistrictName &&
        districtName != null &&
        districtName.toLowerCase() != "null" &&
        districtName.isNotEmpty) address += "$districtName, ";

    if (includeSubMunicipalityName &&
        subMunicipalityName != null &&
        subMunicipalityName.toLowerCase() != "null" &&
        subMunicipalityName.isNotEmpty) address += "$subMunicipalityName, ";

    if (includeAdminMunicipalityName &&
        adminMunicipalityName != null &&
        adminMunicipalityName.isNotEmpty) {
      address += adminMunicipalityName;
    }

    return address;
  }

  Map<String, dynamic> toJson() => {
        "Admin_MunicipalityID": adminMunicipalityId,
        "Admin_MunicipalityName": adminMunicipalityName,
        "AmanaCode": amanaCode,
        "AmanaName": amanaName,
        "Balady_DistrictID": baladyDistrictId,
        "Balady_DistrictName": baladyDistrictName,
        "CityName": cityName,
        "CleanInfo": cleanInfo,
        "DistrictID": districtId,
        "DistrictName": districtName,
        "Following": following,
        "IsWithinArcheologicalZones": isWithinArcheologicalZones,
        "IsWithinHPZones": isWithinHpZones,
        "IsWithinNeomZones": isWithinNeomZones,
        "LightInfo": lightInfo,
        "LocationURL": locationUrl,
        "MUNICIPALITYUNIQUECODE": municipalityuniquecode,
        "MunicipalityID": municipalityId,
        "MunicipalityName": municipalityName,
        "Region": region,
        "StreetCode": streetCode,
        "StreetName": streetName,
        "SubDistrictID": subDistrictId,
        "SubDistrictName": subDistrictName,
        "Sub_MunicipalityID": subMunicipalityId,
        "Sub_MunicipalityName": subMunicipalityName,
        "Sub_Municipalityguid": subMunicipalityguid,
        "parcel_No": parcelNo,
        "plan_No": planNo,
        "isVillage": isVillage
      };
}
