/*class MSRTypesModel {
  MSRType msrType;
  String name;
  String image;
  String parentCode;

  MSRTypesModel(
      {required this.image,
      required this.msrType,
      required this.name,
      required this.parentCode});

  factory MSRTypesModel.fromJson(Map<String, dynamic> json) => MSRTypesModel(
        msrType: json['msrType'],
        name: json['name'],
        image: json['image'],
        parentCode: json['parentCode'],
      );

  static List<MSRTypesModel> getListOfMSRTypesFromListOfJson(
          List<dynamic> maps) =>
      maps.map((json) => MSRTypesModel.fromJson(json)).toList();
}*/
