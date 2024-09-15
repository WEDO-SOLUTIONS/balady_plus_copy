
class CityLookupsModel  {
  final String cityCode;
  final String city;

  CityLookupsModel({
    required this.cityCode,
    required this.city,
  });

  CityLookupsModel copyWith({
    String? cityCode,
    String? city,
  }) =>
      CityLookupsModel(
        cityCode: cityCode ?? this.cityCode,
        city: city ?? this.city,
      );

  factory CityLookupsModel.fromJson(Map<String, dynamic> json) => CityLookupsModel(
    cityCode: json["CityCode"],
    city: json["City"],
  );

  Map<String, dynamic> toJson() => {
    "CityCode": cityCode,
    "City": city,
  };
}

