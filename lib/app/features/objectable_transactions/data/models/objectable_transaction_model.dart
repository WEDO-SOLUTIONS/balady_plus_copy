import '../../objections_exports.dart';

class ObjectableTransactionsModel extends ObjectableTransactionsEntity {
  const ObjectableTransactionsModel(
      {super.transactionNumber,
      super.objectionLastApplyDate,
      super.violationIssueDate,
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
      super.applicationId,
      super.applicationName,
      super.serviceId,
      super.serviceName,
      super.redirectUrl,
      super.actions,
      super.hashingTransactionNumber,
      super.originalOwnerIdentityTypeId,
      super.originalMunicipalityId,
      super.originalSubMunicipalityId,
      super.serviceTypeId,
      super.transactionId,
      super.contentTypeId,
      super.contentTypeName,
      super.originalServiceId,
      super.hashingOriginalServiceId,
      super.licenseNumber,
      super.licenseTypeID});

  factory ObjectableTransactionsModel.fromMap(Map<String, dynamic> json) {
    return ObjectableTransactionsModel(
        transactionNumber: json["transactionNumber"],
        objectionLastApplyDate: json["objectionLastApplyDate"] == null
            ? null
            : DateTime.parse(json["objectionLastApplyDate"]),
        violationIssueDate: json["violationIssueDate"] == null
            ? null
            : DateTime.parse(json["violationIssueDate"]),
        violationStatusName: json["violationStatusName"],
        violationStatusId: json["violationStatusId"],
        isAllowedForObjection: json["isAllowedForObjection"],
        isAllowedObjection: json["isAllowedObjection"],
        createdDate: json["createdDate"],
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
        applicationId: json["applicationId"],
        applicationName: json["applicationName"],
        serviceId: json["serviceId"],
        serviceName: json["serviceName"],
        redirectUrl: json["redirectUrl"],
        actions: json["actions"],
        hashingTransactionNumber: json["hashingTransactionNumber"],
        originalOwnerIdentityTypeId: json["originalOwnerIdentityTypeId"],
        originalMunicipalityId: json["originalMunicipalityId"],
        originalSubMunicipalityId: json["originalSubMunicipalityId"],
        serviceTypeId: json["serviceTypeId"],
        transactionId: json["transactionId"],
        contentTypeId: json["contentTypeId"],
        contentTypeName: json["contentTypeName"],
        originalServiceId: json["originalServiceId"],
        hashingOriginalServiceId: json["hashingOriginalServiceId"],
        licenseNumber: json["licenseNumber"],
        licenseTypeID: json["licenseTypeID"]);
  }
}
