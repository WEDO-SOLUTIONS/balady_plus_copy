class AdditionalQrDataRequestModel {
  final int? requestId;
  final String? electAccountNumber;
  final String? hasDelivery;
  final String? hasElectronicSale;
  final bool? hasParking;
  final String? hasVehicleParking;
  final int? parkingCount;
  final bool? serveDisabledPersons;
  final String? siteDeliveryName;
  final String? siteDeliveryType;
  final bool? thereIsOuterInvestablePlace;
  final String? waterAccountNumber;

  AdditionalQrDataRequestModel({
    this.requestId,
    this.electAccountNumber,
    this.hasDelivery,
    this.hasElectronicSale,
    this.hasParking,
    this.hasVehicleParking,
    this.parkingCount,
    this.serveDisabledPersons,
    this.siteDeliveryName,
    this.siteDeliveryType,
    this.thereIsOuterInvestablePlace,
    this.waterAccountNumber,
  });

  factory AdditionalQrDataRequestModel.fromJson(Map<String, dynamic> json) =>
      AdditionalQrDataRequestModel(
        electAccountNumber: json["electAccountNumber"],
        hasDelivery: json["hasDelivery"],
        hasElectronicSale: json["hasElectronicSale"],
        hasParking: json["hasParking"],
        hasVehicleParking: json["hasVehicleParking"],
        parkingCount: json["parkingCount"],
        serveDisabledPersons: json["serveDisabledPersons"],
        siteDeliveryName: json["siteDeliveryName"],
        siteDeliveryType: json["siteDeliveryType"],
        thereIsOuterInvestablePlace: json["thereIsOuterInvestablePlace"],
        waterAccountNumber: json["waterAccountNumber"],
      );

  Map<String, dynamic> toJson() => {
        "electAccountNumber": electAccountNumber,
        "hasDelivery": hasDelivery,
        "hasElectronicSale": hasElectronicSale,
        "hasParking": hasParking,
        "hasVehicleParking": hasVehicleParking,
        "parkingCount": parkingCount,
        "serveDisabledPersons": serveDisabledPersons,
        "siteDeliveryName": siteDeliveryName,
        "siteDeliveryType": siteDeliveryType,
        "thereIsOuterInvestablePlace": thereIsOuterInvestablePlace,
        "waterAccountNumber": waterAccountNumber,
      };
}
