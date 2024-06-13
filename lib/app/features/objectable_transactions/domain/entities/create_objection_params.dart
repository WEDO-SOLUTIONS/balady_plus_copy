import 'dart:convert';
import 'package:collection/collection.dart';

class CreateObjectionParams {
  String? objectionTypeId;
  String? serviceGroupId;
  String? serviceId;
  String? municipalityID;
  String? subMunicipalityID;
  String? serviceTypeId;

  String? submitterRole;
  String? commercialRecord;
  String? facilityUniqueID;
  String? objectedTransactionId;
  String? objectedTransactionDisplayNumber;

  List<CreateObjectionReasonsParams>? reasons;
  final dynamic licenseNumber;
  final dynamic licenseTypeID;

  CreateObjectionParams(
      {this.municipalityID,
      this.objectionTypeId,
      this.serviceGroupId,
      this.serviceId,
      this.subMunicipalityID,
      this.objectedTransactionId,
      this.reasons,
      this.submitterRole,
      this.commercialRecord,
      this.facilityUniqueID,
      this.objectedTransactionDisplayNumber,
      this.serviceTypeId,
      this.licenseNumber,
      this.licenseTypeID});
  Map<String, dynamic> toMap() {
    return {
      "MainRequestData": {
        "ObjectionTypeId": objectionTypeId,
        "ServiceGroupId": serviceGroupId,
        "ServiceId": serviceId,
        "MunicipalityID": municipalityID,
        "SubMunicipalityID": subMunicipalityID,
        "ServiceTypeId": serviceTypeId
      },
      "RequestSubmitterData": {
        "SubmitterRole": submitterRole,
        if (submitterRole != "001") "CommercialRecord": commercialRecord,
        "FacilityUniqueID": facilityUniqueID,
        "ObjectedTransactionId": objectedTransactionId,
        "ObjectedTransactionDisplayNumber": objectedTransactionDisplayNumber,
        "LicenseNumber": licenseNumber,
        "LicenseTypeID": licenseTypeID
      },
      if (reasons != null)
        "ObjectionReasonList": reasons!
            .map((e) => e.reason?.isNotEmpty ?? false ? e.toMap() : null)
            .whereNotNull()
            .toList()
    };
  }
}

class CreateObjectionReasonsParams {
  String? reasonCode;
  String? reason;
  String? fileId;
  String? fileName;
  String? fileType;
  CreateObjectionReasonsParams(
      {this.reasonCode,
      this.reason,
      this.fileId,
      this.fileName,
      this.fileType});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Reason': reason,
      if (fileId == null) "ReasonAttachment": [],
      if (fileId != null)
        "ReasonAttachment": [
          {
            "ContentLocation": fileId,
            "FileName": fileName,
            "FileType": fileType
          }
        ]
    };
  }
}
