import 'package:equatable/equatable.dart';

class GISResponse extends Equatable {
  String? adminMunicipalityId;
  String? adminMunicipalityName;
  String? districtId;
  String? districtName;
  String? following;
  String? municipalityuniquecode;
  String? municipalityId;
  String? municipalityName;
  String? region;
  String? streetCode;
  String? streetName;
  String? cityName;
  //dynamic subDistrictId;
  //dynamic subDistrictName;
  String? subMunicipalityId;
  String? subMunicipalityName;
  String? subMunicipalityCategory;
  String? subMunicipalityguid;
  String? parcelNo;
  String? planNo;
  bool? vdExcepted;
  bool? vdPriority;
  String? locationURL;
  String? Balady_DistrictID;
  String? Balady_DistrictName;

  GISResponse({
    this.adminMunicipalityId,
    this.adminMunicipalityName,
    this.cityName,
    this.Balady_DistrictID,
    this.Balady_DistrictName,
    // this.cleanInfo,
    this.districtId,
    this.districtName,
    this.following,
    // this.lightInfo,
    this.municipalityuniquecode,
    this.municipalityId,
    this.municipalityName,
    this.region,
    this.streetCode,
    this.streetName,
    // this.subDistrictId,
    // this.subDistrictName,
    this.subMunicipalityId,
    this.subMunicipalityName,
    this.subMunicipalityCategory,
    this.subMunicipalityguid,
    this.parcelNo,
    this.planNo,
    this.vdExcepted,
    this.vdPriority,
    this.locationURL,
  });

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

    if (includeStreetName && streetName != null && streetName.toLowerCase() != "null" && streetName.isNotEmpty) {
      address += "$streetName, ";
    }

    if (includeDistrictName &&
        districtName != null &&
        districtName.toLowerCase() != "null" &&
        districtName.isNotEmpty) {
      address += "$districtName, ";
    }

    if (includeSubMunicipalityName &&
        subMunicipalityName != null &&
        subMunicipalityName.toLowerCase() != "null" &&
        subMunicipalityName.isNotEmpty) {
      address += "$subMunicipalityName, ";
    }

    if (includeAdminMunicipalityName && adminMunicipalityName != null && adminMunicipalityName.isNotEmpty) {
      address += adminMunicipalityName;
    }

    return address;
  }

  String getEnhancedFullAddress({
    bool includeStreetName = true,
    bool includeDistrictName = true,
    bool includeSubMunicipalityName = true,
    bool includeMunicipalityName = true,
  }) {
    String address = "";
    var streetName = this.streetName;
    var districtName = this.districtName;
    var subMunicipalityName = this.subMunicipalityName;
    var municipalityName = this.municipalityName;

    if (includeStreetName && streetName != null && streetName.toLowerCase() != "null" && streetName.isNotEmpty) {
      address += "$streetName, ";
    }

    if (includeDistrictName &&
        districtName != null &&
        districtName.toLowerCase() != "null" &&
        districtName.isNotEmpty) {
      address += "$districtName, ";
    }

    if (includeSubMunicipalityName &&
        subMunicipalityName != null &&
        subMunicipalityName.toLowerCase() != "null" &&
        subMunicipalityName.isNotEmpty) {
      address += "$subMunicipalityName, ";
    }

    if (includeMunicipalityName && municipalityName != null && municipalityName.isNotEmpty) {
      address += municipalityName;
    }

    return address;
  }

  bool isVDExcepted() {
    return vdExcepted ?? false;
  }

  @override
  List<Object?> get props => [
    adminMunicipalityId,
    districtId,
    municipalityuniquecode,
    municipalityId,
    subMunicipalityId,
    subMunicipalityCategory,
    subMunicipalityguid,
    streetCode,
    locationURL,
    cityName,
  ];
}
