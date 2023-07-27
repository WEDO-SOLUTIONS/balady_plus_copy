class CostsInfo {
  String? costItemDescription;
  int? costItemTypeId;
  double? costItemValue;

  CostsInfo(
      {this.costItemDescription, this.costItemTypeId, this.costItemValue});

  factory CostsInfo.fromJson(Map<String, dynamic> json) =>
      _$CostsInfoFromJson(json);

  Map<String, dynamic> toJson() => _$CostsInfoToJson(this);
}

CostsInfo _$CostsInfoFromJson(Map<String, dynamic> json) {
  return CostsInfo(
    costItemDescription: json["CostItemDescription"],
    costItemTypeId: json["CostItemTypeId"],
    costItemValue: json["CostItemValue"],
  );
}

Map<String, dynamic> _$CostsInfoToJson(CostsInfo instance) => <String, dynamic>{
      "CostItemDescription": instance.costItemDescription,
      "CostItemTypeId": instance.costItemTypeId,
      "CostItemValue": instance.costItemValue
    };
