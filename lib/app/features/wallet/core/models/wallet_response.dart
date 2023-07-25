// To parse this JSON data, do
//
//     final walletResponse = walletResponseFromJson(jsonString);

import 'dart:convert';

import 'package:balady_plus/app/features/wallet/core/models/wallet_item.dart';

WalletResponse walletResponseFromJson(String str) =>
    WalletResponse.fromJson(json.decode(str));

class WalletResponse {
  WalletResponse({
    this.statusDetails,
    this.data,
  });

  StatusDetails? statusDetails;
  Data? data;

  factory WalletResponse.fromJson(Map<String, dynamic> json) => WalletResponse(
        statusDetails: json["statusDetails"] != null
            ? StatusDetails.fromJson(json["statusDetails"])
            : null,
        data: json["data"] != null ? Data.fromJson(json["data"]) : null,
      );
}

class Data {
  Data({
    this.responseCode,
    this.responseMessage,
    this.result,
  });

  String? responseCode;
  String? responseMessage;
  List<WalletItem>? result;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        responseCode: json["responseCode"],
        responseMessage: json["responseMessage"],
        result: json["result"] != null
            ? List<WalletItem>.from(
                json["result"].map((x) => WalletItem.fromJson(x)))
            : null,
      );
}

class StatusDetails {
  StatusDetails({
    this.code,
    this.message,
  });

  dynamic code;
  String? message;

  factory StatusDetails.fromJson(Map<String, dynamic> json) => StatusDetails(
        code: json["code"],
        message: json["message"],
      );
}
