// ignore_for_file: public_member_api_docs, sort_constructors_first

import '../../domain/entities/compliance_gis_resopnse.dart';

class ComplainceGISResponseModel extends ComplainceGISResponse {
  ComplainceGISResponseModel(
      {super.amanaCode,
      super.amanaName,
      super.municipalityCode,
      super.municipalityName,
      super.districtCode,
      super.districtName,
      super.streetName,
      super.streetCode,
      super.city,
      super.cityCode,
      super.planName,
      super.planNo,
      super.parcelNo,
      super.area,
      super.region,
      super.regionCode,
      super.imageUrl,
      super.guid,
      super.targetBuilding});

  factory ComplainceGISResponseModel.fromJson(Map<String, dynamic> json) =>
      ComplainceGISResponseModel(
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
          guid: json["ParcelBuilding"]?[0]?["GUID"]);
}
