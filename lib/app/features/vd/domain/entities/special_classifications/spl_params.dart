class SplParams {
  String categoryID;
  String? municipalityID;

  SplParams({required this.categoryID, this.municipalityID});

  SplParams copyWith({String? categoryID, String? municipalityID}) {
    return SplParams(
        categoryID: categoryID ?? this.categoryID,
        municipalityID: municipalityID ?? this.municipalityID);
  }

  Map<String, dynamic> toMap() {
    return {
      "CategoryID": categoryID,
      "municipalityID": municipalityID,
    };
  }
}
