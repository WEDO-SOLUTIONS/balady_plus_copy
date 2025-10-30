class FindCemetryRequest {
  int? cityId;
  int? districtId;
  bool? laundryExist;
  bool? muslim;
  FindCemetryRequest({
    this.cityId,
    this.districtId,
    this.laundryExist,
    this.muslim,
  });

  FindCemetryRequest copyWith({
    int? cityId,
    int? districtId,
    bool? laundryExist,
    bool? muslim,
  }) {
    return FindCemetryRequest(
      cityId: cityId ?? this.cityId,
      districtId: districtId ?? this.districtId,
      laundryExist: laundryExist ?? this.laundryExist,
      muslim: muslim ?? this.muslim,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cityId': cityId,
      'districtId': districtId,
      'laundryExist': laundryExist,
      'muslim': muslim,
    };
  }
}
