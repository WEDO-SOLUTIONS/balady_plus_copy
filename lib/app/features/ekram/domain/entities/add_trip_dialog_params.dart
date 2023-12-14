import 'deceased_request_details/deceased_request_details.dart';

class AddTripDialogParams {
  final int? deathInfoId;
  final String? currentTripStationArrivalTime;
  final int? currentTripStationId;
  final double? currentTripStationLocationX;
  final double? currentTripStationLocationY;
  final String? currentTripStationName;
  final int? currentTripStationTypeId;
  final int? deathCityId;
  final int? cemetryId;
  final String? cemetryName;
  final List<Trip>? trips;

  AddTripDialogParams(
      {this.deathInfoId,
      this.currentTripStationArrivalTime,
      this.currentTripStationId,
      this.currentTripStationLocationX,
      this.currentTripStationLocationY,
      this.currentTripStationName,
      this.currentTripStationTypeId,
      this.deathCityId,
      this.cemetryId,
      this.cemetryName,
      this.trips});
}
