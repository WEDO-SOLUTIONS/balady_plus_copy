List<RequestAllowedActions> requestAllowedActionsListFromJson(List list) =>
    List<RequestAllowedActions>.from(
      list.map(
        (e) => RequestAllowedActions.fromJson(e),
      ),
    );

class RequestAllowedActions {
  // String ename;
  String id;
  String name;

  RequestAllowedActions({
    // required this.ename,
    required this.id,
    required this.name,
  });

  factory RequestAllowedActions.fromJson(Map<String, dynamic> json) =>
      RequestAllowedActions(
        // ename: json["ename"],
        id: json["id"],
        name: json["actionName"],
      );

  Map<String, dynamic> toJson() => {
        // "ename": ename,
        "id": id,
        "name": name,
      };
}
