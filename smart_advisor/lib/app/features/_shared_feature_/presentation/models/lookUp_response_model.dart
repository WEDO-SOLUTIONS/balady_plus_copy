import '/app/features/_shared_feature_/domain/entities/lookUp_response.dart';

class LookUpResponseModel extends LookUpResponse {
  LookUpResponseModel({
    required super.items,
  });

  factory LookUpResponseModel.fromJson(Map<String, dynamic> json) =>
      LookUpResponseModel(
        items: List<LookUpItem>.from(
            json["result"].map((x) => LookUpItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "result": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}

class LookUpItemModel extends LookUpItem {
  LookUpItemModel(
      {required super.id,
      required super.name,
      super.maxArea,
      super.minArea,
      super.isATM,
      super.count});

  factory LookUpItemModel.fromJson(Map<String, dynamic> json) =>
      LookUpItemModel(
          id: json["id"],
          name: json["name"],
          maxArea: json["maxArea"]?.toDouble(),
          minArea: json["minArea"]?.toDouble(),
          isATM: json["atm"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
