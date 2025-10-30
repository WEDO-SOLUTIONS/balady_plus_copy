class UserInfoResponse {
  String? firstName;
  String? secondName;
  String? thirdName;
  String? familyName;
  int? religionCode;
  String? religionDescription;
  int? nationalityCode;
  String? nationalityDescription;
  int? genderCode;
  String? genderDescription;

  UserInfoResponse({
    this.firstName,
    this.secondName,
    this.thirdName,
    this.familyName,
    this.religionCode,
    this.religionDescription,
    this.nationalityCode,
    this.nationalityDescription,
    this.genderCode,
    this.genderDescription,
  });

  String? get fullName => "$firstName $secondName $thirdName $familyName";
}
