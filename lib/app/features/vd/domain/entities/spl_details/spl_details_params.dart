class SPLDetailsParams {
  String splID;
  String municipalityID;

  SPLDetailsParams({required this.municipalityID, required this.splID});

  Map<String, dynamic> toMap() {
    return {
      "SPLID": splID,
      "municipalityID": municipalityID,
    };
  }
}
