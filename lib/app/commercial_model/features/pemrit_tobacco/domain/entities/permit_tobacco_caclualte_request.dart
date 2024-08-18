// ignore_for_file: public_member_api_docs, sort_constructors_first
class PermitTobaccoCalculateRequest {
  bool insideHotel;
  int licenseNumber;

  int? hotelLicenseNumber;
  PermitTobaccoCalculateRequest(
      {required this.insideHotel,
      this.hotelLicenseNumber,
      required this.licenseNumber});
}
