class UserCertificates {
  UserCertificates({
    required this.englishName,
    required this.nationalId,
    required this.arabicName,
    required this.nationalIdExpiryDate,
    required this.certificate,
    required this.gender,
  });

  final String? englishName;
  final String? nationalId;
  final String? arabicName;
  final DateTime? nationalIdExpiryDate;
  final List<FreelancerCertificate> certificate;
  final String? gender;

  UserCertificates copyWith({
    String? englishName,
    String? nationalId,
    String? arabicName,
    DateTime? nationalIdExpiryDate,
    List<FreelancerCertificate>? certificate,
    String? gender,
  }) {
    return UserCertificates(
      englishName: englishName ?? this.englishName,
      nationalId: nationalId ?? this.nationalId,
      arabicName: arabicName ?? this.arabicName,
      nationalIdExpiryDate: nationalIdExpiryDate ?? this.nationalIdExpiryDate,
      certificate: certificate ?? this.certificate,
      gender: gender ?? this.gender,
    );
  }

  factory UserCertificates.fromJson(Map<String, dynamic> json){
    return UserCertificates(
      englishName: json["englishName"],
      nationalId: json["nationalId"],
      arabicName: json["arabicName"],
      nationalIdExpiryDate: DateTime.tryParse(json["nationalIdExpiryDate"] ?? ""),
      certificate: json["certificate"] == null ? [] : List<FreelancerCertificate>.from(json["certificate"]!.map((x) => FreelancerCertificate.fromJson(x))),
      gender: json["gender"],
    );
  }



}

class FreelancerCertificate {
  FreelancerCertificate({
    required this.expiryDate,
    required this.number,
    required this.status,
    required this.revokedAt,
    required this.issueDate,
    required this.speciality,
    required this.canceledAt,
  });

  final DateTime? expiryDate;
  final String? number;
  final String? status;
  final dynamic revokedAt;
  final DateTime? issueDate;
  final Speciality? speciality;
  final dynamic canceledAt;

  FreelancerCertificate copyWith({
    DateTime? expiryDate,
    String? number,
    String? status,
    dynamic? revokedAt,
    DateTime? issueDate,
    Speciality? speciality,
    dynamic? canceledAt,
  }) {
    return FreelancerCertificate(
      expiryDate: expiryDate ?? this.expiryDate,
      number: number ?? this.number,
      status: status ?? this.status,
      revokedAt: revokedAt ?? this.revokedAt,
      issueDate: issueDate ?? this.issueDate,
      speciality: speciality ?? this.speciality,
      canceledAt: canceledAt ?? this.canceledAt,
    );
  }

  factory FreelancerCertificate.fromJson(Map<String, dynamic> json){
    return FreelancerCertificate(
      expiryDate: DateTime.tryParse(json["expiryDate"] ?? ""),
      number: json["number"],
      status: json["status"],
      revokedAt: json["revokedAt"],
      issueDate: DateTime.tryParse(json["issueDate"] ?? ""),
      speciality: json["speciality"] == null ? null : Speciality.fromJson(json["speciality"]),
      canceledAt: json["canceledAt"],
    );
  }


}

class Speciality {
  Speciality({
    required this.code,
    required this.name,
    required this.nameEn,
    required this.category,
  });

  final String? code;
  final String? name;
  final String? nameEn;
  final Speciality? category;

  Speciality copyWith({
    String? code,
    String? name,
    String? nameEn,
    Speciality? category,
  }) {
    return Speciality(
      code: code ?? this.code,
      name: name ?? this.name,
      nameEn: nameEn ?? this.nameEn,
      category: category ?? this.category,
    );
  }

  factory Speciality.fromJson(Map<String, dynamic> json){
    return Speciality(
      code: json["code"],
      name: json["name"],
      nameEn: json["nameEn"],
      category: json["category"] == null ? null : Speciality.fromJson(json["category"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "code": code,
    "name": name,
    "nameEn": nameEn,
    "category": category?.toJson(),
  };

}
