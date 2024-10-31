
class CityLookupsModel  {
  final String cityCode;
  final String text;

  CityLookupsModel({
    required this.cityCode,
    required this.text,
  });

  CityLookupsModel copyWith({
    String? cityCode,
    String? city,
  }) =>
      CityLookupsModel(
        cityCode: cityCode ?? this.cityCode,
        text: city ?? this.text,
      );

  factory CityLookupsModel.fromJson(Map<String, dynamic> json) => CityLookupsModel(
    cityCode: json["CityCode"],
    text: json["City"],
  );

  Map<String, dynamic> toJson() => {
    "CityCode": cityCode,
    "City": text,
  };

  @override
  String toString() {
    return text;
  }
}

