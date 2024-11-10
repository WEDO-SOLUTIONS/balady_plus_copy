class MosqueGhuslPlacesParams {
  String? burialDate;
  String? gender;

  MosqueGhuslPlacesParams({required this.burialDate,required this.gender});

  Map<String, dynamic> toJson() => {
        'burialDate': burialDate,
        'gender': gender,
      };
}
