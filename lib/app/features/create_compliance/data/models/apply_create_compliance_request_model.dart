// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:equatable/equatable.dart';

class ApplyCreateComplianceRequest extends Equatable {
  int? requestId;
  String? certificateType;
  String? contactMobile;
  int? licenseNumber;
  String? submitterThrough;
  String? ownershipDocumentDate;
  String? ownershipDocumentNo;
  int? ownershipDocumentType;

  String? ownerIdentity;
  String? ownerIdentityType;
  String? submitterType;

  int? receiptTypeId;
  bool? paper;
  String? agencyRequestKey;

  ApplyCreateComplianceRequest(
      {this.certificateType,
      this.contactMobile,
      this.requestId,
      this.licenseNumber,
      this.submitterThrough,
      this.ownershipDocumentDate,
      this.ownershipDocumentNo,
      this.ownershipDocumentType,
      this.submitterType,
      this.ownerIdentityType,
      this.ownerIdentity,
      this.receiptTypeId,
      this.paper,
      this.agencyRequestKey});

  Map<String, dynamic> toMap() {
    return {
      if (agencyRequestKey != null) "agencyRequestId": agencyRequestKey, //GUID
      "certificateType": certificateType,
      "contactMobile": contactMobile,
      if (licenseNumber != null) "licenseNumber": licenseNumber,
      "submitterThrough": submitterThrough,

      "submitterType":
          CommonProperties.getCurrentUserProfile()?.getRole() != null
              ? CommonProperties.getCurrentUserProfile()?.getRole()
              : "HIMSELF",
      //"ownerIdentityType":
      //    CommonProperties.selectedDelegator != null ? "CR" : null,
      //  "ownerIdentity": CommonProperties.selectedDelegator?.crNumber,

      if (CommonProperties.selectedDelegator != null)
        "ownerIdentityType": CommonProperties.getCurrentUserProfile() != null
            ? CommonProperties.getCurrentUserProfile()!.type
            : null,
      if (CommonProperties.selectedDelegator != null)
        "ownerIdentity": CommonProperties.getCurrentUserProfile()?.id,
      if (ownershipDocumentType != null)
        "ownershipDocInfoDto": {
          "ownershipDocumentDate": ownershipDocumentDate,
          "ownershipDocumentNo": ownershipDocumentNo,
          "ownershipDocumentType": ownershipDocumentType,
          if (receiptTypeId != null) "receiptTypeId": receiptTypeId,
          if (paper != null) "paper": paper
        },
    };
  }

  @override
  List<Object?> get props => [
        certificateType,
        contactMobile,
        licenseNumber,
        submitterThrough,
        ownershipDocumentType,
        ownershipDocumentNo,
        ownershipDocumentType,
        submitterType,
        ownerIdentityType,
        ownerIdentity,
        paper,
        receiptTypeId
      ];
}
