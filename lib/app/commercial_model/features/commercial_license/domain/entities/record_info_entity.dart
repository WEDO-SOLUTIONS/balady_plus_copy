import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/app_config.dart';

import '../../../../../features/_shared_feature_/shared_feature_exports.dart';

class RecordInfo {
  String? crNumber;
  int? crType;
  CrInfo? crInfo;
  List<CrOwner>? crOwners;

  RecordInfo({
    this.crNumber,
    this.crType,
    this.crInfo,
    this.crOwners,
  });
}

class CrInfo {
  Activities? activities;
  String? address;
  int? capital;
  String? cityAr;
  String? cityEn;
  String? issueDateHijri;
  String? expiryDateHijri;
  String? faxNo;
  String? legalTypeAr;
  String? legalTypeEn;
  String? nameAr;
  String? phoneNo;
  Status? status;
  String? type;
  String? mainCrNumber;
  String? nationalNumber;
  int? entityType;

  CrInfo({
    this.activities,
    this.address,
    this.capital,
    this.cityAr,
    this.cityEn,
    this.issueDateHijri,
    this.expiryDateHijri,
    this.faxNo,
    this.legalTypeAr,
    this.legalTypeEn,
    this.nameAr,
    this.phoneNo,
    this.status,
    this.type,
    this.mainCrNumber,
    this.nationalNumber,
    this.entityType,
  });

  String? get getLegalType =>
      CommonFunctions.isAppAR ? legalTypeAr : legalTypeEn;
  String? get getCity => CommonFunctions.isAppAR ? cityAr : cityEn;
}

class Activities {
  String? activities;
  List<IsicActivity>? isicActivities;

  Activities({
    this.activities,
    this.isicActivities,
  });
}

class IsicActivity extends DropDownItem {
  String? isicCode;
  String? isicName;
  bool? existInBalady;
  bool? atmActivity;
  bool? valid;
  bool? craft;

  IsicActivity({
    this.isicCode,
    this.isicName,
    this.existInBalady,
    this.atmActivity,
    this.valid,
    this.craft,
  }) : super(
          id: isicCode ?? '',
          name: isicName ?? '',
        );

  Map<String, dynamic> toJson() => {
        "atmActivity": atmActivity,
        "existInBalady": existInBalady,
        "isicCode": isicCode,
        "isicName": isicName,
        "valid": valid,
      };
}

class Status {
  String? status;

  Status({
    this.status,
  });
}

class CrOwner {
  OwnerId? ownerId;
  String? ownerName;
  String? ownerNationalityAr;
  String? ownerNationalityEn;
  String? relationType;
  String? ownerIdFlat;
  int? ownerIdType;
  String? relationTypeId;

  CrOwner({
    this.ownerId,
    this.ownerName,
    this.ownerNationalityAr,
    this.ownerNationalityEn,
    this.relationType,
    this.ownerIdFlat,
    this.ownerIdType,
    this.relationTypeId,
  });
}

class OwnerId {
  String? borderNumber;
  String? code700;
  String? crNumber;
  PersonIdentifier? personIdentifier;

  OwnerId({
    this.borderNumber,
    this.code700,
    this.personIdentifier,
    this.crNumber,
  });
}

class PersonIdentifier {
  String? iqamaNumber;
  String? nationalId;

  PersonIdentifier({
    this.iqamaNumber,
    this.nationalId,
  });
}
