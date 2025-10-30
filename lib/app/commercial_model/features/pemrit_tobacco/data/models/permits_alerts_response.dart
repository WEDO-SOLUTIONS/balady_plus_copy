class PermitTobaccoAlertsResponse {
  final List<PermitAlertItem>? result;

  PermitTobaccoAlertsResponse({
    this.result,
  });

  factory PermitTobaccoAlertsResponse.fromJson(Map<String, dynamic> json) =>
      PermitTobaccoAlertsResponse(
        result: json["result"] == null
            ? []
            : List<PermitAlertItem>.from(
                json["result"]!.map((x) => PermitAlertItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "result": result == null
            ? []
            : List<dynamic>.from(result!.map((x) => x.toJson())),
      };
}

class PermitAlertItem {
  final String? id;
  final String? name;

  PermitAlertItem({
    this.id,
    this.name,
  });

  factory PermitAlertItem.fromJson(Map<String, dynamic> json) =>
      PermitAlertItem(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
