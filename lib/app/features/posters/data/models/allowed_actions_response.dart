class PosterAllowedAction {
  final List<AllowedActionItem>? result;

  PosterAllowedAction({
    this.result,
  });

  factory PosterAllowedAction.fromJson(Map<String, dynamic> json) =>
      PosterAllowedAction(
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
