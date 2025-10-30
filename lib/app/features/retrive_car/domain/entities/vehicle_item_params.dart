class VehicleItemParams {
  String action;
  String vehicleInquiryOptions;
  int? pageNumber;
  int? pageSize;
  String type;
  String? commercialRegistrationNumber;
  String? agencyNumber;
  String? carOwnerId;
  String? beneficiaryID;
  VehicleItemParams(
      {required this.action,
      this.pageNumber,
      this.pageSize,
      required this.vehicleInquiryOptions,
      this.agencyNumber,
      this.carOwnerId,
      this.commercialRegistrationNumber,
      required this.type,
      this.beneficiaryID});

  Map<String, dynamic> toMap() => {
        "Action": action,
        if (pageNumber != null) "PageNumber": pageNumber,
        if (pageSize != null) "PageSize": pageSize,
        "VehicleInquiryOptions": vehicleInquiryOptions,
        if (commercialRegistrationNumber != null)
          "CommercialRegistrationNumber": commercialRegistrationNumber,
        if (agencyNumber != null) "AgencyNumber": agencyNumber,
        if (carOwnerId != null) "CarOwnerId": carOwnerId,
        if (beneficiaryID != null) "BeneficiaryID": beneficiaryID
      };
}
