import '../../domain/entities/objection_details.dart';

class ObjectionDetailsModel extends ObjectionDetails {
  ObjectionDetailsModel(
      {super.subMunicipalityId,
      super.lastUpdatedDate,
      super.committeeDecision,
      super.serviceGroupName,
      super.serviceGroupId,
      super.municipalityName,
      super.municipalityId,
      super.requestStatusName,
      super.serviceId,
      super.objectionRequestNumber,
      super.objectionTypeName,
      super.serviceName,
      super.subMunicipalityName,
      super.requestCreationDate,
      super.requestSubmitDate,
      super.requestSubmitterData,
      super.objectionTypeId,
      super.objectionReasonsList,
      super.enquiryList,
      super.requestStatusId,
      super.serviceTypeId,
      super.objectionServiceName, super.sessionID});

  factory ObjectionDetailsModel.fromJson(Map<String, dynamic> json) =>
      ObjectionDetailsModel(
          subMunicipalityId: json["SubMunicipalityID"],
          lastUpdatedDate: json["LastUpdatedDate"] == null
              ? null
              : DateTime.parse(json["LastUpdatedDate"]),
          committeeDecision: json["CommitteeDecision"] == null
              ? null
              : CommitteeDecisionModel.fromJson(json["CommitteeDecision"]),
          serviceGroupName: json["ServiceGroupName"],
          serviceGroupId: json["ServiceGroupId"],
          municipalityName: json["MunicipalityName"],
          municipalityId: json["MunicipalityID"],
          requestStatusName: json["RequestStatusName"],
          serviceId: json["ServiceId"],
          objectionRequestNumber: json["ObjectionRequestNumber"],
          objectionTypeName: json["ObjectionTypeName"],
          serviceName: json["ServiceName"],
          subMunicipalityName: json["SubMunicipalityName"],
          requestCreationDate: json["RequestCreationDate"] == null
              ? null
              : DateTime.parse(json["RequestCreationDate"]),
          requestSubmitDate: json["RequestSubmitDate"] == null
              ? null
              : DateTime.parse(json["RequestSubmitDate"]),
          requestSubmitterData: json["RequestSubmitterData"] == null
              ? null
              : RequestSubmitterDataModel.fromJson(
                  json["RequestSubmitterData"]),
          objectionTypeId: json["ObjectionTypeId"],
          objectionReasonsList: json["ObjectionReasonsList"] == null
              ? []
              : List<ObjectionReasonModel>.from(json["ObjectionReasonsList"]!
                  .map((x) => ObjectionReasonModel.fromJson(x))),
          enquiryList: json["EnquiryList"] == null
              ? []
              : List<EnquiryItemModel>.from(json["EnquiryList"]!
                  .map((x) => EnquiryItemModel.fromJson(x))),
          requestStatusId: json["RequestStatusId"],
          serviceTypeId: json["ServiceTypeId"],
          objectionServiceName: json["ObjectionServiceName"], 
         sessionID :json["SessionID"]
          
          
          );

  @override
  List<Object?> get props => [
        subMunicipalityId,
        lastUpdatedDate,
        committeeDecision,
        serviceGroupName,
        serviceGroupId,
        municipalityName,
        municipalityId,
        requestStatusName,
        serviceId,
        objectionRequestNumber,
        objectionTypeName,
        serviceName,
        subMunicipalityName,
        requestCreationDate,
        requestSubmitDate,
        requestSubmitterData,
        objectionTypeId,
        objectionReasonsList,
        requestStatusId,
        objectionServiceName
      ];
}

class CommitteeDecisionModel extends CommitteeDecision {
  CommitteeDecisionModel(
      {super.decisionId,
      super.decisionDate,
      super.decision,
      super.decisionPdf});

  factory CommitteeDecisionModel.fromJson(Map<String, dynamic> json) =>
      CommitteeDecisionModel(
        decisionId: json["DecisionID"],
        decisionDate: json["DecisionDate"],
        decision: json["Decision"],
        decisionPdf: json["DecisionPDF"] == null
            ? null
            : DecisionPdfModel.fromJson(json["DecisionPDF"]),
      );
}

