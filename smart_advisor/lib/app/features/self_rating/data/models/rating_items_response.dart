class RatingItemsResponseModel {
  final List<RatingItemsResponseItem>? result;

  RatingItemsResponseModel({
    this.result,
  });

  RatingItemsResponseModel copyWith({
    List<RatingItemsResponseItem>? result,
  }) =>
      RatingItemsResponseModel(
        result: result ?? this.result,
      );

  factory RatingItemsResponseModel.fromJson(Map<String, dynamic> json) =>
      RatingItemsResponseModel(
        result: json["result"] == null
            ? []
            : List<RatingItemsResponseItem>.from(json["result"]!
                .map((x) => RatingItemsResponseItem.fromJson(x))),
      );
}

class RatingItemsResponseItem {
  final String? pxObjClass;
  final List<NonComplianceReasonList>? nonComplianceReasonList;
  final int? subClauseNo;
  final String? inspectionTypeNo;
  final String? subClauseName;
  final int? clauseNo;
  final String? clauseName;
  int? isClausesValidated;

  RatingItemsResponseItem(
      {this.pxObjClass,
      this.nonComplianceReasonList,
      this.subClauseNo,
      this.inspectionTypeNo,
      this.subClauseName,
      this.clauseNo,
      this.clauseName,
      this.isClausesValidated});

  RatingItemsResponseItem copyWith(
          {String? pxObjClass,
          List<NonComplianceReasonList>? nonComplianceReasonList,
          int? subClauseNo,
          String? inspectionTypeNo,
          String? subClauseName,
          int? clauseNo,
          String? clauseName,
          int? isClausesValidated}) =>
      RatingItemsResponseItem(
          pxObjClass: pxObjClass ?? this.pxObjClass,
          nonComplianceReasonList:
              nonComplianceReasonList ?? this.nonComplianceReasonList,
          subClauseNo: subClauseNo ?? this.subClauseNo,
          inspectionTypeNo: inspectionTypeNo ?? this.inspectionTypeNo,
          subClauseName: subClauseName ?? this.subClauseName,
          clauseNo: clauseNo ?? this.clauseNo,
          clauseName: clauseName ?? this.clauseName,
          isClausesValidated: isClausesValidated ?? this.isClausesValidated);

  factory RatingItemsResponseItem.fromJson(Map<String, dynamic> json) =>
      RatingItemsResponseItem(
        pxObjClass: json["pxObjClass"],
        nonComplianceReasonList: json["NonComplianceReasonList"] == null
            ? []
            : List<NonComplianceReasonList>.from(
                json["NonComplianceReasonList"]!
                    .map((x) => NonComplianceReasonList.fromJson(x))),
        subClauseNo: json["SubClauseNo"],
        inspectionTypeNo: json["InspectionTypeNo"],
        subClauseName: json["SubClauseName"],
        clauseNo: json["ClauseNo"],
        clauseName: json["ClauseName"],
      );
}

class NonComplianceReasonList {
  final String? pxObjClass;
  final int? reasonNo;
  final String? reasonDescription;

  NonComplianceReasonList({
    this.pxObjClass,
    this.reasonNo,
    this.reasonDescription,
  });

  NonComplianceReasonList copyWith({
    String? pxObjClass,
    int? reasonNo,
    String? reasonDescription,
  }) =>
      NonComplianceReasonList(
        pxObjClass: pxObjClass ?? this.pxObjClass,
        reasonNo: reasonNo ?? this.reasonNo,
        reasonDescription: reasonDescription ?? this.reasonDescription,
      );

  factory NonComplianceReasonList.fromJson(Map<String, dynamic> json) =>
      NonComplianceReasonList(
        pxObjClass: json["pxObjClass"],
        reasonNo: json["ReasonNo"],
        reasonDescription: json["ReasonDescription"],
      );

  Map<String, dynamic> toJson() => {
        "pxObjClass": pxObjClass,
        "ReasonNo": reasonNo,
        "ReasonDescription": reasonDescription,
      };
}
