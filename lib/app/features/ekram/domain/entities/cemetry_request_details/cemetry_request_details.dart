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
      this.prayId,
      this.prayName,
      this.prayOther,
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
      this.burialCityName,
      this.graveTypeName,
      this.graveSizeName,
      this.pandemic,
      this.deceasedIdentityTypeName});

  dynamic entryModeId;
  int? cemeteryId;
  String? cemeteryName;
  int? requestNumber;
  String? requestUniqueKey;
  String? requestDate;
  String? burialDate;
  String? burialDateHijri;
  int? prayId;
  String? prayName;
  String? prayOther;
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

  String? get burialTime => prayId == 30976 ? prayOther : prayName;
  String? graveTypeName;
  String? graveSizeName;
  bool? pandemic;
  String? deceasedIdentityTypeName;
  @override
  List<Object?> get props => [];
}
