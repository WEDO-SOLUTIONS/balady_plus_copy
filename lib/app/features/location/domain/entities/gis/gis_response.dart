import 'package:equatable/equatable.dart';

class GISResponse extends Equatable {
  final String? adminMunicipalityId;
  final String? adminMunicipalityName;
  final String? districtId;
  final String? districtName;
  final String? following;
  final String? municipalityuniquecode;
  final String? municipalityId;
  final String? municipalityName;
  final String? region;
  final String? streetCode;
  final String? streetName;
  final String? cityName;
  //dynamic subDistrictId;
  //dynamic subDistrictName;
  final String? subMunicipalityId;
  final String? subMunicipalityName;
  final String? subMunicipalityCategory;
  final String? subMunicipalityguid;
  final String? parcelNo;
  final String? planNo;
  final bool? vdExcepted;
  final bool? vdPriority;
  final String? locationURL;
  final String? baladyDistrictID;
  final String? baladyDistrictName;

  const GISResponse({
    this.adminMunicipalityId,
    this.adminMunicipalityName,
    this.cityName,
    this.baladyDistrictID,
    this.baladyDistrictName,
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
    final streetName = this.streetName;
    final districtName = this.districtName;
    final subMunicipalityName = this.subMunicipalityName;
    final adminMunicipalityName = this.adminMunicipalityName;

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
    final streetName = this.streetName;
    final districtName = this.districtName;
    final subMunicipalityName = this.subMunicipalityName;
    final municipalityName = this.municipalityName;

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
