import 'package:balady_plus/app/features/ekram/domain/entities/trip_details.dart';

import '../../data/model/driver/trip_details_model.dart';
import 'deceased_request_details/deceased_request_details.dart';

class AddTripParameter {
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
  final List<TripDetailsModel>? trips;

  AddTripParameter(
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
