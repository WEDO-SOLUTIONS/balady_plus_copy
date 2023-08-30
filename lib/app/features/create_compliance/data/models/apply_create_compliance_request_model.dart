class ApplyCreateComplianceRequest {
  String? certificateType;
  String? contactMobile;
  int? licenseNumber;
  String? submitterThrough;
  String? ownershipDocumentDate;
  String? ownershipDocumentNo;
  int? ownershipDocumentType;

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
}
