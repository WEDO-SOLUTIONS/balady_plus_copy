// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class ComplainceGISResponse extends Equatable {
  final String? amanaCode;
  final String? amanaName;
  final String? municipalityCode;
  final String? municipalityName;
  final String? districtCode;
  final String? districtName;
  final String? streetName;
  final String? streetCode;
  final String? city;
  final String? cityCode;
  final String? planName;
  final String? planNo;
  final String? parcelNo;
  final String? area;
  final String? region;
  final String? regionCode;
  final dynamic imageUrl;
  final String? guid;
  final bool? targetBuilding;
  // Local Variable
  bool? isEmtithalMand;
  ComplainceGISResponse(
      {this.amanaCode,
      this.amanaName,
      this.municipalityCode,
      this.municipalityName,
      this.districtCode,
      this.districtName,
      this.streetName,
      this.streetCode,
      this.city,
      this.cityCode,
      this.planName,
      this.planNo,
      this.parcelNo,
      this.area,
      this.region,
      this.regionCode,
      this.imageUrl,
      this.guid,
      this.targetBuilding,
      this.isEmtithalMand});

  factory ComplainceGISResponse.fromJson(Map<String, dynamic> json) {
    return ComplainceGISResponse(
      amanaCode: json["Amana_code"],
      amanaName: json["Amana_Name"],
      municipalityCode: json["MunicipalityCode"],
      municipalityName: json["MunicipalityName"],
      districtCode: json["DistrictCode"],
      districtName: json["DistrictName"],
      streetName: json["StreetName"],
      streetCode: json["StreetCode"],
      city: json["City"],
      cityCode: json["CityCode"],
      planName: json["PlanName"],
      planNo: json["PlanNO"],
      parcelNo: json["ParcelNo"],
      area: json["Area"],
      region: json["Region"],
      regionCode: json["RegionCode"],
      imageUrl: json["ImageUrl"],
      targetBuilding: json["TargetBuilding"],
      guid: json["ParcelBuilding"]?[0]?["GUID"],
    );
  }

  @override
  List<Object?> get props => [
        amanaCode,
        amanaName,
        municipalityCode,
        municipalityName,
        districtCode,
        districtName,
        streetName,
        streetCode,
        city,
        cityCode,
        planName,
        planNo,
        parcelNo,
        area,
        region,
        regionCode,
        imageUrl,
        guid,
        targetBuilding,
        isEmtithalMand
      ];

  String getFullAddress({
    bool includeStreetName = true,
    bool includeDistrictName = true,
    bool includeSubMunicipalityName = true,
    bool includeAdminMunicipalityName = true,
  }) {
    String address = "";
    var streetName = this.streetName;
    var districtName = this.districtName;
    var subMunicipalityName = this.municipalityName;
    var adminMunicipalityName = this.amanaName;

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
}
