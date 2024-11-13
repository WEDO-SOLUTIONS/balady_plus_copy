class EntityViolationActivityModel {
  final String? description;
  final String? unitType;
  final int? regulationId;
  final String? parentGroup;
  final String? regulationName;
  final String? isCritical;
  final String? linkId;
  final int? fineAmount;
  final List<ViolatorList>? violatorList;

  EntityViolationActivityModel({
    this.description,
    this.unitType,
    this.regulationId,
    this.parentGroup,
    this.regulationName,
    this.isCritical,
    this.linkId,
    this.fineAmount,
    this.violatorList,
  });

  EntityViolationActivityModel copyWith({
    String? description,
    String? unitType,
    int? regulationId,
    String? parentGroup,
    String? regulationName,
    String? isCritical,
    String? linkId,
    int? fineAmount,
    List<ViolatorList>? violatorList,
  }) =>
      EntityViolationActivityModel(
        description: description ?? this.description,
        unitType: unitType ?? this.unitType,
        regulationId: regulationId ?? this.regulationId,
        parentGroup: parentGroup ?? this.parentGroup,
        regulationName: regulationName ?? this.regulationName,
        isCritical: isCritical ?? this.isCritical,
        linkId: linkId ?? this.linkId,
        fineAmount: fineAmount ?? this.fineAmount,
        violatorList: violatorList ?? this.violatorList,
      );

  factory EntityViolationActivityModel.fromJson(Map<String, dynamic> json) =>
      EntityViolationActivityModel(
        description: json["Description"],
        unitType: json["UnitType"],
        regulationId: json["RegulationID"],
        parentGroup: json["ParentGroup"],
        regulationName: json["RegulationName"],
        isCritical: json["IsCritical"],
        linkId: json["LinkID"],
        fineAmount: json["FineAmount"] ?? 0,
        violatorList: json["ViolatorList"] == null
            ? []
            : List<ViolatorList>.from(
                json["ViolatorList"]!.map((x) => ViolatorList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Description": description,
        "UnitType": unitType,
        "RegulationID": regulationId,
        "ParentGroup": parentGroup,
        "RegulationName": regulationName,
        "IsCritical": isCritical,
        "LinkID": linkId,
        "FineAmount": fineAmount,
        "ViolatorList": violatorList == null
            ? []
            : List<dynamic>.from(violatorList!.map((x) => x.toJson())),
      };
}

class ViolatorList {
  final String? violatorIdType;
  final String? violatorIdNumber;

  ViolatorList({
    this.violatorIdType,
    this.violatorIdNumber,
  });

  ViolatorList copyWith({
    String? violatorIdType,
    String? violatorIdNumber,
  }) =>
      ViolatorList(
        violatorIdType: violatorIdType ?? this.violatorIdType,
        violatorIdNumber: violatorIdNumber ?? this.violatorIdNumber,
      );

  factory ViolatorList.fromJson(Map<String, dynamic> json) => ViolatorList(
        violatorIdType: json["ViolatorIDType"],
        violatorIdNumber: json["ViolatorIDNumber"],
      );

  Map<String, dynamic> toJson() => {
        "ViolatorIDType": violatorIdType,
        "ViolatorIDNumber": violatorIdNumber,
      };
}
