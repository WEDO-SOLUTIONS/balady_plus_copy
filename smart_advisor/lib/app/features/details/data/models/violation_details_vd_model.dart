import 'entity_violation_activity_model.dart' as d;

class ViolationDetailsVdModel {
  final String? isCorrectionNeeded;
  final String? description;
  final int? linkSubClauseNo;
  final String? fileName;
  final String? attachmentCategory;
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
  final String? contentLocation;
  final String? correctionPeriod;
  final int? regulationId;
  final int? objectionPeriod;
  final String? linkId;

  ViolationDetailsVdModel({
    this.isCorrectionNeeded,
    this.description,
    this.linkSubClauseNo,
    this.fileName,
    this.attachmentCategory,
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
    this.contentLocation,
    this.correctionPeriod,
    this.regulationId,
    this.objectionPeriod,
    this.linkId,
  });

  ViolationDetailsVdModel copyWith({
    String? isCorrectionNeeded,
    String? description,
    int? linkSubClauseNo,
    String? fileName,
    String? attachmentCategory,
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
    String? contentLocation,
    String? correctionPeriod,
    int? regulationId,
    int? objectionPeriod,
    String? linkId,
  }) =>
      ViolationDetailsVdModel(
        isCorrectionNeeded: isCorrectionNeeded ?? this.isCorrectionNeeded,
        description: description ?? this.description,
        linkSubClauseNo: linkSubClauseNo ?? this.linkSubClauseNo,
        fileName: fileName ?? this.fileName,
        attachmentCategory: attachmentCategory ?? this.attachmentCategory,
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
        contentLocation: contentLocation ?? this.contentLocation,
        correctionPeriod: correctionPeriod ?? this.correctionPeriod,
        regulationId: regulationId ?? this.regulationId,
        objectionPeriod: objectionPeriod ?? this.objectionPeriod,
        linkId: linkId ?? this.linkId,
      );

  factory ViolationDetailsVdModel.fromJson(Map<String, dynamic> json) =>
      ViolationDetailsVdModel(
        isCorrectionNeeded: json["IsCorrectionNeeded"],
        description: json["Description"],
        linkSubClauseNo: json["Link_SubClauseNo"],
        fileName: json["FileName"],
        attachmentCategory: json["AttachmentCategory"],
        parentGroup: json["ParentGroup"],
        regulationName: json["RegulationName"],
        isCritical: json["IsCritical"],
        linkClauseNo: json["Link_ClauseNo"],
        clauseName: json["ClauseName"],
        fineAmount: json["FineAmount"] ?? 0,
        violatorList: json["ViolatorList"] == null
            ? []
            : List<ViolatorList>.from(
                json["ViolatorList"]!.map((x) => ViolatorList.fromJson(x))),
        objectionApplicable: json["ObjectionApplicable"],
        isDoubledOnRepeating: json["IsDoubledOnRepeating"],
        unitType: json["UnitType"],
        subClauseName: json["SubClauseName"],
        contentLocation: json["ContentLocation"],
        correctionPeriod: json["CorrectionPeriod"],
        regulationId: json["RegulationID"],
        objectionPeriod: json["ObjectionPeriod"],
        linkId: json["LinkID"],
      );

  d.EntityViolationActivityModel toViolationModel() {
    return d.EntityViolationActivityModel(
        description: description,
        unitType: unitType,
        regulationId: regulationId,
        parentGroup: parentGroup,
        regulationName: regulationName,
        isCritical: isCritical,
        linkId: linkId,
        fineAmount: fineAmount,
        violatorList: violatorList
                ?.map((e) => d.ViolatorList(
                    violatorIdType: e.violatorIdType,
                    violatorIdNumber: e.violatorIdNumber))
                .toList() ??
            []);
  }
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
}
