import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:bloc/bloc.dart';
import 'package:dgis_map/library.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';




import '../../../../../core/errors/failures.dart';
import '../../../../../core/services/local/navigation_services.dart';
import '../../../../../core/utils/enums/bloc_status.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../../../../_shared_feature_/data/entities/success_screen_args.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_popups_widgets.dart';
import '../../../data/model/trips_details_params.dart';
import '../../../domain/entities/add_trip_dialog_params.dart';
import '../../../domain/entities/deceased_request_details/deceased_request_details.dart';
import '../../../domain/entities/trip_details.dart';
import '../../../domain/entities/trip_location_response.dart';
import '../../../domain/use_cases/get_deceased_driver_request_details.dart';
import '../../../domain/use_cases/get_trips.dart';
import '../../../domain/use_cases/get_trips_location.dart';
import '../../dialogs/add_trip_dialog.dart';
import '../../dialogs/trip_details_dialog.dart';

part 'request_details_bloc_event.dart';

part 'request_details_bloc_state.dart';

class RequestDetailsBloc
    extends Bloc<RequestDetailsEvent, RequestDetailsState> {
  final GetTrips _getTrips;
  final GetTripsLocation _getTripsLocation;
  final GetDeceasedDriverRequestDetails _getDeceasedDriverRequestDetails;

  RequestDetailsBloc(
      {required DeceasedRequestDetails details,
      required GetDeceasedDriverRequestDetails getDeceasedDriverRequestDetails,
      required GetTrips getTrips,
      required GetTripsLocation getTripsLocation,
      required bool isDriver})
      : _getTrips = getTrips,
        _getTripsLocation = getTripsLocation,
        _getDeceasedDriverRequestDetails = getDeceasedDriverRequestDetails,
        super(RequestDetailsState(details: details, isDriver: isDriver)) {
    on<RequestDetailsEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<GetDriverRequestDetails>(_getDeceasedDriverRequestHandler);
    on<GetTripsEvent>(_getTripsHandler);
    on<GetTripsLocationEvent>(_getTripsLocationsHandler);

    on<GetTripsDetailsEvent>(_getTripsDetailsHandler);
  }

  Future<void> _getDeceasedDriverRequestHandler(
      GetDriverRequestDetails e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));
    var failureOrSuccess =
        await _getDeceasedDriverRequestDetails(state.details.requestId!);
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

  Future<void> _getTripsHandler(GetTripsEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _getTrips(
        state.details.deceasedInfoResponseDtoList![e.index].deathInfoId!);

    failureOrSuccess.fold((failure) async {
      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));

      var context = NavigationService.navigatorKey.currentContext;
      final result = await CustomPopUpsWidgets.showBottomSheet(context!,
          child: AddTripDialog(
            params: getCurrentAddTripData(
                null, state.details.deceasedInfoResponseDtoList![e.index],
                trips: []),
          ),
          height: MediaQuery.of(context).size.height * 0.95);

      if (result != null) {
        NavigationService.navigatorKey.currentState!.pushNamed(
            RouteName.successRoute,
            arguments: SuccessScreenArgs(
                type: PAGE_TYPE.other, thanksMessage: result));
      }
    }, (success) async {
      emitter(state.copyWith(
        status: BlocStatus.success,
        errorMessage: "",
      ));

      var context = NavigationService.navigatorKey.currentContext;
      final result = await CustomPopUpsWidgets.showBottomSheet(context!,
          child: AddTripDialog(
            params: getCurrentAddTripData(success.data?.result?.lastOrNull,
                state.details.deceasedInfoResponseDtoList![e.index],
                trips: success.data?.result),
          ),
          height: MediaQuery.of(context).size.height * 0.95);

      if (result != null) {
        NavigationService.navigatorKey.currentState!.pushNamed(
            RouteName.successRoute,
            arguments: SuccessScreenArgs(
                type: PAGE_TYPE.other, thanksMessage: result));
      }
    });
  }

  Future<void> _getTripsLocationsHandler(
      GetTripsLocationEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _getTripsLocation(
        state.details.deceasedInfoResponseDtoList![e.index].deathInfoId!);

    failureOrSuccess.fold((failure) async {
      print("failurefailure");
      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) async {
      emitter(state.copyWith(
        status: BlocStatus.success,
        errorMessage: "",
      ));

      var context = NavigationService.navigatorKey.currentContext;

      TripLocationItem? item = success.data?.result?.items?.firstOrNull;
      if (item != null && item.lastX != null && item.lastY != null) {
        double? lat = double.tryParse(item.lastY ?? "");
        double? lon = double.tryParse(item.lastX ?? "");
        if (lat != null && lon != null)
          NavigationService.navigatorKey.currentState!
              .pushNamed(RouteName.EkramMapPage, arguments: LatLng(latitude:lat, longitude:lon));
      }
    });
  }

  AddTripDialogParams getCurrentAddTripData(
      TripDetails? lastTrip, DeceasedInfoResponseDtoList info,
      {List<TripDetails>? trips}) {
    if (lastTrip == null) {
      return AddTripDialogParams(
          deathCityId: state.details.deathCityId,
          deathInfoId: info.deathInfoId,
          currentTripStationArrivalTime:
              info.driverAssignDateTime?.replaceAll("-", "/"),
          currentTripStationId: info.transferOrganizationId,
          currentTripStationLocationX: double.tryParse(
            info.transferOrganizationX ?? "",
          ),
          currentTripStationLocationY: double.tryParse(
            info.transferOrganizationY ?? "",
          ),
          currentTripStationName: info.transferOrganizationName,
          currentTripStationTypeId: 30502,
          cemetryId: info.cemeteryId,
          cemetryName: info.cemeteryName,
          trips: trips);
    } else {
      return AddTripDialogParams(
          deathCityId: state.details.deathCityId,
          deathInfoId: info.deathInfoId,
          currentTripStationArrivalTime:
              lastTrip.nextTripStationArrivalTime?.replaceAll("-", "/"),
          currentTripStationId: lastTrip.nextTripStationId,
          currentTripStationLocationX: double.tryParse(
            lastTrip.nextTripStationLocationX ?? "",
          ),
          currentTripStationLocationY: double.tryParse(
            lastTrip.nextTripStationLocationY ?? "",
          ),
          currentTripStationName: lastTrip.nextTripStationName,
          currentTripStationTypeId: lastTrip.nextTripStationTypeId,
          cemetryId: info.cemeteryId,
          cemetryName: info.cemeteryName,
          trips: trips);
    }
  }

  Future<void> _getTripsDetailsHandler(
      GetTripsDetailsEvent e, Emitter emitter) async {
    var context = NavigationService.navigatorKey.currentContext!;
    final result = await CustomPopUpsWidgets.showBottomSheet(context,
        child: TripDetailsDialog(
            params: TripDetailsParmas(
                requestId: e.requestId,
                info: e.dto,
                requestStatusId: e.requestStatusId,
                transportAttachResponseDtoList: e.letters)),
        height: MediaQuery.of(context).size.height * 0.95);
    if (result == true) {
      add(GetDriverRequestDetails());
      emitter(state.copyWith(isCompleted: true));
    }
  }
}
