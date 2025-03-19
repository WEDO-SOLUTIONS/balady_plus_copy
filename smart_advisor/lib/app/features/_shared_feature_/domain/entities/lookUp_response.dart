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
  double? maxArea;
  double? minArea;
  String? idStr;
  String? area;
  bool? isATM;
  int? count;

  LookUpItem(
      {required this.id,
      required this.name,
      this.idStr,
      this.area,
      this.maxArea,
      this.minArea,
      this.isATM,
      this.count});

  LookUpItem copyWith({int? id, String? name, String? idStr, String? area}) =>
      LookUpItem(
          id: id ?? this.id,
          name: name ?? this.name,
          idStr: idStr ?? this.idStr,
          area: area ?? this.area,
          isATM: isATM ?? this.isATM,
          count: count ?? this.count);

  factory LookUpItem.fromJson(Map<String, dynamic> json) => LookUpItem(
      id: json["id"],
      name: json["name"],
      maxArea: json["maxArea"]?.toDouble(),
      minArea: json["minArea"]?.toDouble(),
      isATM: json["atm"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name, "isATM": isATM};

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is LookUpItem && other.id == id);

  @override
  int get hashCode => super.hashCode;
}
