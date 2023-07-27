class DetailedActivity {
  int? id;
  int? isicNumber;
  String? name;
  String? unit;
  String? unitDesc;
  int? maxYears;
  int? minYears;
  bool? isLicenseOwnerFemaleOnly;
  bool? isWorkerTypeFemaleOnly;
  int? isTabacco;
  bool? fawry;
  int? twentyFourHourStatus;

  DetailedActivity(
      {this.id,
      this.isicNumber,
      this.name,
      this.unit,
      this.unitDesc,
      this.maxYears,
      this.minYears,
      this.isLicenseOwnerFemaleOnly,
      this.isWorkerTypeFemaleOnly,
      this.isTabacco,
      this.fawry,
      this.twentyFourHourStatus});

  factory DetailedActivity.fromJson(Map<String, dynamic> json) =>
      _$DetailedActivityFromJson(json);

  Map<String, dynamic> toJson() => _$DetailedActivityToJson(this);
}

DetailedActivity _$DetailedActivityFromJson(Map<String, dynamic> json) {
  return DetailedActivity(
      id: json["id"],
      isicNumber: json["isicNumber"],
      name: json["name"],
      unit: json["unit"],
      unitDesc: json["unitDesc"],
      maxYears: json["maxYears"],
      minYears: json["minYears"],
      isLicenseOwnerFemaleOnly: json["isLicenseOwnerFemaleOnly"],
      isWorkerTypeFemaleOnly: json["isWorkerTypeFemaleOnly"],
      isTabacco: json["isTabacco"],
      fawry: json["fawry"],
      twentyFourHourStatus: json["twentyFourHourStatus"]);
}

Map<String, dynamic> _$DetailedActivityToJson(DetailedActivity instance) =>
    <String, dynamic>{
      "id": instance.id,
      "isicNumber": instance.isicNumber,
      "name": instance.name,
      "unit": instance.unit,
      "unitDesc": instance.unitDesc,
      "maxYears": instance.maxYears,
      "minYears": instance.minYears,
      "isLicenseOwnerFemaleOnly": instance.isLicenseOwnerFemaleOnly,
      "isWorkerTypeFemaleOnly": instance.isWorkerTypeFemaleOnly,
      "isTabacco": instance.isTabacco,
      "fawry": instance.fawry,
      "twentyFourHourStatus": instance.twentyFourHourStatus
    };
