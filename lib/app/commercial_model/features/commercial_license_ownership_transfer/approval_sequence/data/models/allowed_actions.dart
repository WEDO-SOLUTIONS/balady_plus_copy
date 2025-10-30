List<AllowedActions> allowedActionsListFromJson(List list) =>
    List<AllowedActions>.from(
      list.map(
        (e) => AllowedActions.fromJson(e),
      ),
    );

class AllowedActions {
  // String ename;
  int id;
  String name;

  AllowedActions({
    // required this.ename,
    required this.id,
    required this.name,
  });

  factory AllowedActions.fromJson(Map<String, dynamic> json) => AllowedActions(
        // ename: json["ename"],
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        // "ename": ename,
        "id": id,
        "name": name,
      };
}

List<AllowedActions> listAllowedActions = [
  AllowedActions(id: 1, name: 'الغاء'),
  AllowedActions(id: 2, name: 'الغاء'),
];
