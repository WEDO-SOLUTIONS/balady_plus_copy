import 'package:balady_plus/app/features/classification_certificate/domain/entity/classification_certificate_list_entity.dart';

import '../../../../core/services/local/helpers.dart';

class ClassificationCertificateList
    extends ClassificationCertificateListEntity {
  // final int totalPageCount;
  // final int totalItemCount;
  // final int currentPageRecordCount;
  // final List<ClassificationCertificateItem> classificationCertificateItem;

  ClassificationCertificateList({
    required super.totalPageCount,
    required super.totalItemCount,
    required super.currentPageRecordCount,
    required super.classificationCertificateItem,
  });

  @override
  ClassificationCertificateList copyWith({
    int? totalPageCount,
    int? totalItemCount,
    int? currentPageRecordCount,
    List<ClassificationCertificateItemEntity>? classificationCertificateItem,
  }) =>
      ClassificationCertificateList(
        totalPageCount: totalPageCount ?? this.totalPageCount,
        totalItemCount: totalItemCount ?? this.totalItemCount,
        currentPageRecordCount:
            currentPageRecordCount ?? this.currentPageRecordCount,
        classificationCertificateItem:
            classificationCertificateItem ?? this.classificationCertificateItem,
      );

  factory ClassificationCertificateList.fromJson(Map<String, dynamic> json) =>
      ClassificationCertificateList(
        totalPageCount: json["totalPageCount"],
        totalItemCount: json["totalItemCount"],
        currentPageRecordCount: json["currentPageRecordCount"],
        classificationCertificateItem: List<ClassificationCertificateItem>.from(
            json["items"]
                .map((x) => ClassificationCertificateItem.fromJson(x))),
      );

  @override
  Map<String, dynamic> toJson() => {
        "totalPageCount": totalPageCount,
        "totalItemCount": totalItemCount,
        "currentPageRecordCount": currentPageRecordCount,
        "ClassificationCertificateItem": List<dynamic>.from(
            classificationCertificateItem.map((x) => x.toJson())),
      };
}

class ClassificationCertificateItem
    extends ClassificationCertificateItemEntity {
  ClassificationCertificateItem({
    required super.certificateExpirationDate,
    required super.serialNumber,
    required super.cRorLicNumber,
    required super.classificationGrade,
    required super.facilityName,
  });

  @override
  ClassificationCertificateItem copyWith({
    String? certificateExpirationDate,
    String? serialNumber,
    String? cRorLicNumber,
    String? classificationGrade,
    String? facilityName,
  }) =>
      ClassificationCertificateItem(
        certificateExpirationDate:
            certificateExpirationDate ?? this.certificateExpirationDate,
        serialNumber: serialNumber ?? this.serialNumber,
        cRorLicNumber: cRorLicNumber ?? this.cRorLicNumber,
        classificationGrade: classificationGrade ?? this.classificationGrade,
        facilityName: facilityName ?? this.facilityName,
      );

  factory ClassificationCertificateItem.fromJson(Map<String, dynamic> json) =>
      ClassificationCertificateItem(
        certificateExpirationDate: Helpers.changeToEnglish(
          json["CertificateExpirationDate"],
        ),
        serialNumber: json["SerialNumber"],
        cRorLicNumber: json["CRorLICNumber"],
        classificationGrade: json["ClassificationGrade"],
        facilityName: json["FacilityName"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "CertificateExpirationDate": certificateExpirationDate,
        "SerialNumber": serialNumber,
        "ClassificationGrade": classificationGrade,
      };
}
