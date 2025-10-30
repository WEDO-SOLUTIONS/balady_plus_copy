import 'package:equatable/equatable.dart';

class ComplianceDeedInfo extends Equatable {
  final int? deedSerialNumber;
  final int? deedNumber;
  final int? dateIssuanceDeed;
  final int? issuerCourtCode;
  final String? issuerCourtName;
  final int? cityCode;
  final String? cityName;
  final String? deedStatus;
  final int? deedArea;
  final int? transactionTypeCode;
  final String? transactionTypeName;
  final String? isConstrained;
  final String? isHalt;
  final String? isPawned;
  final String? isTestament;
  final RealEstateInfo? realEstateInfoModel;
  final DistanceAndBorderDeed? distanceAndBorderDeedModel;
  final OwnersInfoList? ownersInfoList;
  final int? deedStatusCode;

  ComplianceDeedInfo({
    this.deedSerialNumber,
    this.deedNumber,
    this.dateIssuanceDeed,
    this.issuerCourtCode,
    this.issuerCourtName,
    this.cityCode,
    this.cityName,
    this.deedStatus,
    this.deedArea,
    this.transactionTypeCode,
    this.transactionTypeName,
    this.isConstrained,
    this.isHalt,
    this.isPawned,
    this.isTestament,
    this.realEstateInfoModel,
    this.distanceAndBorderDeedModel,
    this.ownersInfoList,
    this.deedStatusCode,
  });

  String? getDeedDate() {
    return "${dateIssuanceDeed.toString().substring(0, 4)}/${dateIssuanceDeed.toString().substring(4, 6)}/${dateIssuanceDeed.toString().substring(6, 8)}";
  }

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class DistanceAndBorderDeed {
  final ErnBorder? northernBorder;
  final ErnBorder? southernBorder;
  final ErnBorder? easternBorder;
  final ErnBorder? westernBorder;

  DistanceAndBorderDeed({
    this.northernBorder,
    this.southernBorder,
    this.easternBorder,
    this.westernBorder,
  });
}

class ErnBorder {
  final int? borderTypeCode;
  final String? borderTypeString;
  final String? borderDescription;
  final int? borderDistance;
  final String? borderDistanceString;

  ErnBorder({
    this.borderTypeCode,
    this.borderTypeString,
    this.borderDescription,
    this.borderDistance,
    this.borderDistanceString,
  });
}

class OwnersInfoList {
  final List<OwnerInfo>? ownerInfo;

  OwnersInfoList({
    this.ownerInfo,
  });
}

class OwnerInfo {
  final int? deedSerialNumber;
  final int? ownerSocialId;
  final String? ownerSocialIdType;
  final BirthDate? birthDate;
  final String? ownerName;
  final int? owningPercentage;
  final double? owningArea;
  final String? isDead;

  OwnerInfo({
    this.deedSerialNumber,
    this.ownerSocialId,
    this.ownerSocialIdType,
    this.birthDate,
    this.ownerName,
    this.owningPercentage,
    this.owningArea,
    this.isDead,
  });
}

class BirthDate {
  final String? hijriDate;

  BirthDate({
    this.hijriDate,
  });
}

class RealEstateInfo {
  final int? deedSerialNumber;
  final int? regionCode;
  final int? realEstateSerialNumber;
  final int? landNumber;
  final String? planNumber;
  final String? neighborhood;
  final String? locationDescription;
  final String? isHaveLimitAndBorder;
  final int? cityCode;
  final String? cityName;

  RealEstateInfo({
    this.deedSerialNumber,
    this.regionCode,
    this.realEstateSerialNumber,
    this.landNumber,
    this.planNumber,
    this.neighborhood,
    this.locationDescription,
    this.isHaveLimitAndBorder,
    this.cityCode,
    this.cityName,
  });
}
