class DetailsRequestModel {
  final String certificateExpirationDate;
  final String classificationGrade;
  final String serialNumber;

  DetailsRequestModel({
    required this.certificateExpirationDate,
    required this.classificationGrade,
    required this.serialNumber,
  });

  factory DetailsRequestModel.fromJson(Map<String, dynamic> json) => DetailsRequestModel(
    classificationGrade: json["ClassificationGrade"],
    certificateExpirationDate: json["CertificateExpirationDate"],
    serialNumber: json["SerialNumber"],
  );


  Map<String, dynamic> toJson() {
    return {
      "cert-expiry-date": certificateExpirationDate,
      "classification-grade": classificationGrade,
    };
  }
}
