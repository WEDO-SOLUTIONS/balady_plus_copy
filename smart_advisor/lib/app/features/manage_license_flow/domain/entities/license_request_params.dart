class LicenseRequestParams {
  String licenseType;
  String crNumber;
  String crType;
  String role;

  LicenseRequestParams(
      {required this.crNumber,
      required this.crType,
      required this.licenseType,
      required this.role});
}
