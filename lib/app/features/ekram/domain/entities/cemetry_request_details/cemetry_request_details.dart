class CemetryRequestDetails {
  CemetryRequestDetails(
      {this.entryModeId,
      this.cemeteryId,
      this.cemeteryName,
      this.requestNumber,
      this.requestUniqueKey,
      this.requestDate,
      this.burialDate,
      this.burialDateHijri,
      this.burialTimeId,
      this.burialTimeName,
      this.burialTimeOther,
      this.deceasedBirthdate,
      this.deceasedBirthdateHijri,
      this.deceasedName,
      this.deceasedIdentityNumber,
      this.nationalityId,
      this.nationalityName,
      this.genderId,
      this.genderName,
      this.religionId,
      this.religionName,
      this.submitterName,
      this.submitterMobileNumber,
      this.requestStatusId,
      this.requestStatusName,
      this.apologyReason,
      this.deathCityName,
      this.deathCityId,
      this.deathCountryName,
      this.deathCountryId,
      this.burialCityName});

  dynamic entryModeId;
  int? cemeteryId;
  String? cemeteryName;
  int? requestNumber;
  String? requestUniqueKey;
  String? requestDate;
  String? burialDate;
  String? burialDateHijri;
  int? burialTimeId;
  String? burialTimeName;
  String? burialTimeOther;
  String? deceasedBirthdate;
  String? deceasedBirthdateHijri;
  String? deceasedName;
  String? deceasedIdentityNumber;
  String? burialCityName;
  int? nationalityId;
  String? nationalityName;
  int? genderId;
  String? genderName;
  int? religionId;
  String? religionName;
  String? submitterName;
  String? submitterMobileNumber;
  int? requestStatusId;
  String? requestStatusName;
  String? apologyReason;

  String? deathCityName;
  int? deathCityId;
  String? deathCountryName;
  int? deathCountryId;

  String? get burialTime =>
      burialTimeId == 30976 ? burialTimeOther : burialTimeName;

  @override
  List<Object?> get props => [];
}
