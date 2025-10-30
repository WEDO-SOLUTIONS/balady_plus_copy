class Municipality {
  String? id;
  String? name;

  Municipality({this.id, this.name});

  factory Municipality.fromJson(Map<String, dynamic> json) =>
      _$MunicipalityFromJson(json);

  Map<String, dynamic> toJson() => _$MunicipalityToJson(this);
}

Municipality _$MunicipalityFromJson(Map<String, dynamic> json) {
  return Municipality(
    id: json["id"],
    name: json["name"],
  );
}

Map<String, dynamic> _$MunicipalityToJson(Municipality instance) =>
    <String, dynamic>{
      "id": instance.id,
      "name": instance.name,
    };
