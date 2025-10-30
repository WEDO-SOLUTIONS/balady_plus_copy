class Item {
  int? id;
  String? name;

  Item({this.id, this.name});

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  Map<String, dynamic> toJson() => _$ItemToJson(this);
}

Item _$ItemFromJson(Map<String, dynamic> json) {
  return Item(
    id: json["id"],
    name: json["name"],
  );
}

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
      "id": instance.id,
      "name": instance.name,
    };
