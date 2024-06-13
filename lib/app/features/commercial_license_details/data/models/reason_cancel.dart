List<ReasonCancel> allowedActionsListFromJson(List list) =>
    List<ReasonCancel>.from(
      list.map(
        (e) => ReasonCancel.fromJson(e),
      ),
    );

class ReasonCancel {
  // String ename;
  int id;
  String text;

  ReasonCancel({
    // required this.ename,
    required this.id,
    required this.text,
  });

  factory ReasonCancel.fromJson(Map<String, dynamic> json) => ReasonCancel(
        // ename: json["ename"],
        id: json["id"],
        text: json["name"],
      );

  Map<String, dynamic> toJson() => {
        // "ename": ename,
        "id": id,
        "name": text,
      };

  @override
  String toString() {
    return text;
  }
}
