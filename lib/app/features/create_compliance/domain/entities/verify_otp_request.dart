// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class VerifyOTPRequest {
  String mobileNumber;
  String tokenId;
  String token;

  VerifyOTPRequest(
      {required this.mobileNumber, required this.token, required this.tokenId});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'mobileNumber': mobileNumber,
      'tokenId': tokenId,
      'token': token,
    };
  }
}
