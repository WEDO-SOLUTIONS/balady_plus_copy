// To parse this JSON data, do
//
//     final qrSubmitResponse = qrSubmitResponseFromJson(jsonString);

import 'dart:convert';

class QrSubmitResponse {
  final int? commercialLicenseId;
  final int? commercialRequestId;
  final int? commercialRequestTypeId;
  final List<String>? instructions;
  final String? message;
  final String? payUrl;
  final String? printUrl;
  final String? qrCodeImageUrl;
  final String? qrFlow;
  final bool? redirectToCommercialFlow;
  final bool? redirectToPay;
  final int? requestId;
  final List<String>? warningMessages;

  QrSubmitResponse({
    this.commercialLicenseId,
    this.commercialRequestId,
    this.commercialRequestTypeId,
    this.instructions,
    this.message,
    this.payUrl,
    this.printUrl,
    this.qrCodeImageUrl,
    this.qrFlow,
    this.redirectToCommercialFlow,
    this.redirectToPay,
    this.requestId,
    this.warningMessages,
  });

  factory QrSubmitResponse.fromJson(Map<String, dynamic> json) =>
      QrSubmitResponse(
        commercialLicenseId: json["commercialLicenseId"],
        commercialRequestId: json["commercialRequestId"],
        commercialRequestTypeId: json["commercialRequestTypeId"],
        instructions: json["instructions"] == null
            ? []
            : List<String>.from(json["instructions"]!.map((x) => x)),
        message: json["message"],
        payUrl: json["payUrl"],
        printUrl: json["printUrl"],
        qrCodeImageUrl: json["qrCodeImageUrl"],
        qrFlow: json["qrFlow"],
        redirectToCommercialFlow: json["redirectToCommercialFlow"],
        redirectToPay: json["redirectToPay"],
        requestId: json["requestId"],
        warningMessages: json["warningMessages"] == null
            ? []
            : List<String>.from(json["warningMessages"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "commercialLicenseId": commercialLicenseId,
        "commercialRequestId": commercialRequestId,
        "commercialRequestTypeId": commercialRequestTypeId,
        "instructions": instructions == null
            ? []
            : List<dynamic>.from(instructions!.map((x) => x)),
        "message": message,
        "payUrl": payUrl,
        "printUrl": printUrl,
        "qrCodeImageUrl": qrCodeImageUrl,
        "qrFlow": qrFlow,
        "redirectToCommercialFlow": redirectToCommercialFlow,
        "redirectToPay": redirectToPay,
        "requestId": requestId,
        "warningMessages": warningMessages == null
            ? []
            : List<dynamic>.from(warningMessages!.map((x) => x)),
      };
}
