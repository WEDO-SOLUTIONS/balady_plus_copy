class CityEntity {
  CityEntity({
    this.cityID,
    this.cityName,
  });

  CityEntity.fromJson(dynamic json) {
    cityID = json['CityID'];
    cityName = json['CityName'];
  }

  String? cityID;
  String? cityName;

  CityEntity copyWith({
    String? cityID,
    String? cityName,
  }) =>
      CityEntity(
        cityID: cityID ?? this.cityID,
        cityName: cityName ?? this.cityName,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['CityID'] = cityID;
    map['CityName'] = cityName;
    return map;
  }
}

class DistrictsEntity {
  DistrictsEntity({
    this.districtID,
    this.districtName,
  });


  DistrictsEntity.fromJson(dynamic json) {
    districtID = json['DistrictID'];
    districtName = json['DistrictName'];
  }

  String? districtID;
  String? districtName;

  CityEntity copyWith({
    String? districtID,
    String? districtName,
  }) =>
      CityEntity(
        cityID: districtID ?? this.districtID,
        cityName: districtName ?? this.districtName,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['DistrictName'] = districtID;
    map['DistrictID'] = districtName;
    return map;
  }
}
