import 'package:json_annotation/json_annotation.dart';

part 'qr_trade_license.g.dart';

@JsonSerializable()
class StatusDetails {
  final int code;
  final String message;

  StatusDetails({required this.code, required this.message});

  factory StatusDetails.fromJson(Map<String, dynamic> json) => _$StatusDetailsFromJson(json);
}

@JsonSerializable()
class QrLicenseMessage {
  final int requestId;
  final String shopName;
  final String? mobile;
  final int parkingCount;
  final bool hasParking;
  final bool serveDisabledPersons;
  final bool hasVehicleParking;
  final bool hasDelivery;

  QrLicenseMessage({
    required this.requestId,
    required this.shopName,
    required this.mobile,
    required this.parkingCount,
    required this.hasParking,
    required this.serveDisabledPersons,
    required this.hasVehicleParking,
    required this.hasDelivery,
  });

  Map<String, dynamic> toJson() => _$QrLicenseMessageToJson(this);

  factory QrLicenseMessage.fromJson(Map<String, dynamic> json) => _$QrLicenseMessageFromJson(json);
}
