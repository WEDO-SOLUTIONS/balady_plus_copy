import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class VerifyOTPParams {
  String bodyRecipientIdNo;
  int bodyRecipientIdType;
  String deceasedIdentityId;
  int deceasedIdentityType;
  VerifyOTPParams({
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
