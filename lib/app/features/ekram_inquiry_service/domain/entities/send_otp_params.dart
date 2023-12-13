class SendOTPParams {
  String bodyRecipientIdNo;
  int bodyRecipientIdType;
  String deceasedIdentityId;
  int deceasedIdentityType;
  SendOTPParams({
    required this.bodyRecipientIdNo,
    required this.bodyRecipientIdType,
    required this.deceasedIdentityId,
    required this.deceasedIdentityType,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'bodyRecipientIdNo': bodyRecipientIdNo,
      'bodyRecipientIdType': bodyRecipientIdType,
      'deceasedIdentityId': deceasedIdentityId,
      'deceasedIdentityType': deceasedIdentityType,
    };
  }
}
