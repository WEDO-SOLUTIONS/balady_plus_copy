class ObserverStatusEntity {
  ObserverStatusEntity({
    this.qualification,
    this.freelanceCertificateNumber,
    this.freelanceCertificateExpiryDate,
    required this.isCertifiedObserver,
    this.iDNumber,
  });

  factory ObserverStatusEntity.fromJson(dynamic json) => ObserverStatusEntity(
        qualification: json['Qualification'],
        freelanceCertificateNumber: json['FreelanceCertificateNumber'],
        freelanceCertificateExpiryDate: json['FreelanceCertificateExpiryDate'],
        isCertifiedObserver: json['IsCertifiedObserver'] ?? false,
        iDNumber: json['IDNumber'],
      );

  String? qualification;
  String? freelanceCertificateNumber;
  String? freelanceCertificateExpiryDate;
  bool isCertifiedObserver;
  String? iDNumber;

  ObserverStatusEntity copyWith({
    String? qualification,
    String? freelanceCertificateNumber,
    String? freelanceCertificateExpiryDate,
    bool? isCertifiedObserver,
    String? iDNumber,
  }) =>
      ObserverStatusEntity(
        qualification: qualification ?? this.qualification,
        freelanceCertificateNumber:
            freelanceCertificateNumber ?? this.freelanceCertificateNumber,
        freelanceCertificateExpiryDate: freelanceCertificateExpiryDate ??
            this.freelanceCertificateExpiryDate,
        isCertifiedObserver: isCertifiedObserver ?? this.isCertifiedObserver,
        iDNumber: iDNumber ?? this.iDNumber,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Qualification'] = qualification;
    map['FreelanceCertificateNumber'] = freelanceCertificateNumber;
    map['FreelanceCertificateExpiryDate'] = freelanceCertificateExpiryDate;
    map['IsCertifiedObserver'] = isCertifiedObserver;
    map['IDNumber'] = iDNumber;
    return map;
  }
}
