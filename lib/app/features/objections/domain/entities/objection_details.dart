import 'package:intl/intl.dart';

import '../../../../core/utils/constants/remote_config.dart';

class ObjectionDetails {

  final String? subMunicipalityId;
  final DateTime? lastUpdatedDate;
  final CommitteeDecision? committeeDecision;
  final String? serviceGroupName;
  final String? serviceGroupId;
  final String? municipalityName;
  final String? municipalityId;
  final String? requestStatusName;
  final String? serviceId;
  final String? objectionRequestNumber;
  final String? objectionTypeName;
  final String? serviceName;
  final String? subMunicipalityName;
  final DateTime? requestCreationDate;
  final DateTime? requestSubmitDate;
  final RequestSubmitterData? requestSubmitterData;
  final String? objectionTypeId;
  final List<ObjectionReason>? objectionReasonsList;
  final List<EnquiryItem>? enquiryList;
  final String? requestStatusId;
  final String? objectionServiceName;
  String? hashingRequestNumber;
  String? serviceTypeId;
  final String? sessionID; 

  ObjectionDetails(
      {this.subMunicipalityId,
      this.lastUpdatedDate,
      this.committeeDecision,
      this.serviceGroupName,
      this.serviceGroupId,
      this.municipalityName,
      this.municipalityId,
      this.requestStatusName,
      this.serviceId,
      this.objectionRequestNumber,
      this.objectionTypeName,
      this.serviceName,
      this.subMunicipalityName,
      this.requestCreationDate,
      this.requestSubmitDate,
      this.requestSubmitterData,
      this.objectionTypeId,
      this.objectionReasonsList,
      this.requestStatusId,
      this.objectionServiceName,
      this.hashingRequestNumber,
      this.serviceTypeId,
      this.enquiryList, this.sessionID});

  String get getLastUpdatedDate =>
      lastUpdatedDate != null ? DateFormat.yMd().format(lastUpdatedDate!) : "";

  String get getRequestSubmitDate => requestSubmitDate != null
      ? DateFormat.yMd().format(requestSubmitDate!)
      : "";
}

class CommitteeDecision {
  final DecisionPdf? decisionPdf;

  final String? decisionId;
  final String? decisionDate;
  final String? decision;

  CommitteeDecision({
    this.decisionId,
    this.decisionDate,
    this.decision,
    this.decisionPdf,
    
  });
}

class DecisionPdf {
  final String? contentLocation;
  final String? fileName;

  DecisionPdf({
    this.contentLocation,
    this.fileName,
  });

}

class RequestSubmitterData {
  final String? commercialRecord;
  final String? fullName;
  final String? objectedTransactionUrl;
  final String? id;
  final String? facilityUniqueId;
  final String? idType;
  final String? mobile;
  final String? objectedTransactionId;
  final String? submitterRole;
  final String? objectedTransactionDisplayNumber;

  RequestSubmitterData(
      {this.commercialRecord,
      this.fullName,
      this.objectedTransactionUrl,
      this.id,
      this.facilityUniqueId,
      this.idType,
      this.mobile,
      this.objectedTransactionId,
      this.submitterRole,
      this.objectedTransactionDisplayNumber});
}

class ObjectionReason {
  final List<ReasonAttachment>? reasonAttachment;
  final String? reasonCode;
  final String? reason;

  ObjectionReason({
    this.reasonAttachment,
    this.reasonCode,
    this.reason,
  });
}

class ReasonAttachment {
  final String? contentLocation;
  final String? fileName;

  ReasonAttachment({
    this.contentLocation,
    this.fileName,
  });
  String? getUrl() {
    return RemoteConfig.apigeeURL +
        "/v1/dms-mobile/files/${contentLocation?.split("/").last}";
  }

    String? getV2Url(String sessionId) {
    return RemoteConfig.apigeeURL +
        "/v2/dms-mobile/files/${contentLocation?.split("/").last}?sessionId=$sessionId";
  }
}

class EnquiryItem {
  final String? enquiryRequestedFromId;
  final String? enquiryStatusName;
  final String? enquiryStatusId;
  final String? enquiryRequestNumber;
  final DateTime? enquiryDate;
  final DateTime? enquiryDueDate;
  final String? hashingRequestNumber;
  final bool? isApplyEfadat;

  EnquiryItem({
    this.enquiryRequestedFromId,
    this.enquiryStatusName,
    this.enquiryStatusId,
    this.enquiryRequestNumber,
    this.enquiryDate,
    this.enquiryDueDate,
    this.hashingRequestNumber,
    this.isApplyEfadat,
  });
}
