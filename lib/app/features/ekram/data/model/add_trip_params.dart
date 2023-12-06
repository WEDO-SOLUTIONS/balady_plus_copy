import 'package:equatable/equatable.dart';

class AddTripParams extends Equatable {
  final String? currentTripStationArrivalTime;
  final int? currentTripStationId;
  final double? currentTripStationLocationX;
  final double? currentTripStationLocationY;
  final String? currentTripStationName;
  final int? currentTripStationTypeId;
  final String? nextTripStationArrivalTime;
  int? nextTripStationId;
  double? nextTripStationLocationX;
  double? nextTripStationLocationY;
  String? nextTripStationName;
  final int? nextTripStationTypeId;
  final int? requestProcessId;

  AddTripParams(
      {this.currentTripStationArrivalTime,
      this.currentTripStationId,
      this.currentTripStationLocationX,
      this.currentTripStationLocationY,
      this.currentTripStationName,
      this.currentTripStationTypeId,
      this.nextTripStationArrivalTime,
      this.nextTripStationId,
      this.nextTripStationLocationX,
      this.nextTripStationLocationY,
      this.nextTripStationName,
      this.nextTripStationTypeId,
      this.requestProcessId});

  Map<String, dynamic> toMap() => {
        "currentTripStationArrivalTime": currentTripStationArrivalTime,
        "currentTripStationId": currentTripStationId,
        "currentTripStationLocationX": currentTripStationLocationX,
        "currentTripStationLocationY": currentTripStationLocationY,
        "currentTripStationName": currentTripStationName,
        "currentTripStationTypeId": currentTripStationTypeId,
        "nextTripStationArrivalTime": nextTripStationArrivalTime,
        "nextTripStationId": nextTripStationId,
        "nextTripStationLocationX": nextTripStationLocationX,
        "nextTripStationLocationY": nextTripStationLocationY,
        "nextTripStationName": nextTripStationName,
        "nextTripStationTypeId": nextTripStationTypeId,
        "requestProcessId": requestProcessId,
      };

  @override
  List<Object?> get props => [];
}
