class DeceasedInfoModel {
  String? identityNumber;
  int? identityType;
  dynamic identityTypeName;
  String? firstName;
  dynamic secondName;
  dynamic thirdName;
  dynamic fourthName;
  dynamic fullName;
  dynamic motherName;
  String? birthDate;
  int? nationalityId;
  String? nationalityName;
  bool? isMuslim;
  dynamic mobileNumber;
  dynamic mail;
  dynamic otherMobileNumber;
  String? gender;
  dynamic biometrics;
  bool? hasIdentity;
  dynamic address;
  String? deceasedDataSource;
  bool? baladyClient;
  dynamic hideDeathInfo;

  DeceasedInfoModel({
    this.identityNumber,
    this.identityType,
    this.identityTypeName,
    this.firstName,
    this.secondName,
    this.thirdName,
    this.fourthName,
    this.fullName,
    this.motherName,
    this.birthDate,
    this.nationalityId,
    this.nationalityName,
    this.isMuslim,
    this.mobileNumber,
    this.mail,
    this.otherMobileNumber,
    this.gender,
    this.biometrics,
    this.hasIdentity,
    this.address,
    this.deceasedDataSource,
    this.baladyClient,
    this.hideDeathInfo,
  });

  factory DeceasedInfoModel.fromJson(Map<String, dynamic> json) =>
      DeceasedInfoModel(
        identityNumber: json['identityNumber'] as String?,
        identityType: json['identityType'] as int?,
        identityTypeName: json['identityTypeName'] as dynamic,
        firstName: json['firstName'] as String?,
        secondName: json['secondName'] as dynamic,
        thirdName: json['thirdName'] as dynamic,
        fourthName: json['fourthName'] as dynamic,
        fullName: json['fullName'] as dynamic,
        motherName: json['motherName'] as dynamic,
        birthDate: json['birthDate'] as String?,
        nationalityId: json['nationalityId'] as int?,
        nationalityName: json['nationalityName'] as String?,
        isMuslim: json['isMuslim'] as bool?,
        mobileNumber: json['mobileNumber'] as dynamic,
        mail: json['mail'] as dynamic,
        otherMobileNumber: json['otherMobileNumber'] as dynamic,
        gender: json['gender'] as String?,
        biometrics: json['biometrics'] as dynamic,
        hasIdentity: json['hasIdentity'] as bool?,
        address: json['address'] as dynamic,
        deceasedDataSource: json['deceasedDataSource'] as String?,
        baladyClient: json['baladyClient'] as bool?,
        hideDeathInfo: json['hideDeathInfo'] as dynamic,
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
        'motherName': motherName,
        'birthDate': birthDate,
        'nationalityId': nationalityId,
        'nationalityName': nationalityName,
        'isMuslim': isMuslim,
        'mobileNumber': mobileNumber,
        'mail': mail,
        'otherMobileNumber': otherMobileNumber,
        'gender': gender,
        'biometrics': biometrics,
        'hasIdentity': hasIdentity,
        'address': address,
        'deceasedDataSource': deceasedDataSource,
        'baladyClient': baladyClient,
        'hideDeathInfo': hideDeathInfo,
      };
}
