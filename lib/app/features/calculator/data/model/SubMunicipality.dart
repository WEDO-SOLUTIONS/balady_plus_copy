class SubMunicipality {
  String? id;
  String? name;
  int? segmantId;

  SubMunicipality({this.id, this.name, this.segmantId});

  factory SubMunicipality.fromJson(Map<String, dynamic> json) =>
      _$SubMunicipalityFromJson(json);

  Map<String, dynamic> toJson() => _$SubMunicipalityToJson(this);
}

SubMunicipality _$SubMunicipalityFromJson(Map<String, dynamic> json) {
  return SubMunicipality(
      id: json["id"], name: json["name"], segmantId: json["segmantId"]);
}

Map<String, dynamic> _$SubMunicipalityToJson(SubMunicipality instance) =>
    <String, dynamic>{
      "id": instance.id,
      "name": instance.name,
      "segmantId": instance.segmantId
    };
