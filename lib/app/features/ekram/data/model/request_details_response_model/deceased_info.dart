import 'biometrics.dart';

class DeceasedInfo {
  String? identityNumber;
  int? identityType;
  String? identityTypeName;
  String? firstName;
  String? secondName;
  String? thirdName;
  String? fourthName;
  String? fullName;
  String? birthDate;
  int? nationalityId;
  String? nationalityName;
  bool? isMuslim;
  String? gender;
  Biometrics? biometrics;
  bool? hasIdentity;
  bool? baladyClient;
  bool? hideDeathInfo;
  String? deceasedDataSource;

  DeceasedInfo({
    this.identityNumber,
    this.identityType,
    this.identityTypeName,
    this.firstName,
    this.secondName,
    this.thirdName,
    this.fourthName,
    this.fullName,
    this.birthDate,
    this.nationalityId,
    this.nationalityName,
    this.isMuslim,
    this.gender,
    this.biometrics,
    this.hasIdentity,
    this.baladyClient,
    this.hideDeathInfo,
    this.deceasedDataSource,
  });

  factory DeceasedInfo.fromJson(Map<String, dynamic> json) => DeceasedInfo(
        identityNumber: json['identityNumber'] as String?,
        identityType: json['identityType'] as int?,
        identityTypeName: json['identityTypeName'] as String?,
        firstName: json['firstName'] as String?,
        secondName: json['secondName'] as String?,
        thirdName: json['thirdName'] as String?,
        fourthName: json['fourthName'] as String?,
        fullName: json['fullName'] as String?,
        birthDate: json['birthDate'] as String?,
        nationalityId: json['nationalityId'] as int?,
        nationalityName: json['nationalityName'] as String?,
        isMuslim: json['isMuslim'] as bool?,
        gender: json['gender'] as String?,
        biometrics: json['biometrics'] == null
            ? null
            : Biometrics.fromJson(json['biometrics'] as Map<String, dynamic>),
        hasIdentity: json['hasIdentity'] as bool?,
        baladyClient: json['baladyClient'] as bool?,
        hideDeathInfo: json['hideDeathInfo'] as bool?,
        deceasedDataSource: json['deceasedDataSource'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'identityNumber': identityNumber,
        'identityType': identityType,
        'identityTypeName': identityTypeName,
        'firstName': firstName,
        'secondName': secondName,
        'thirdName': thirdName,
        'fourthName': fourthName,
        'fullName': fullName,
        'birthDate': birthDate,
        'nationalityId': nationalityId,
        'nationalityName': nationalityName,
        'isMuslim': isMuslim,
        'gender': gender,
        'biometrics': biometrics?.toJson(),
        'hasIdentity': hasIdentity,
        'baladyClient': baladyClient,
        'hideDeathInfo': hideDeathInfo,
        'deceasedDataSource': deceasedDataSource,
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
