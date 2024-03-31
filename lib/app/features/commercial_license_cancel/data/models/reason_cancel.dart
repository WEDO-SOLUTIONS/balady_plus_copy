List<CancellationReason> allowedActionsListFromJson(List list) =>
    List<CancellationReason>.from(
      list.map(
        (e) => CancellationReason.fromJson(e),
      ),
    );

class CancellationReason {
  // String ename;
  int id;
  String text;

  CancellationReason({
    // required this.ename,
    required this.id,
    required this.text,
  });

  factory CancellationReason.fromJson(Map<String, dynamic> json) =>
      CancellationReason(
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
