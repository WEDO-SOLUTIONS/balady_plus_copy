class LookUpResponse {
  List<LookUpItem> items;

  LookUpResponse({
    required this.items,
  });

  LookUpResponse copyWith({
    List<LookUpItem>? items,
  }) =>
      LookUpResponse(
        items: items ?? this.items,
      );

  factory LookUpResponse.fromJson(Map<String, dynamic> json) => LookUpResponse(
        items: List<LookUpItem>.from(
            json["result"].map((x) => LookUpItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "result": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}

class LookUpItem {
  int id;
  String name;
  String? idStr;
  String? area;

  LookUpItem({required this.id, required this.name, this.idStr, this.area});

  LookUpItem copyWith({int? id, String? name, String? idStr, String? area}) =>
      LookUpItem(
          id: id ?? this.id,
          name: name ?? this.name,
          idStr: idStr ?? this.idStr,
          area: area ?? this.area);

  factory LookUpItem.fromJson(Map<String, dynamic> json) => LookUpItem(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
