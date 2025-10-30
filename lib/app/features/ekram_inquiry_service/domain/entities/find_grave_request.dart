class FindGraveRequest {
  final int? cityId;
  final String? deceasedName;
  final String? identityNumber;
  final int? identityType;
  final int? nationalityId;

  FindGraveRequest({
    this.cityId,
    this.deceasedName,
    this.identityNumber,
    this.identityType,
    this.nationalityId,
    int? districtId,
  });

  Map<String, dynamic> toJson() => {
        "cityId": cityId,
        "deceasedName": deceasedName,
        "identityNumber": identityNumber,
        "identityType": identityType,
        "nationalityId": nationalityId,
      };

  FindGraveRequest copyWith({
    int? cityId,
    String? deceasedName,
    String? identityNumber,
    int? identityType,
    int? nationalityId,
  }) {
    return FindGraveRequest(
      cityId: cityId ?? this.cityId,
      deceasedName: deceasedName ?? this.deceasedName,
      identityNumber: identityNumber ?? this.identityNumber,
      identityType: identityType ?? this.identityType,
      nationalityId: nationalityId ?? this.nationalityId,
    );
  }
}
