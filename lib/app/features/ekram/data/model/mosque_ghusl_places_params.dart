class MosqueGhuslPlacesParams {
  String? burialDate;
  String? gender;

  MosqueGhuslPlacesParams({this.burialDate, this.gender});

  Map<String, dynamic> toJson() => {
        'burialDate': burialDate,
        'gender': gender,
      };
}
