class CitizenInfoParams {
  String id;
  String birthdate;

  CitizenInfoParams({required this.id, required this.birthdate});

  Map<String, dynamic> toMap() {
    return {
      "idNumber": id,
      "birthDate": birthdate,
    };
  }
}
