class GroupItemResponseModel {
  final List<PermitGroupItem>? result;

  GroupItemResponseModel({
    this.result,
  });

  factory GroupItemResponseModel.fromJson(Map<String, dynamic> json) =>
      GroupItemResponseModel(
        result: json["result"] == null
            ? []
            : List<PermitGroupItem>.from(
                json["result"]!.map((x) => PermitGroupItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "result": result == null
            ? []
            : List<dynamic>.from(result!.map((x) => x.toJson())),
      };
}

class PermitGroupItem {
  final int? id;
  final String? name;

  PermitGroupItem({
    this.id,
    this.name,
  });

  factory PermitGroupItem.fromJson(Map<String, dynamic> json) =>
      PermitGroupItem(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
