class SubActivity {
  String? id;
  String? name_ar;
  bool? is_divided_area;
  bool? is_accommodation;
  String? unit;
  String? service_id;
  String? period;

  SubActivity(
      {this.id,
      this.name_ar,
      this.is_divided_area,
      this.is_accommodation,
      this.unit,
      this.service_id,
      this.period});

  factory SubActivity.fromJson(Map<String, dynamic> json) =>
      _$SubActivityFromJson(json);

  Map<String, dynamic> toJson() => _$SubActivityToJson(this);

  int? getId() {
    if (int.tryParse(id!) != null) {
      return int.parse(id!);
    }
  }
}

SubActivity _$SubActivityFromJson(Map<String, dynamic> json) {
  return SubActivity(
    id: json["id"],
    name_ar: json["name_ar"],
    is_divided_area: json["is_divided_area"],
    is_accommodation: json["is_accommodation"],
    unit: json["unit"],
    service_id: json["service_id"],
    period: json["period"],
  );
}

Map<String, dynamic> _$SubActivityToJson(SubActivity instance) =>
    <String, dynamic>{
      "id": instance.id,
      "name_ar": instance.name_ar,
      "is_divided_area": instance.is_divided_area,
      "is_accommodation": instance.is_accommodation,
      "unit": instance.unit,
      "service_id": instance.service_id,
      "period": instance.period,
    };
