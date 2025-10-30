// ignore_for_file: public_member_api_docs, sort_constructors_first
class BookCemetryParamas {
  String firstName;
  String? secondName;
  String? thirdName;
  String? fourthName;
  String? birthDate;
  int? deathCountryId;
  int? deathCityId;
  String? deathCityOther;
  int? prayId;
  int? nationalityId;
  bool? isMuslim;
  String? gender;

  int burialCityId;
  String burialDate;
  int cemeteryId;
  String? deceasedBirthDate;
  String? deceasedIdentityNumber;
  int? deceasedIdentityTypeId;
  bool isPandemicDeath;
  String? relationship;
  bool fetus;
  int? graveTypeId;
  String? prayOther;
  BookCemetryParamas({
    required this.firstName,
    this.secondName,
    this.thirdName,
    this.fourthName,
    this.birthDate,
    this.deathCountryId,
    this.deathCityId,
    this.deathCityOther,
    this.prayId,
    this.nationalityId,
    this.isMuslim,
    this.gender,
    required this.burialCityId,
    required this.burialDate,
    required this.cemeteryId,
    required this.deceasedBirthDate,
    this.deceasedIdentityNumber,
    this.deceasedIdentityTypeId,
    required this.isPandemicDeath,
    this.relationship,
    required this.fetus,
    required this.graveTypeId,
    this.prayOther,
  });

  Map<String, dynamic> toMap() => {
        "deceased": {
          "identityNumber": deceasedIdentityNumber,
          "identityType": deceasedIdentityTypeId,
          "firstName": firstName,
          "secondName": secondName,
          "thirdName": thirdName,
          "fourthName": fourthName,
          "birthDate": birthDate,
          "nationalityId": nationalityId,
          "isMuslim": isMuslim,
          "gender": gender,
        },
        "applicantInfo": {"relationshipOthers": relationship},
        "burialInfo": {
          "deathCountryId": deathCountryId,
          "deathCityId": deathCityId,
          "deathCityOther": deathCityOther,
          "burialDate": burialDate,
          "prayId": prayId,
          "cemeteryId": cemeteryId,
          "fetus": fetus,
          "graveTypeId": graveTypeId,
          "isPandemicDeath": isPandemicDeath,
          "prayOther": prayOther
        },
      };
}
