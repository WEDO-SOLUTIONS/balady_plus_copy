import 'package:equatable/equatable.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class TransportRequestItem extends Equatable {
  TransportRequestItem(
      {this.requestId,
      this.entryMode,
      this.deathCityName,
      this.burialCityName,
      this.deathTransferStatusId,
      this.deathTransferStatusDesc,
      this.deceasedName,
      this.requestDate,
      this.requestStatusId,
      this.deceasedTransportRequestStatusId,
      this.deceasedTransportRequestStatus,
      this.requestStatus,
      this.currentStationName,
      this.nextStationName,
      this.driverAssignDate,
      this.multipleCityRequest,
      this.relationship});

  final int? requestId;
  final int? entryMode;
  final String? deathCityName;
  final String? burialCityName;
  final int? deathTransferStatusId;
  final String? deathTransferStatusDesc;
  final String? deceasedName;
  final String? requestDate;
  final int? requestStatusId;
  final int? deceasedTransportRequestStatusId;
  final String? deceasedTransportRequestStatus;
  final String? requestStatus;
  final String? currentStationName;
  final String? nextStationName;
  final dynamic driverAssignDate;
  final bool? multipleCityRequest;
  final String? relationship;

  String getCityType() {
    return multipleCityRequest == true
        ? ("outside_city").tr()
        : ("inside_city").tr();
  }

  @override
  List<Object?> get props => [];
}
