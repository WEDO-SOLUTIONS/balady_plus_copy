part of 'add_trip_bloc.dart';

class AddTripState extends Equatable {
  final BlocStatus status;
  final String? errorMessage;

  // final String? currentTripStationArrivalTime;
  // final int? currentTripStationId;
  // final double? currentTripStationLocationX;
  // final double? currentTripStationLocationY;
  // final String? currentTripStationName;
  // final int? currentTripStationTypeId;
  //
  // final String? nextTripStationArrivalTime;
  // final int? nextTripStationId;
  // final double? nextTripStationLocationX;
  // final double? nextTripStationLocationY;
  // final String? nextTripStationName;

  final int requestProcessId;

  final List<TripDetailsModel>? data;
  final List<TripStations>? lstTripStation;
  final TripDetailsModel? addTripPath ;
  //final TripStations? nextTripStation;

   const AddTripState(
      {

        this.status = BlocStatus.initial,
        this.errorMessage,
       this.data,
        this.lstTripStation,
        this.addTripPath,
      required this.requestProcessId,
   });
  AddTripState copyWith(
      {final BlocStatus? status,
      final String? errorMessage,
      final int? requestProcessId,
      final List<TripDetailsModel>? data,
        final List<TripStations>? lstTripStation,
        final TripDetailsModel? addTripPath,

        final bool clearNextStation = false}) {
    return AddTripState(
        data: data ?? this.data,
      lstTripStation: lstTripStation ?? this.lstTripStation,
      addTripPath: addTripPath ?? this.addTripPath,

        errorMessage: errorMessage ?? this.errorMessage,
        status: status ?? this.status,
        requestProcessId: requestProcessId ?? this.requestProcessId,
      );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
       lstTripStation,
        data,
    addTripPath,
        requestProcessId,

      ];


}
