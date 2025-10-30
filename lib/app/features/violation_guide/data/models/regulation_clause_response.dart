class RegulationClausesResponse {
  final List<RegulationClauseItem>? result;

  RegulationClausesResponse({
    this.result,
  });

  factory RegulationClausesResponse.fromJson(Map<String, dynamic> json) =>
      RegulationClausesResponse(
        result: json["result"] == null
            ? []
            : List<RegulationClauseItem>.from(
                json["result"]!.map((x) => RegulationClauseItem.fromJson(x))),
      );
}

class RegulationClauseItem {
  final String? regulationClauseId;
  final String? parentClauseId;
  final String? baseFineAmount;
  final String? regulationClauseText;
  final bool? showUnitType;
  final String? unit;
  final bool? isCritical;

  RegulationClauseItem({
    this.regulationClauseId,
    this.parentClauseId,
    this.baseFineAmount,
    this.regulationClauseText,
    this.showUnitType,
    this.unit,
    this.isCritical,
  });

  factory RegulationClauseItem.fromJson(Map<String, dynamic> json) =>
      RegulationClauseItem(
        regulationClauseId: json["RegulationClauseID"],
        parentClauseId: json["ParentClauseID"],
        baseFineAmount: json["BaseFineAmount"],
        regulationClauseText: json["RegulationClauseText"],
        showUnitType: json["ShowUnitType"],
        unit: json["Unit"],
        isCritical: json["IsCritical"],
      );
}
