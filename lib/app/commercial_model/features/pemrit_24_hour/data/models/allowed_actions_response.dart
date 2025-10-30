class Permit24AllowedAction {
  final List<AllowedActionItem>? result;

  Permit24AllowedAction({
    this.result,
  });

  factory Permit24AllowedAction.fromJson(Map<String, dynamic> json) =>
      Permit24AllowedAction(
        result: json["result"] == null
            ? []
            : List<AllowedActionItem>.from(
                json["result"]!.map((x) => AllowedActionItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "result": result == null
            ? []
            : List<dynamic>.from(result!.map((x) => x.toJson())),
      };
}

class AllowedActionItem {
  final String? actionName;
  final String? id;

  AllowedActionItem({
    this.actionName,
    this.id,
  });

  factory AllowedActionItem.fromJson(Map<String, dynamic> json) =>
      AllowedActionItem(
        actionName: json["actionName"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "actionName": actionName,
        "id": id,
      };
}
