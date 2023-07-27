class Procedure {
  int? id;
  String? name;
  int? serviceId;

  Procedure({this.id, this.name, this.serviceId});

  factory Procedure.fromJson(Map<String, dynamic> json) =>
      _$ProcedureFromJson(json);

  Map<String, dynamic> toJson() => _$ProcedureToJson(this);
}

Procedure _$ProcedureFromJson(Map<String, dynamic> json) {
  return Procedure(
      id: json["id"], name: json["name"], serviceId: json["serviceId"]);
}

Map<String, dynamic> _$ProcedureToJson(Procedure instance) => <String, dynamic>{
      "id": instance.id,
      "name": instance.name,
      "serviceId": instance.serviceId
    };
