// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'cr_step10_addetional_data_cubit.dart';

class CRStep10AddetionalState extends Equatable {
  final BlocStatus status;
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
  final String? errorMessage;

  const CRStep10AddetionalState(
      {this.status = BlocStatus.initial,
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
      this.errorMessage});

  @override
  List<Object?> get props {
    return [
      status,
      electAccountNumber,
      hasDelivery,
      hasElectronicSale,
      hasParking,
      hasVehicleParking,
      parkingCount,
      serveDisabledPersons,
      siteDeliveryName,
      siteDeliveryType,
      thereIsOuterInvestablePlace,
      waterAccountNumber,
      errorMessage
    ];
  }

  CRStep10AddetionalState copyWith(
      {BlocStatus? status,
      String? electAccountNumber,
      String? hasDelivery,
      String? hasElectronicSale,
      bool? hasParking,
      String? hasVehicleParking,
      Nullable<int?>? parkingCount,
      bool? serveDisabledPersons,
      String? siteDeliveryName,
      Nullable<String?>? siteDeliveryType,
      bool? thereIsOuterInvestablePlace,
      String? waterAccountNumber,
      String? errorMessage}) {
    return CRStep10AddetionalState(
        status: status ?? this.status,
        electAccountNumber: electAccountNumber ?? this.electAccountNumber,
        hasDelivery: hasDelivery ?? this.hasDelivery,
        hasElectronicSale: hasElectronicSale ?? this.hasElectronicSale,
        hasParking: hasParking ?? this.hasParking,
        hasVehicleParking: hasVehicleParking ?? this.hasVehicleParking,
        parkingCount:
            parkingCount == null ? this.parkingCount : parkingCount.value,
        serveDisabledPersons: serveDisabledPersons ?? this.serveDisabledPersons,
        siteDeliveryName: siteDeliveryName ?? this.siteDeliveryName,
        siteDeliveryType: siteDeliveryType == null
            ? this.siteDeliveryType
            : siteDeliveryType.value,
        thereIsOuterInvestablePlace:
            thereIsOuterInvestablePlace ?? this.thereIsOuterInvestablePlace,
        waterAccountNumber: waterAccountNumber ?? this.waterAccountNumber,
        errorMessage: errorMessage ?? this.errorMessage);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'electAccountNumber': electAccountNumber,
      'hasDelivery': hasDelivery,
      'hasElectronicSale': hasElectronicSale,
      'hasParking': hasParking,
      'hasVehicleParking': hasVehicleParking,
      'parkingCount': parkingCount,
      'serveDisabledPersons': serveDisabledPersons,
      'siteDeliveryName': siteDeliveryName,
      'siteDeliveryType': siteDeliveryType,
      'thereIsOuterInvestablePlace': thereIsOuterInvestablePlace,
      'waterAccountNumber': waterAccountNumber,
    };
  }
}
