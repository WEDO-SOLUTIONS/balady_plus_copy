import '../../domain/entities/record_info_entity.dart';

class RecordInfoModel extends RecordInfo {
  RecordInfoModel({
    super.crNumber,
    super.crType,
    super.crInfo,
    super.crOwners,
  });

  factory RecordInfoModel.fromJson(Map<String, dynamic> json) =>
      RecordInfoModel(
        crNumber: json["crNumber"],
        crType: json["crType"],
        crInfo: json["crInfo"] == null
            ? null
            : CrInfoModel.fromJson(json["crInfo"]),
        crOwners: json["crOwners"] == null
            ? []
            : List<CrOwnerModel>.from(
                json["crOwners"]!.map((x) => CrOwnerModel.fromJson(x))),
      );
}

class CrInfoModel extends CrInfo {
  CrInfoModel({
    super.activities,
    super.address,
    super.capital,
    super.cityAr,
    super.cityEn,
    super.issueDateHijri,
    super.expiryDateHijri,
    super.faxNo,
    super.legalTypeAr,
    super.legalTypeEn,
    super.nameAr,
    super.phoneNo,
    super.status,
    super.type,
    super.mainCrNumber,
    super.nationalNumber,
    super.entityType,
  });

  factory CrInfoModel.fromJson(Map<String, dynamic> json) => CrInfoModel(
        activities: json["activities"] == null
            ? null
            : ActivitiesModel.fromJson(json["activities"]),
        address: json["address"],
        capital: json["capital"],
        cityAr: json["cityAR"],
        cityEn: json["cityEN"],
        issueDateHijri: json["issueDateHijri"],
        expiryDateHijri: json["expiryDateHijri"],
        faxNo: json["faxNo"],
        legalTypeAr: json["legalTypeAR"],
        legalTypeEn: json["legalTypeEN"],
        nameAr: json["nameAR"],
        phoneNo: json["phoneNo"],
        status: json["status"] == null
            ? null
            : StatusModel.fromJson(json["status"]),
        type: json["type"],
        mainCrNumber: json["mainCRNumber"],
        nationalNumber: json["nationalNumber"],
        entityType: json["entityType"],
      );
}

class ActivitiesModel extends Activities {
  ActivitiesModel({
    super.activities,
    super.isicActivities,
  });

  factory ActivitiesModel.fromJson(Map<String, dynamic> json) =>
      ActivitiesModel(
        activities: json["activities"],
        isicActivities: json["isicActivities"] == null
            ? []
            : List<IsicActivityModel>.from(json["isicActivities"]!
                .map((x) => IsicActivityModel.fromJson(x))),
      );
}

class IsicActivityModel extends IsicActivity {
  IsicActivityModel({
    super.isicCode,
    super.isicName,
    super.existInBalady,
    super.atmActivity,
    super.valid,
    super.craft,
  });

  factory IsicActivityModel.fromJson(Map<String, dynamic> json) =>
      IsicActivityModel(
        isicCode: json["isicCode"],
        isicName: json["isicName"],
        existInBalady: json["existInBalady"],
        atmActivity: json["atmActivity"],
        valid: json["valid"],
        craft: json["craft"],
      );
}

class StatusModel extends Status {
  StatusModel({
    super.status,
  });

  factory StatusModel.fromJson(Map<String, dynamic> json) => StatusModel(
        status: json["status"],
      );
}

class CrOwnerModel extends CrOwner {
  CrOwnerModel({
    super.ownerId,
    super.ownerName,
    super.ownerNationalityAr,
    super.ownerNationalityEn,
    super.relationType,
    super.ownerIdFlat,
    super.ownerIdType,
    super.relationTypeId,
  });

  factory CrOwnerModel.fromJson(Map<String, dynamic> json) => CrOwnerModel(
        ownerId: json["ownerID"] == null
            ? null
            : OwnerIdModel.fromJson(json["ownerID"]),
        ownerName: json["ownerName"],
        ownerNationalityAr: json["ownerNationalityAR"],
        ownerNationalityEn: json["ownerNationalityEN"],
        relationType: json["relationType"],
        ownerIdFlat: json["ownerIdFlat"],
        ownerIdType: json["ownerIdType"],
        relationTypeId: json["relationTypeID"],
      );
}

class OwnerIdModel extends OwnerId {
  OwnerIdModel({
    super.borderNumber,
    super.code700,
    super.crNumber,
    super.personIdentifier,
  });

  factory OwnerIdModel.fromJson(Map<String, dynamic> json) => OwnerIdModel(
        borderNumber: json["borderNumber"],
        code700: json["code700"],
        crNumber: json["crnumber"],
        personIdentifier: json["personIdentifier"] == null
            ? null
            : PersonIdentifierModel.fromJson(json["personIdentifier"]),
      );
}

class PersonIdentifierModel extends PersonIdentifier {
  PersonIdentifierModel({
    super.iqamaNumber,
    super.nationalId,
  });

  factory PersonIdentifierModel.fromJson(Map<String, dynamic> json) =>
      PersonIdentifierModel(
        iqamaNumber: json["iqamaNumber"],
        nationalId: json["nationalID"],
      );
}
