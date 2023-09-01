// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class ApplyCreateComplianceRequest extends Equatable {
  String? certificateType;
  String? contactMobile;
  int? licenseNumber;
  String? submitterThrough;
  String? ownershipDocumentDate;
  String? ownershipDocumentNo;
  int? ownershipDocumentType;
  ApplyCreateComplianceRequest({
    this.certificateType,
    this.contactMobile,
    this.licenseNumber,
    this.submitterThrough,
    this.ownershipDocumentDate,
    this.ownershipDocumentNo,
    this.ownershipDocumentType,
  });

  Map<String, dynamic> toMap() {
    return {
      "certificateType": certificateType,
      "contactMobile": contactMobile,
      if (licenseNumber != null) "licenseNumber": licenseNumber,
      "submitterThrough": submitterThrough,
      if (ownershipDocumentType != null)
        "ownershipDocInfoDto": {
          "ownershipDocumentDate": ownershipDocumentDate,
          "ownershipDocumentNo": ownershipDocumentNo,
          "ownershipDocumentType": ownershipDocumentType
        }
    };
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        certificateType,
        contactMobile,
        licenseNumber,
        submitterThrough,
        ownershipDocumentType,
        ownershipDocumentNo,
        ownershipDocumentType
      ];
}