class DecisionPdfModel extends DecisionPdf {
  DecisionPdfModel({
    super.contentLocation,
    super.fileName,
  });

  factory DecisionPdfModel.fromJson(Map<String, dynamic> json) =>

      DecisionPdfModel(
        contentLocation: json["ContentLocation"] != null && json["ContentLocation"] != "null"? json["ContentLocation"]:null,
        fileName: json["FileName"],
      );

  Map<String, dynamic> toJson() => {
        "ContentLocation": contentLocation,
        "FileName": fileName,
      };
}

class RequestSubmitterDataModel extends RequestSubmitterData {
  RequestSubmitterDataModel(
      {super.commercialRecord,
      super.fullName,
      super.objectedTransactionUrl,
      super.id,
      super.facilityUniqueId,
      super.idType,
      super.mobile,
      super.objectedTransactionId,
      super.submitterRole,
      super.objectedTransactionDisplayNumber});

  factory RequestSubmitterDataModel.fromJson(Map<String, dynamic> json) =>
      RequestSubmitterDataModel(
        commercialRecord: json["CommercialRecord"],
        fullName: json["FullName"],
        objectedTransactionUrl: json["ObjectedTransactionURL"],
        id: json["id"],
        facilityUniqueId: json["FacilityUniqueID"],
        idType: json["IDType"],
        mobile: json["Mobile"],
        objectedTransactionId: json["ObjectedTransactionID"],
        objectedTransactionDisplayNumber:
            json["ObjectedTransactionDisplayNumber"],
        submitterRole: json["SubmitterRole"],
      );
}

class ObjectionReasonModel extends ObjectionReason {
  ObjectionReasonModel({
    super.reasonAttachment,
    super.reasonCode,
    super.reason,
  });

  factory ObjectionReasonModel.fromJson(Map<String, dynamic> json) =>
      ObjectionReasonModel(
        reasonAttachment: json["ReasonAttachmentList"] == null
            ? null
            : List<ReasonAttachmentModel>.from(json["ReasonAttachmentList"]!
                .map((x) => ReasonAttachmentModel.fromJson(x))),
        reasonCode: json["ReasonCode"],
        reason: json["Reason"],
      );
}

class ReasonAttachmentModel extends ReasonAttachment {
  ReasonAttachmentModel({
    super.contentLocation,
    super.fileName,
  });

  factory ReasonAttachmentModel.fromJson(Map<String, dynamic> json) =>
      ReasonAttachmentModel(
        contentLocation: json["ContentLocation"] != null && json["ContentLocation"] != "null"? json["ContentLocation"]:null,
        fileName: json["FileName"],
      );
}

class EnquiryItemModel extends EnquiryItem {
  EnquiryItemModel({
    super.enquiryRequestedFromId,
    super.enquiryStatusName,
    super.enquiryStatusId,
    super.enquiryRequestNumber,
    super.enquiryDate,
    super.enquiryDueDate,
    super.hashingRequestNumber,
    super.isApplyEfadat,
  });

  factory EnquiryItemModel.fromJson(Map<String, dynamic> json) =>
      EnquiryItemModel(
        enquiryRequestedFromId: json["EnquiryRequestedFromId"],
        enquiryStatusName: json["EnquiryStatusName"],
        enquiryStatusId: json["EnquiryStatusId"],
        enquiryRequestNumber: json["EnquiryRequestNumber"],
        enquiryDate: json["EnquiryDate"] == null
            ? null
            : DateTime.parse(json["EnquiryDate"]),
        enquiryDueDate: json["EnquiryDueDate"] == null
            ? null
            : DateTime.parse(json["EnquiryDueDate"]),
        hashingRequestNumber: json["hashingRequestNumber"],
        isApplyEfadat: json["isApplyEfadat"],
      );
}
