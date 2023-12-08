import '../../violations_exports.dart';

class ViolationsModel extends ViolationsEntity {
  ViolationsModel(
      {super.billNumber,
      super.violationNumber,
      super.violationAmount,
      super.objectionLastApplyDate,
      super.violationIssueDate,
      super.violationDescription,
      super.regulationClause,
      super.licenseNumber,
      super.licenseNumberOrOwnerIdentityNumber,
      super.licenseNumberBalady,
      super.licenseTypeId,
      super.licenseTypeName,
      super.facilityName,
      super.billStatusName,
      super.billStatusId,
      super.violationStatusName,
      super.violationStatusId,
      super.isAllowedForObjection,
      super.isAllowedObjection,
      super.createdDate,
      super.updatedDate,
      super.municipalityId,
      super.municipalityName,
      super.subMunicipalityId,
      super.subMunicipalityName,
      super.ownerIdentityNo,
      super.ownerName,
      super.ownerIdentityTypeId,
      super.ownerIdentityTypeName,
      super.objectionTypeId,
      super.objectionTypeName,
      super.violationTypeId,
      super.violationTypeName,
      super.applicationId,
      super.applicationName,
      super.serviceId,
      super.serviceName,
      super.actions,
      super.hashingViolationNumber,
      super.originalOwnerIdentityTypeId,
      super.originalMunicipalityId,
      super.originalSubMunicipalityId,
      super.serviceTypeId});

  factory ViolationsModel.fromJson(Map<String, dynamic> json) =>
      ViolationsModel(
          billNumber: json["billNumber"],
          violationNumber: json["violationNumber"],
          violationAmount: json["violationAmount"],
          objectionLastApplyDate: json["objectionLastApplyDate"] == null
              ? null
              : DateTime.parse(json["objectionLastApplyDate"]),
          violationIssueDate: json["violationIssueDate"] == null
              ? null
              : DateTime.parse(json["violationIssueDate"]),
          violationDescription: json["violationDescription"],
          regulationClause: json["regulationClause"],
          licenseNumber: json["licenseNumber"],
          licenseNumberOrOwnerIdentityNumber:
              json["licenseNumberOrOwnerIdentityNumber"],
          licenseNumberBalady: json["licenseNumberBalady"],
          licenseTypeId: json["licenseTypeId"],
          licenseTypeName: json["licenseTypeName"],
          facilityName: json["facilityName"],
          billStatusName: json["billStatusName"],
          billStatusId: json["billStatusId"],
          violationStatusName: json["violationStatusName"],
          violationStatusId: json["violationStatusId"],
          isAllowedForObjection: json["isAllowedForObjection"],
          isAllowedObjection: json["isAllowedObjection"],
          createdDate: json["createdDate"] == null
              ? null
              : DateTime.parse(json["createdDate"]),
          updatedDate: json["updatedDate"] == null
              ? null
              : DateTime.parse(json["updatedDate"]),
          municipalityId: json["municipalityId"],
          municipalityName: json["municipalityName"],
          subMunicipalityId: json["subMunicipalityId"],
          subMunicipalityName: json["subMunicipalityName"],
          ownerIdentityNo: json["ownerIdentityNo"],
          ownerName: json["ownerName"],
          ownerIdentityTypeId: json["ownerIdentityTypeId"],
          ownerIdentityTypeName: json["ownerIdentityTypeName"],
          objectionTypeId: json["objectionTypeId"],
          objectionTypeName: json["objectionTypeName"],
          violationTypeId: json["violationTypeId"],
          violationTypeName: json["violationTypeName"],
          applicationId: json["applicationId"],
          applicationName: json["applicationName"],
          serviceId: json["serviceId"],
          serviceName: json["serviceName"],
          actions: json["actions"] == null
              ? []
              : List<String>.from(json["actions"]!.map((x) => x)),
          hashingViolationNumber: json["hashingViolationNumber"],
          originalOwnerIdentityTypeId: json["originalOwnerIdentityTypeId"],
          originalMunicipalityId: json["originalMunicipalityId"],
          originalSubMunicipalityId: json["originalSubMunicipalityId"],
          serviceTypeId: json["serviceTypeId"]);
}
