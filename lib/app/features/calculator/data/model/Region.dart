class Region {
  int? id;
  String? name;

  Region({this.id, this.name});

  factory Region.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  Map<String, dynamic> toJson() => _$RegionToJson(this);
}

Region _$ItemFromJson(Map<String, dynamic> json) {
  return Region(
    id: json["id"],
    name: json["name"],
  );
}

Map<String, dynamic> _$RegionToJson(Region instance) => <String, dynamic>{
      "id": instance.id,
      "name": instance.name,
    };
