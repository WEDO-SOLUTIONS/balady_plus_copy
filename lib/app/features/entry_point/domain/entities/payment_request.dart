// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PaymentRequest {
  String accountNumber;
  String requestId;

  PaymentRequest({required this.accountNumber, required this.requestId});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'accountNumber': accountNumber,
      'requestId': requestId,
    };
  }
}
