import 'package:balady_plus/app/features/ekram/domain/entities/trip_details.dart';
import 'package:equatable/equatable.dart';

class TripDetailsModel extends TripDetails {
  TripDetailsModel({
    super.recordId,
    super.tripStepsInfoRecordId,
    super.deathInfoRecordId,
    super.currentTripStationTypeId,
    super.currentTripStationName,
    super.nextTripStationTypeId,
    super.nextTripStationId,
    super.currentTripStationArrivalTime,
    super.nextTripStationName,
    super.nextTripStationArrivalTime,
    super.nextTripStationLocationX,
    super.nextTripStationLocationY,
    super.createDateTime,
    super.completed,
  });

  factory TripDetailsModel.fromJson(Map<String, dynamic> json) =>
      TripDetailsModel(
        recordId: json["recordId"],
        tripStepsInfoRecordId: json["tripStepsInfoRecordId"],
        deathInfoRecordId: json["deathInfoRecordId"],
        currentTripStationTypeId: json["currentTripStationTypeId"],
        currentTripStationName: json["currentTripStationName"],
        nextTripStationTypeId: json["nextTripStationTypeId"],
        nextTripStationId: json["nextTripStationId"],
        currentTripStationArrivalTime: json["currentTripStationArrivalTime"],
        nextTripStationName: json["nextTripStationName"],
        nextTripStationArrivalTime: json["nextTripStationArrivalTime"],
        nextTripStationLocationX: json["nextTripStationLocationX"],
        nextTripStationLocationY: json["nextTripStationLocationY"],
        createDateTime: json["createDateTime"],
        completed: json["completed"],
      );

  Map<String, dynamic> toJson() => {
        "recordId": recordId,
        "tripStepsInfoRecordId": tripStepsInfoRecordId,
        "deathInfoRecordId": deathInfoRecordId,
        "currentTripStationTypeId": currentTripStationTypeId,
        "currentTripStationName": currentTripStationName,
        "nextTripStationTypeId": nextTripStationTypeId,
        "nextTripStationId": nextTripStationId,
        "currentTripStationArrivalTime": currentTripStationArrivalTime,
        "nextTripStationName": nextTripStationName,
        "nextTripStationArrivalTime": nextTripStationArrivalTime,
        "nextTripStationLocationX": nextTripStationLocationX,
        "nextTripStationLocationY": nextTripStationLocationY,
        "createDateTime": createDateTime,
        "completed": completed,
      };
}
