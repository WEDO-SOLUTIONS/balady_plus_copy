

abstract class ClassificationCertificateListEntity {
  final int totalPageCount;
  final int totalItemCount;
  final int currentPageRecordCount;
  final List<ClassificationCertificateItemEntity> classificationCertificateItem;

  ClassificationCertificateListEntity({
    required this.totalPageCount,
    required this.totalItemCount,
    required this.currentPageRecordCount,
    required this.classificationCertificateItem,
  });

  ClassificationCertificateListEntity copyWith({
    int? totalPageCount,
    int? totalItemCount,
    int? currentPageRecordCount,
    List<ClassificationCertificateItemEntity>? classificationCertificateItem,
  });

  Map<String, dynamic> toJson();

}

abstract class ClassificationCertificateItemEntity {
  final String certificateExpirationDate;
  final String serialNumber;
  final String cRorLicNumber;
  final String classificationGrade;
  final String facilityName;

  ClassificationCertificateItemEntity({
    required this.certificateExpirationDate,
    required this.serialNumber,
    required this.cRorLicNumber,
    required this.classificationGrade,
    required this.facilityName,
  });


  ClassificationCertificateItemEntity copyWith({
    String? certificateExpirationDate,
    String? serialNumber,
    String? cRorLicNumber,
    String? classificationGrade,
    String? facilityName,
  });

  Map<String, dynamic> toJson();

}
