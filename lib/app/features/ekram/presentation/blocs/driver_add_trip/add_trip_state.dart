part of 'add_trip_bloc.dart';

class AddTripState extends Equatable {
  final BlocStatus status;
  final String? errorMessage;

  final TransportRequestItemModel model;

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
      required this.model,
   });
  AddTripState copyWith(
      {final BlocStatus? status,
      final String? errorMessage,
      final TransportRequestItemModel? model,
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
        model: model ?? this.model,
      );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
       lstTripStation,
        data,
    addTripPath,
        model,

      ];


}
