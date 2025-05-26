class VerifyDeceasedParams {
  String identityNumber;
  int identityType;
  String birthDate;
  String submitterBirthDate;
  String submitterMobile;
  VerifyDeceasedParams({
    required this.identityNumber,
    required this.identityType,
    required this.birthDate,
    required this.submitterBirthDate,
    required this.submitterMobile,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'identityNumber': identityNumber,
      'identityType': identityType,
      'birthDate': birthDate,
      'submitterBirthDate': submitterBirthDate,
      'submitterMobile': submitterMobile,
    };
  }
}
