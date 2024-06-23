class UserInfoRequestParams {
  String nationalId;
  String dob;

  UserInfoRequestParams({required this.dob, required this.nationalId});

  Map<String, dynamic> toMap() =>
      {"idNumber": nationalId, "birthDate": dob.replaceAll("/", "-")};
}
