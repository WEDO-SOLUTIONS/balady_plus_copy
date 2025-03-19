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
