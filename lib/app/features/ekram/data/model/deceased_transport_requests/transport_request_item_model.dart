import 'package:balady_plus/app/features/ekram/domain/entities/deceased_transport_requests/transport_request_item.dart';

class TransportRequestItemModel extends TransportRequestItem {
  TransportRequestItemModel(
      {super.requestId,
      super.entryMode,
      super.deathCityName,
      super.burialCityName,
      super.deathTransferStatusId,
      super.deathTransferStatusDesc,
      super.deceasedName,
      super.requestDate,
      super.requestStatusId,
      super.deceasedTransportRequestStatusId,
      super.deceasedTransportRequestStatus,
      super.requestStatus,
      super.currentStationName,
      super.nextStationName,
      super.driverAssignDate,
      super.multipleCityRequest,
      super.relationship});

  factory TransportRequestItemModel.fromJson(Map<String, dynamic> json) =>
      TransportRequestItemModel(
          requestId: json["requestId"],
          entryMode: json["entryMode"],
          deathCityName: json["deathCityName"],
          burialCityName: json["burialCityName"],
          deathTransferStatusId: json["deathTransferStatusId"],
          deathTransferStatusDesc: json["deathTransferStatusDesc"],
          deceasedName: json["deceasedName"],
          requestDate: json["requestDate"],
          requestStatusId: json["requestStatusId"],
          deceasedTransportRequestStatusId:
              json["deceasedTransportRequestStatusId"],
          deceasedTransportRequestStatus:
              json["deceasedTransportRequestStatus"],
          requestStatus: json["requestStatus"],
          currentStationName: json["currentStationName"],
          nextStationName: json["nextStationName"],
          driverAssignDate: json["driverAssignDate"],
          multipleCityRequest: json["multipleCityRequest"],
          relationship: json["relationship"]);
}
