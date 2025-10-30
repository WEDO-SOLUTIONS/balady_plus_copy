class SubmitTobaccoRequest {
  int? hotelLicenseNumber;
  int licenseNumber;
  bool insideHotel;
  int? requestId;
  SubmitTobaccoRequest(
      {this.hotelLicenseNumber,
      required this.insideHotel,
      required this.licenseNumber,
      this.requestId});
}
