class GhuslEmploye {
  GhuslEmploye({
      this.identityNumber, 
      this.identityType, 
      this.firstName, 
      this.secondName, 
      this.thirdName, 
      this.fourthName, 
      this.fullName, 
      this.birthDate, 
      this.nationalityId, 
      this.nationalityName, 
      this.isMuslim, 
      this.mobileNumber, 
      this.mail, 
      this.gender, 
      this.hasIdentity, 
      this.baladyClient,});

  GhuslEmploye.fromJson(dynamic json) {
    identityNumber = json['identityNumber'];
    identityType = json['identityType'];
    firstName = json['firstName'];
    secondName = json['secondName'];
    thirdName = json['thirdName'];
    fourthName = json['fourthName'];
    fullName = json['fullName'];
    birthDate = json['birthDate'];
    nationalityId = json['nationalityId'];
    nationalityName = json['nationalityName'];
    isMuslim = json['isMuslim'];
    mobileNumber = json['mobileNumber'];
    mail = json['mail'];
    gender = json['gender'];
    hasIdentity = json['hasIdentity'];
    baladyClient = json['baladyClient'];
  }
  String? identityNumber;
  int? identityType;
  String? firstName;
  String? secondName;
  String? thirdName;
  String? fourthName;
  String? fullName;
  String? birthDate;
  int? nationalityId;
  String? nationalityName;
  bool? isMuslim;
  String? mobileNumber;
  String? mail;
  String? gender;
  bool? hasIdentity;
  bool? baladyClient;
GhuslEmploye copyWith({  String? identityNumber,
  int? identityType,
  String? firstName,
  String? secondName,
  String? thirdName,
  String? fourthName,
  String? fullName,
  String? birthDate,
  int? nationalityId,
  String? nationalityName,
  bool? isMuslim,
  String? mobileNumber,
  String? mail,
  String? gender,
  bool? hasIdentity,
  bool? baladyClient,
}) => GhuslEmploye(  identityNumber: identityNumber ?? this.identityNumber,
  identityType: identityType ?? this.identityType,
  firstName: firstName ?? this.firstName,
  secondName: secondName ?? this.secondName,
  thirdName: thirdName ?? this.thirdName,
  fourthName: fourthName ?? this.fourthName,
  fullName: fullName ?? this.fullName,
  birthDate: birthDate ?? this.birthDate,
  nationalityId: nationalityId ?? this.nationalityId,
  nationalityName: nationalityName ?? this.nationalityName,
  isMuslim: isMuslim ?? this.isMuslim,
  mobileNumber: mobileNumber ?? this.mobileNumber,
  mail: mail ?? this.mail,
  gender: gender ?? this.gender,
  hasIdentity: hasIdentity ?? this.hasIdentity,
  baladyClient: baladyClient ?? this.baladyClient,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['identityNumber'] = identityNumber;
    map['identityType'] = identityType;
    map['firstName'] = firstName;
    map['secondName'] = secondName;
    map['thirdName'] = thirdName;
    map['fourthName'] = fourthName;
    map['fullName'] = fullName;
    map['birthDate'] = birthDate;
    map['nationalityId'] = nationalityId;
    map['nationalityName'] = nationalityName;
    map['isMuslim'] = isMuslim;
    map['mobileNumber'] = mobileNumber;
    map['mail'] = mail;
    map['gender'] = gender;
    map['hasIdentity'] = hasIdentity;
    map['baladyClient'] = baladyClient;
    return map;
  }

}