
class ClassificationCertificateLookupModel {
  final String lookUpType;
  final String valueAr;
  final String lookUpCode;
  final String valueEn;
  final int code;

  ClassificationCertificateLookupModel({
    required this.lookUpType,
    required this.valueAr,
    required this.lookUpCode,
    required this.valueEn,
    required this.code,
  });

  ClassificationCertificateLookupModel copyWith({
    String? lookUpType,
    String? valueAr,
    String? lookUpCode,
    String? valueEn,
    int? code,
  }) =>
      ClassificationCertificateLookupModel(
        lookUpType: lookUpType ?? this.lookUpType,
        valueAr: valueAr ?? this.valueAr,
        lookUpCode: lookUpCode ?? this.lookUpCode,
        valueEn: valueEn ?? this.valueEn,
        code: code ?? this.code,
      );

  factory ClassificationCertificateLookupModel.fromJson(Map<String, dynamic> json) => ClassificationCertificateLookupModel(
    lookUpType: json["LookUpType"],
    valueAr: json["Value_Ar"],
    lookUpCode: json["LookUpCode"],
    valueEn: json["Value_En"],
    code: int.tryParse(json["Code"] ?? "") ?? -1,
  );

  Map<String, dynamic> toJson() => {
    "LookUpType": lookUpType,
    "Value_Ar": valueAr,
    "LookUpCode": lookUpCode,
    "Value_En": valueEn,
    "Code": code,
  };
}
