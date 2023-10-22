import 'package:equatable/equatable.dart';

import '../../domain/entities/compliance_deed_info.dart';

class ComplianceDeedInfoModel extends ComplianceDeedInfo {
  ComplianceDeedInfoModel({
    super.deedSerialNumber,
    super.deedNumber,
    super.dateIssuanceDeed,
    super.issuerCourtCode,
    super.issuerCourtName,
    super.cityCode,
    super.cityName,
    super.deedStatus,
    super.deedArea,
    super.transactionTypeCode,
    super.transactionTypeName,
    super.isConstrained,
    super.isHalt,
    super.isPawned,
    super.isTestament,
    super.realEstateInfoModel,
    super.distanceAndBorderDeedModel,
    super.ownersInfoList,
    super.deedStatusCode,
  });

  factory ComplianceDeedInfoModel.fromJson(Map<String, dynamic> json) =>
      ComplianceDeedInfoModel(
        // deedSerialNumber: json["DeedSerialNumber"],
        deedNumber: json["deedNumber"],
        dateIssuanceDeed: json["deedIssuanceDate"],
        /* issuerCourtCode: json["IssuerCourtCode"],
        issuerCourtName: json["IssuerCourtName"],
        cityCode: json["CityCode"],
        cityName: json["CityName"],
        deedStatus: json["DeedStatus"],
        deedArea: json["DeedArea"],
        transactionTypeCode: json["TransactionTypeCode"],
        transactionTypeName: json["TransactionTypeName"],
        isConstrained: json["IsConstrained"],
        isHalt: json["IsHalt"],
        isPawned: json["IsPawned"],
        isTestament: json["IsTestament"],
        realEstateInfoModel: json["RealEstateInfoModel"] == null
            ? null
            : RealEstateInfoModel.fromJson(json["RealEstateInfoModel"]),
        distanceAndBorderDeedModel: json["DistanceAndBorderDeedModel"] == null
            ? null
            : DistanceAndBorderDeedModel.fromJson(
                json["DistanceAndBorderDeedModel"]),
        ownersInfoList: json["OwnersInfoList"] == null
            ? null
            : OwnersInfoListModel.fromJson(json["OwnersInfoList"]),
        deedStatusCode: json["DeedStatusCode"],*/
      );

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class DistanceAndBorderDeedModel extends DistanceAndBorderDeed {
  DistanceAndBorderDeedModel({
    super.northernBorder,
    super.southernBorder,
    super.easternBorder,
    super.westernBorder,
  });

  factory DistanceAndBorderDeedModel.fromJson(Map<String, dynamic> json) =>
      DistanceAndBorderDeedModel(
        northernBorder: json["NorthernBorder"] == null
            ? null
            : ErnBorderModel.fromJson(json["NorthernBorder"]),
        southernBorder: json["SouthernBorder"] == null
            ? null
            : ErnBorderModel.fromJson(json["SouthernBorder"]),
        easternBorder: json["EasternBorder"] == null
            ? null
            : ErnBorderModel.fromJson(json["EasternBorder"]),
        westernBorder: json["WesternBorder"] == null
            ? null
            : ErnBorderModel.fromJson(json["WesternBorder"]),
      );
}

class ErnBorderModel extends ErnBorder {
  ErnBorderModel({
    super.borderTypeCode,
    super.borderTypeString,
    super.borderDescription,
    super.borderDistance,
    super.borderDistanceString,
  });

  factory ErnBorderModel.fromJson(Map<String, dynamic> json) => ErnBorderModel(
        borderTypeCode: json["BorderTypeCode"],
        borderTypeString: json["BorderTypeString"],
        borderDescription: json["BorderDescription"],
        borderDistance: json["BorderDistance"],
        borderDistanceString: json["BorderDistanceString"],
      );
}

class OwnersInfoListModel extends OwnersInfoList {
  OwnersInfoListModel({
    super.ownerInfo,
  });

  factory OwnersInfoListModel.fromJson(Map<String, dynamic> json) =>
      OwnersInfoListModel(
        ownerInfo: json["OwnerInfo"] == null
            ? []
            : List<OwnerInfoModel>.from(
                json["OwnerInfo"]!.map((x) => OwnerInfoModel.fromJson(x))),
      );
}

class OwnerInfoModel extends OwnerInfo {
  OwnerInfoModel({
    super.deedSerialNumber,
    super.ownerSocialId,
    super.ownerSocialIdType,
    super.birthDate,
    super.ownerName,
    super.owningPercentage,
    super.owningArea,
    super.isDead,
  });

  factory OwnerInfoModel.fromJson(Map<String, dynamic> json) => OwnerInfoModel(
        deedSerialNumber: json["DeedSerialNumber"],
        ownerSocialId: json["OwnerSocialID"],
        ownerSocialIdType: json["OwnerSocialIDType"],
        birthDate: json["BirthDate"] == null
            ? null
            : BirthDateModel.fromJson(json["BirthDate"]),
        ownerName: json["OwnerName"],
        owningPercentage: json["OwningPercentage"],
        owningArea: json["OwningArea"]?.toDouble(),
        isDead: json["IsDead"],
      );
}

class BirthDateModel extends BirthDate {
  BirthDateModel({
    super.hijriDate,
  });

  factory BirthDateModel.fromJson(Map<String, dynamic> json) => BirthDateModel(
        hijriDate: json["HijriDate"],
      );
}

class RealEstateInfoModel extends RealEstateInfo {
  RealEstateInfoModel({
    super.deedSerialNumber,
    super.regionCode,
    super.realEstateSerialNumber,
    super.landNumber,
    super.planNumber,
    super.neighborhood,
    super.locationDescription,
    super.isHaveLimitAndBorder,
    super.cityCode,
    super.cityName,
  });

  factory RealEstateInfoModel.fromJson(Map<String, dynamic> json) =>
      RealEstateInfoModel(
        deedSerialNumber: json["DeedSerialNumber"],
        regionCode: json["RegionCode"],
        realEstateSerialNumber: json["RealEstateSerialNumber"],
        landNumber: json["LandNumber"],
        planNumber: json["PlanNumber"],
        neighborhood: json["Neighborhood"],
        locationDescription: json["LocationDescription"],
        isHaveLimitAndBorder: json["IsHaveLimitAndBorder"],
        cityCode: json["CityCode"],
        cityName: json["CityName"],
      );
}
