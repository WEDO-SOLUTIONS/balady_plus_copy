class DeceasedInfo {
  String? identityNumber;
  String? identityTypeName;
  String? firstName;
  String? secondName;
  String? thirdName;
  String? fourthName;
  String? birthDate;
  int? nationalityId;
  bool? isMuslim;
  String? gender;
  bool? hasIdentity;
  bool? baladyClient;

  DeceasedInfo({
    this.identityNumber,
    this.identityTypeName,
    this.firstName,
    this.secondName,
    this.thirdName,
    this.fourthName,
    this.birthDate,
    this.nationalityId,
    this.isMuslim,
    this.gender,
    this.hasIdentity,
    this.baladyClient,
  });

  factory DeceasedInfo.fromJson(Map<String, dynamic> json) => DeceasedInfo(
        identityNumber: json['identityNumber'] as String?,
        identityTypeName: json['identityTypeName'] as String?,
        firstName: json['firstName'] as String?,
        secondName: json['secondName'] as String?,
        thirdName: json['thirdName'] as String?,
        fourthName: json['fourthName'] as String?,
        birthDate: json['birthDate'] as String?,
        nationalityId: json['nationalityId'] as int?,
        isMuslim: json['isMuslim'] as bool?,
        gender: json['gender'] as String?,
        hasIdentity: json['hasIdentity'] as bool?,
        baladyClient: json['baladyClient'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        'identityNumber': identityNumber,
        'identityTypeName': identityTypeName,
        'firstName': firstName,
        'secondName': secondName,
        'thirdName': thirdName,
        'fourthName': fourthName,
        'birthDate': birthDate,
        'nationalityId': nationalityId,
        'isMuslim': isMuslim,
        'gender': gender,
        'hasIdentity': hasIdentity,
        'baladyClient': baladyClient,
      };

  DeceasedInfo copyWith({
    String? identityNumber,
    String? identityTypeName,
    String? firstName,
    String? secondName,
    String? thirdName,
    String? fourthName,
    String? birthDate,
    int? nationalityId,
    bool? isMuslim,
    String? gender,
    bool? hasIdentity,
    bool? baladyClient,
  }) {
    return DeceasedInfo(
      identityNumber: identityNumber ?? this.identityNumber,
      identityTypeName: identityTypeName ?? this.identityTypeName,
      firstName: firstName ?? this.firstName,
      secondName: secondName ?? this.secondName,
      thirdName: thirdName ?? this.thirdName,
      fourthName: fourthName ?? this.fourthName,
      birthDate: birthDate ?? this.birthDate,
      nationalityId: nationalityId ?? this.nationalityId,
      isMuslim: isMuslim ?? this.isMuslim,
      gender: gender ?? this.gender,
      hasIdentity: hasIdentity ?? this.hasIdentity,
      baladyClient: baladyClient ?? this.baladyClient,
    );
  }
}
