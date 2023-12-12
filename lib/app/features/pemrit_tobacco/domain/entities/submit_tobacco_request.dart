class SubmitTobaccoRequest {
  int? hotelLicenseNumber;
  int licenseNumber;
  bool insideHotel;
  SubmitTobaccoRequest(
      {this.hotelLicenseNumber,
      required this.insideHotel,
      required this.licenseNumber});
}
