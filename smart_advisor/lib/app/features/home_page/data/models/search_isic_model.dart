class SearchIsicModel {
  final int? id;
  final int? rubricId;
  final String? isicCode;
  final String? isicName;
  final String? isicNameAr;
  final String? isicNameEn;

  SearchIsicModel({
    this.id,
    this.rubricId,
    this.isicCode,
    this.isicName,
    this.isicNameAr,
    this.isicNameEn,
  });

  SearchIsicModel copyWith({
    int? id,
    int? rubricId,
    String? isicCode,
    String? isicName,
    String? isicNameAr,
    String? isicNameEn,
  }) =>
      SearchIsicModel(
        id: id ?? this.id,
        rubricId: rubricId ?? this.rubricId,
        isicCode: isicCode ?? this.isicCode,
        isicName: isicName ?? this.isicName,
        isicNameAr: isicNameAr ?? this.isicNameAr,
        isicNameEn: isicNameEn ?? this.isicNameEn,
      );

  factory SearchIsicModel.fromJson(Map<String, dynamic> json) =>
      SearchIsicModel(
        id: json["id"],
        rubricId: json["rubricId"],
        isicCode: json["isicCode"],
        isicName: json["isicName"],
        isicNameAr: json["isicNameAr"],
        isicNameEn: json["isicNameEn"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "rubricId": rubricId,
        "isicCode": isicCode,
        "isicName": isicName,
        "isicNameAr": isicNameAr,
        "isicNameEn": isicNameEn,
      };
}
