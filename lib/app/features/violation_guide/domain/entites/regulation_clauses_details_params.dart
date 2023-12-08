class RegulationClauseDetailsParams {
  String? regulationClauseID;
  String? noofRepetition;
  String? classificationID;
  String? establishmentSizeID;
  RegulationClauseDetailsParams(
      {this.regulationClauseID,
      this.noofRepetition,
      this.classificationID,
      this.establishmentSizeID});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'ClassificationID': classificationID,
      if (establishmentSizeID != null)
        "EstablishmentSizeID": establishmentSizeID,
      'NoofRepetition': noofRepetition ?? 1,
      'RegulationClauseID': regulationClauseID,
    };
  }
}
