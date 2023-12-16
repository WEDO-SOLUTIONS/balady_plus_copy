import 'package:equatable/equatable.dart';

class TripDetails extends Equatable {
  TripDetails({
    this.recordId,
    this.tripStepsInfoRecordId,
    this.deathInfoRecordId,
    this.currentTripStationTypeId,
    this.currentTripStationName,
    this.nextTripStationTypeId,
    this.nextTripStationId,
    this.currentTripStationArrivalTime,
    this.nextTripStationName,
    this.nextTripStationArrivalTime,
    this.nextTripStationLocationX,
    this.nextTripStationLocationY,
    this.createDateTime,
    this.completed,
  });

  final int? recordId;
  final int? tripStepsInfoRecordId;
  final int? deathInfoRecordId;
  final int? currentTripStationTypeId;
  final String? currentTripStationName;
  final int? nextTripStationId;
  final int? nextTripStationTypeId;
  final String? currentTripStationArrivalTime;
  final String? nextTripStationName;
  final String? nextTripStationArrivalTime;
  final String? nextTripStationLocationX;
  final String? nextTripStationLocationY;
  final String? createDateTime;
  final bool? completed;

  factory TripDetails.fromJson(Map<String, dynamic> json) => TripDetails(
        recordId: json["recordId"],
        tripStepsInfoRecordId: json["tripStepsInfoRecordId"],
        deathInfoRecordId: json["deathInfoRecordId"],
        currentTripStationTypeId: json["currentTripStationTypeId"],
        currentTripStationName: json["currentTripStationName"],
        nextTripStationId: json["nextTripStationId"],
        nextTripStationTypeId: json["nextTripStationTypeId"],
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

  (double lat, double lon)? getNextTripLocation() {
    if ((double.tryParse(nextTripStationLocationX ?? "") != null &&
        double.tryParse(nextTripStationLocationY ?? "") != null)) {
      return (
        double.parse(nextTripStationLocationY ?? ""),
        double.parse(nextTripStationLocationX ?? "")
      );
    }
  }

  @override
  List<Object?> get props => [
        recordId,
        tripStepsInfoRecordId,
        deathInfoRecordId,
        currentTripStationTypeId,
        currentTripStationName,
        nextTripStationTypeId,
        nextTripStationId,
        currentTripStationArrivalTime,
        nextTripStationName,
        nextTripStationLocationX,
        nextTripStationLocationY,
        createDateTime,
        completed
      ];
}
