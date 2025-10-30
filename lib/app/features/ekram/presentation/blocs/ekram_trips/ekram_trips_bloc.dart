import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/utils/enums/bloc_status.dart';

part 'ekram_trips_event.dart';
part 'ekram_trips_state.dart';

class EkramTripsBloc extends Bloc<EkramTripsEvent, EkramTripsState> {
  final BlocStatus status;
  final String? errorMessage;

  EkramTripsBloc({
    this.status = BlocStatus.initial,
    this.errorMessage,
  }) : super(EkramTripsInitial()) {
    on<EkramTripsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
