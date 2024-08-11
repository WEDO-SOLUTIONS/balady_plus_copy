class EventSuperProperties {
  final int customerId;
  final int pharmacyId;
  final String pharmacyName;
  final String customerPhone;
  final String deviceType;
  final String profileCreatedAt;

  EventSuperProperties({
    required this.customerId,
    required this.pharmacyId,
    required this.pharmacyName,
    required this.customerPhone,
    required this.deviceType,
    required this.profileCreatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      "customerId": customerId,
      "pharmacyId": pharmacyId,
      "pharmacyName": pharmacyName,
      "customerPhone": customerPhone,
      "deviceType": deviceType,
      "profileCreatedAt": profileCreatedAt,
    };
  }
}
