import '../../domain/entities/invoice_details_entity.dart';

class InvoiceDetailsModel extends InvoiceDetailsEntity {
  InvoiceDetailsModel({
    super.accountNumber,
    super.updateTime,
    super.id,
    super.amount,
    super.creationDate,
    super.invoiceStatusId,
    super.invoiceStatusName,
    super.invoiceTypeId,
    super.invoiceTypeName,
    super.loginIdentityId,
    super.loginIdentityType,
    super.tag,
    super.dueDate,
    super.sadadDate,
    super.updatedDate,
    super.details,
    super.applicationId,
    super.applicationName,
    super.ownerIdentityNumber,
    super.requestNumber,
    super.requestId,
    super.ownerIdentityTypeId,
    super.ownerIdentityTypeName,
    super.mainRequestTypeId,
    super.mainRequestTypeName,
    super.requestTypeId,
    super.requestTypeName,
    super.hashingInvoiceNumber,
    super.ownerName,
    super.violations,
    super.objections,
  });

  factory InvoiceDetailsModel.fromJson(Map<String, dynamic> json) =>
      InvoiceDetailsModel(
        accountNumber: json["accountNumber"],
        updateTime: json["updateTime"] == null
            ? null
            : DateTime.parse(json["updateTime"]),
        id: json["id"],
        amount: json["amount"]?.toDouble(),
        creationDate: json["creationDate"] == null
            ? null
            : DateTime.parse(json["creationDate"]),
        invoiceStatusId: json["invoiceStatusId"],
        invoiceStatusName: json["invoiceStatusName"],
        invoiceTypeId: json["invoiceTypeId"],
        invoiceTypeName: json["invoiceTypeName"],
        loginIdentityId: json["loginIdentityId"],
        loginIdentityType: json["loginIdentityType"],
        tag: json["tag"],
        dueDate:
            json["dueDate"] == null ? null : DateTime.parse(json["dueDate"]),
        sadadDate: json["sadadDate"] == null
            ? null
            : DateTime.parse(json["sadadDate"]),
        updatedDate: json["updatedDate"] == null
            ? null
            : DateTime.parse(json["updatedDate"]),
        details: json["details"] == null
            ? []
            : List<DetailModel>.from(
                json["details"]!.map((x) => DetailModel.fromJson(x))),
        applicationId: json["applicationId"],
        applicationName: json["applicationName"],
        ownerIdentityNumber: json["ownerIdentityNumber"],
        requestNumber: json["requestNumber"],
        requestId: json["requestId"],
        ownerIdentityTypeId: json["ownerIdentityTypeId"],
        ownerIdentityTypeName: json["ownerIdentityTypeName"],
        mainRequestTypeId: json["mainRequestTypeId"],
        mainRequestTypeName: json["mainRequestTypeName"],
        requestTypeId: json["requestTypeId"],
        requestTypeName: json["requestTypeName"],
        hashingInvoiceNumber: json["hashingInvoiceNumber"],
        ownerName: json["ownerName"],
        violations: json["violations"] == null
            ? []
            : List<ViolationModel>.from(
                json["violations"]!.map((x) => ViolationModel.fromJson(x))),
        objections: json["objections"] == null
            ? []
            : List<Objection>.from(
                json["objections"]!.map((x) => ObjectionModel.fromJson(x))),
      );
}

class DetailModel extends Detail {
  DetailModel({
    super.feeId,
    super.feeName,
    super.amount,
    // super.municipalityId,
    // super.municipalityName,
    // super.subMunicipalityId,
    // super.subMunicipalityName,
  });

  factory DetailModel.fromJson(Map<String, dynamic> json) => DetailModel(
        feeId: json["feeId"],
        feeName: json["feeName"],
        amount: json["amount"]?.toDouble(),
        // municipalityId: json["municipalityId"],
        // municipalityName: json["municipalityName"],
        // subMunicipalityId: json["subMunicipalityId"],
        // subMunicipalityName: json["subMunicipalityName"],
      );
}

class ObjectionModel extends Objection {
  ObjectionModel({
    super.objectedTransactionNumber,
    super.hashingObjectedId,
    super.objectedServiceName,
    super.requestNumberAsText,
    super.requestStatusName,
    super.creationDate,
  });

  factory ObjectionModel.fromJson(Map<String, dynamic> json) => ObjectionModel(
        objectedTransactionNumber: json["objectedTransactionNumber"],
        hashingObjectedId: json["hashingObjectedID"],
        objectedServiceName: json["objectedServiceName"],
        requestNumberAsText: json["requestNumberAsText"],
        requestStatusName: json["requestStatusName"],
        creationDate: json["creationDate"] == null
            ? null
            : DateTime.parse(json["creationDate"]),
      );
}

class ViolationModel extends Violation {
  ViolationModel({
    super.billNumber,
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
  });

  factory ViolationModel.fromJson(Map<String, dynamic> json) => ViolationModel(
        billNumber: json["billNumber"],
        violationNumber: json["violationNumber"],
        violationAmount: json["violationAmount"]?.toDouble(),
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
      );
}
