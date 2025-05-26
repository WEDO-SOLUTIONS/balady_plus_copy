import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import 'package:collection/collection.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/services/local/navigation_services.dart';
import '../../../../../core/utils/enums/bloc_status.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../../../../_shared_feature_/data/entities/success_screen_args.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_popups_widgets.dart';
import '../../../data/model/driver/deceased_identical_item.dart';
import '../../../data/model/driver/trip_details_model.dart';
import '../../../data/model/trips_details_params.dart';
import '../../../domain/entities/add_trip_dialog_params.dart';
import '../../../domain/entities/deceased_request_details/deceased_request_details.dart';
import '../../../domain/entities/trip_details.dart';
import '../../../domain/entities/trip_location_response.dart';
import '../../../domain/use_cases/get_identical_list_request.dart';
import '../../../domain/use_cases/get_trips.dart';
import '../../../domain/use_cases/get_trips_location.dart';
import '../../pages/driver/request_trips.dart';
import '../../dialogs/trip_details_dialog.dart';

part 'identical_list_bloc_event.dart';

part 'identical_list_bloc_state.dart';

class IdenticalListBloc extends Bloc<IdenticalListEvent, IdenticalListState> {


  final GetIdenticalListRequest _getIdenticalListRequestDetails;

  IdenticalListBloc(
      {

        required GetIdenticalListRequest getIdenticalListRequestDetails,
      required bool isDriver})
      :
        _getIdenticalListRequestDetails = getIdenticalListRequestDetails,
        super(IdenticalListState( isDriver: isDriver)) {

    on<IdenticalListEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<GetIdenticalListRequestEvent>(_getIndenticalListRequestHandler);



    // on<GetTripsDetailsEvent>(_getTripsDetailsHandler);
  }

  Future<void> _getIndenticalListRequestHandler(
      GetIdenticalListRequestEvent e, Emitter emitter) async {
    if(isClosed) return;
    emitter(state.copyWith(requestID: e.requestId));
    emitter(state.copyWith(status: BlocStatus.loading));
    var failureOrSuccess =
        await _getIdenticalListRequestDetails(state.requestID!);
    failureOrSuccess.fold((failure) {

      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) {
      emitter(state.copyWith(
        status: BlocStatus.success,
        deceasedRequestItems: success.data?.result,
        errorMessage: "",
      ));
    });
  }


  // Future<void> _getTripsDetailsHandler(
  //     GetTripsDetailsEvent e, Emitter emitter) async {
  //   var context = NavigationService.navigatorKey.currentContext!;
  //   final result = await CustomPopUpsWidgets.showBottomSheet(context,
  //       child: TripDetailsDialog(
  //           params: TripDetailsParmas(
  //               requestId: e.requestId,
  //               info: e.dto,
  //               requestStatusId: e.requestStatusId,
  //               transportAttachResponseDtoList: e.letters)),
  //       height: MediaQuery.of(context).size.height * 0.95);
  //   if (result == true) {
  //     add(GetIdenticalListRequestEvent());
  //     emitter(state.copyWith(isCompleted: true));
  //   }
  // }
}
