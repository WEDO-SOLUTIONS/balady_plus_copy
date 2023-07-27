import '../../objections_exports.dart';

class ObjectableTransactionsModel extends ObjectableTransactionsEntity {
  const ObjectableTransactionsModel(
      {super.transactionNumber,
      super.applicationId,
      super.applicationName,
      super.isAllowedForObjection,
      super.municipalityId,
      super.municipalityName,
      super.objectionLastApplyDate,
      super.ownerIdentityNo,
      super.ownerIdentityTypeId,
      super.ownerIdentityTypeName,
      super.serviceId,
      super.serviceName,
      super.subMunicipalityId,
      super.subMunicipalityName,
      super.violationIssueDate,
      super.objectionTypeId,
      super.objectionTypeName});

  factory ObjectableTransactionsModel.fromMap(Map<String, dynamic> json) {
    return ObjectableTransactionsModel(
        transactionNumber: json['transactionNumber'],
        applicationId: json['applicationId'],
        applicationName: json['applicationName'],
        isAllowedForObjection: json['isAllowedForObjection'],
        municipalityId: json['municipalityId'],
        municipalityName: json['municipalityName'],
        objectionLastApplyDate: json['objectionLastApplyDate'] != null
            ? DateTime.parse(json["objectionLastApplyDate"])
            : null,
        ownerIdentityNo: json['ownerIdentityNo'],
        ownerIdentityTypeId: json['ownerIdentityTypeId'],
        ownerIdentityTypeName: json['ownerIdentityTypeName'],
        serviceId: json['serviceId'],
        serviceName: json['serviceName'],
        subMunicipalityId: json['subMunicipalityId'],
        subMunicipalityName: json['subMunicipalityName'],
        violationIssueDate: json['violationIssueDate'] != null
            ? DateTime.parse(json["violationIssueDate"])
            : null,
        objectionTypeId: json["objectionTypeId"],
        objectionTypeName: json["objectionTypeName"]);
  }
}
