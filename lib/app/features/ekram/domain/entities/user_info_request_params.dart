class UserInfoRequestParams {
  String nationalId;
  String dob;
  int identityType;

  UserInfoRequestParams(
      {required this.dob,
      required this.nationalId,
      required this.identityType});

  Map<String, dynamic> toMap() => {
        "identityNumber": nationalId,
        "identityType": identityType,
        "birthDate": dob
      };
}
