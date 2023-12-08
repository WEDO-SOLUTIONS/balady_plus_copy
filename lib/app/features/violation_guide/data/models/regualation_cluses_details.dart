class RegulationClauseDetails {
  final bool? isCorrectionNeeded;
  final List<ListofPenality>? listofPenalities;
  final bool? isDoubledOnRepeating;
  final String? totalFineAmount;
  final int? correctionPeriod;

  RegulationClauseDetails({
    this.isCorrectionNeeded,
    this.listofPenalities,
    this.isDoubledOnRepeating,
    this.totalFineAmount,
    this.correctionPeriod,
  });

  factory RegulationClauseDetails.fromJson(Map<String, dynamic> json) =>
      RegulationClauseDetails(
        isCorrectionNeeded: json["IsCorrectionNeeded"],
        listofPenalities: json["ListofPenalities"] == null
            ? []
            : List<ListofPenality>.from(json["ListofPenalities"]!
                .map((x) => ListofPenality.fromJson(x))),
        isDoubledOnRepeating: json["IsDoubledOnRepeating"],
        totalFineAmount: json["TotalFineAmount"],
        correctionPeriod: json["CorrectionPeriod"],
      );

  Map<String, dynamic> toJson() => {
        "IsCorrectionNeeded": isCorrectionNeeded,
        "ListofPenalities": listofPenalities == null
            ? []
            : List<dynamic>.from(listofPenalities!.map((x) => x.toJson())),
        "IsDoubledOnRepeating": isDoubledOnRepeating,
        "TotalFineAmount": totalFineAmount,
        "CorrectionPeriod": correctionPeriod,
      };
}

class ListofPenality {
  final String? suspensionOfPenalityTrigger;
  final int? penalityPeriod;
  final String? penalityTypeCode;
  final String? penalityName;
  final String? penalityType;

  ListofPenality({
    this.suspensionOfPenalityTrigger,
    this.penalityPeriod,
    this.penalityTypeCode,
    this.penalityName,
    this.penalityType,
  });

  factory ListofPenality.fromJson(Map<String, dynamic> json) => ListofPenality(
        suspensionOfPenalityTrigger: json["SuspensionOfPenalityTrigger"],
        penalityPeriod: json["PenalityPeriod"],
        penalityTypeCode: json["PenalityTypeCode"],
        penalityName: json["PenalityName"],
        penalityType: json["PenalityType"],
      );

  Map<String, dynamic> toJson() => {
        "SuspensionOfPenalityTrigger": suspensionOfPenalityTrigger,
        "PenalityPeriod": penalityPeriod,
        "PenalityTypeCode": penalityTypeCode,
        "PenalityName": penalityName,
        "PenalityType": penalityType,
      };
}
