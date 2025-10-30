class EntityViolationActivityDetailsModel {
  final String? isCorrectionNeeded;
  final String? description;
  final int? linkSubClauseNo;
  final String? parentGroup;
  final String? regulationName;
  final String? isCritical;
  final int? linkClauseNo;
  final String? clauseName;
  final int? fineAmount;
  final List<ViolatorList>? violatorList;
  final bool? objectionApplicable;
  final bool? isDoubledOnRepeating;
  final String? unitType;
  final String? subClauseName;
  final String? totalFineAmount;
  final String? correctionPeriod;
  final int? regulationId;
  final int? objectionPeriod;
  final String? linkId;

  EntityViolationActivityDetailsModel({
    this.isCorrectionNeeded,
    this.description,
    this.linkSubClauseNo,
    this.parentGroup,
    this.regulationName,
    this.isCritical,
    this.linkClauseNo,
    this.clauseName,
    this.fineAmount,
    this.violatorList,
    this.objectionApplicable,
    this.isDoubledOnRepeating,
    this.unitType,
    this.subClauseName,
    this.totalFineAmount,
    this.correctionPeriod,
    this.regulationId,
    this.objectionPeriod,
    this.linkId,
  });

  EntityViolationActivityDetailsModel copyWith({
    String? isCorrectionNeeded,
    String? description,
    int? linkSubClauseNo,
    String? parentGroup,
    String? regulationName,
    String? isCritical,
    int? linkClauseNo,
    String? clauseName,
    int? fineAmount,
    List<ViolatorList>? violatorList,
    bool? objectionApplicable,
    bool? isDoubledOnRepeating,
    String? unitType,
    String? subClauseName,
    String? totalFineAmount,
    String? correctionPeriod,
    int? regulationId,
    int? objectionPeriod,
    String? linkId,
  }) =>
      EntityViolationActivityDetailsModel(
        isCorrectionNeeded: isCorrectionNeeded ?? this.isCorrectionNeeded,
        description: description ?? this.description,
        linkSubClauseNo: linkSubClauseNo ?? this.linkSubClauseNo,
        parentGroup: parentGroup ?? this.parentGroup,
        regulationName: regulationName ?? this.regulationName,
        isCritical: isCritical ?? this.isCritical,
        linkClauseNo: linkClauseNo ?? this.linkClauseNo,
        clauseName: clauseName ?? this.clauseName,
        fineAmount: fineAmount ?? this.fineAmount,
        violatorList: violatorList ?? this.violatorList,
        objectionApplicable: objectionApplicable ?? this.objectionApplicable,
        isDoubledOnRepeating: isDoubledOnRepeating ?? this.isDoubledOnRepeating,
        unitType: unitType ?? this.unitType,
        subClauseName: subClauseName ?? this.subClauseName,
        totalFineAmount: totalFineAmount ?? this.totalFineAmount,
        correctionPeriod: correctionPeriod ?? this.correctionPeriod,
        regulationId: regulationId ?? this.regulationId,
        objectionPeriod: objectionPeriod ?? this.objectionPeriod,
        linkId: linkId ?? this.linkId,
      );

  factory EntityViolationActivityDetailsModel.fromJson(
          Map<String, dynamic> json) =>
      EntityViolationActivityDetailsModel(
        isCorrectionNeeded: json["IsCorrectionNeeded"],
        description: json["Description"],
        linkSubClauseNo: json["Link_SubClauseNo"],
        parentGroup: json["ParentGroup"],
        regulationName: json["RegulationName"],
        isCritical: json["IsCritical"],
        linkClauseNo: json["Link_ClauseNo"],
        clauseName: json["ClauseName"],
        fineAmount: json["FineAmount"],
        violatorList: json["ViolatorList"] == null
            ? []
            : List<ViolatorList>.from(
                json["ViolatorList"]!.map((x) => ViolatorList.fromJson(x))),
        objectionApplicable: json["ObjectionApplicable"],
        isDoubledOnRepeating: json["IsDoubledOnRepeating"],
        unitType: json["UnitType"],
        subClauseName: json["SubClauseName"],
        totalFineAmount: json["TotalFineAmount"],
        correctionPeriod: json["CorrectionPeriod"],
        regulationId: json["RegulationID"],
        objectionPeriod: json["ObjectionPeriod"],
        linkId: json["LinkID"],
      );

  Map<String, dynamic> toJson() => {
        "IsCorrectionNeeded": isCorrectionNeeded,
        "Description": description,
        "Link_SubClauseNo": linkSubClauseNo,
        "ParentGroup": parentGroup,
        "RegulationName": regulationName,
        "IsCritical": isCritical,
        "Link_ClauseNo": linkClauseNo,
        "ClauseName": clauseName,
        "FineAmount": fineAmount,
        "ViolatorList": violatorList == null
            ? []
            : List<dynamic>.from(violatorList!.map((x) => x.toJson())),
        "ObjectionApplicable": objectionApplicable,
        "IsDoubledOnRepeating": isDoubledOnRepeating,
        "UnitType": unitType,
        "SubClauseName": subClauseName,
        "TotalFineAmount": totalFineAmount,
        "CorrectionPeriod": correctionPeriod,
        "RegulationID": regulationId,
        "ObjectionPeriod": objectionPeriod,
        "LinkID": linkId,
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
