class GetCemetriesParams {
  int burialCityId;
  int burailTimeId;
  String burialDate;
  int cemeteryTypeId;
  bool isFetus;
  bool isMuslim;
  bool isPandemicDeath;
  int nationalityId;
  String? birthdate;

  GetCemetriesParams(
      {required this.burialCityId,
      required this.burialDate,
      required this.burailTimeId,
      required this.cemeteryTypeId,
      required this.isPandemicDeath,
      required this.nationalityId,
      required this.isMuslim,
      required this.isFetus,
      this.birthdate});

  Map<String, dynamic> toMap() => {
        "burialCityId": burialCityId,
        "burailTimeId": burailTimeId,
        "burialDate": burialDate,
        "cemeteryTypeId": cemeteryTypeId == 0 ? "" : cemeteryTypeId,
        "isFetus": isFetus,
        "isMuslim": isMuslim,
        "isPandemicDeath": isPandemicDeath,
        "nationalityId": nationalityId,
        if (birthdate != null) "birthdate": birthdate
      };
}
