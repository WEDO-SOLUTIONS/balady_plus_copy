class PermitPosterTypeResponse {
  final List<PermitPosterTypeItem>? result;

  PermitPosterTypeResponse({
    this.result,
  });

  factory PermitPosterTypeResponse.fromJson(Map<String, dynamic> json) =>
      PermitPosterTypeResponse(
        result: json["result"] == null
            ? []
            : List<PermitPosterTypeItem>.from(
                json["result"]!.map((x) => PermitPosterTypeItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "result": result == null
            ? []
            : List<dynamic>.from(result!.map((x) => x.toJson())),
      };
}

class PermitPosterTypeItem {
  final int? id;
  final String? name;

  PermitPosterTypeItem({
    this.id,
    this.name,
  });

  factory PermitPosterTypeItem.fromJson(Map<String, dynamic> json) =>
      PermitPosterTypeItem(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };

  String get text => name ?? "";
}
