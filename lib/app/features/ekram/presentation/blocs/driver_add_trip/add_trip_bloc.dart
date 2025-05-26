
import 'package:balady_plus/app/features/ekram/domain/entities/update_driver_location_params.dart';
import 'package:balady_plus/app/features/ekram/domain/use_cases/add_trip.dart';

import 'package:balady_plus/app/features/ekram/domain/use_cases/update_driver_location.dart';
import 'package:balady_plus/app/features/ekram/ekram_exports.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/services/local/helpers.dart';

import '../../../../../core/services/local/navigation_services.dart';
import '../../../../../core/utils/common_functions.dart';
import '../../../../../core/utils/constants/route_names.dart';
import '../../../../../core/utils/enums/bloc_status.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

import '../../../data/model/driver/trip_details_model.dart';
import '../../../data/model/driver/trip_stations.dart';
import '../../../domain/use_cases/complete_trip.dart';
import '../../../domain/use_cases/delete_trip.dart';
import '../../../domain/use_cases/edit_trip.dart';
import '../../../domain/use_cases/get_trip_stations.dart';
import '../../../domain/use_cases/get_trips.dart';

part 'add_trip_event.dart';
part 'add_trip_state.dart';

class AddTripBloc extends Bloc<TripEvent, AddTripState> {
  final AddTrip _addTrip;
  final DeleteTrip _deleteTrip;
  final EditTrip _editTrip;
  final UpadateDriverLocation _upadateDriverLocation;
 final GetTripStations _getTripStations;
 final CompleteTrip _completeTrip;
 final GetTrips _getTrips;
  final TransportRequestItemModel model;
  BuildContext _context;

  AddTripBloc(
      {
        required GetTrips getTrips,
        required DeleteTrip deleteTrip,
        required GetTripStations getTripStations,
        required AddTrip addTrip,
        required EditTrip editTrip,
      required TransportRequestItemModel model,
      required UpadateDriverLocation updateDriverLocation,
        required CompleteTrip completeTrip,
      required BuildContext context,
      })
      :
        _addTrip = addTrip,
        _deleteTrip=deleteTrip,
        _editTrip = editTrip,
        _getTripStations=getTripStations,
        _upadateDriverLocation = updateDriverLocation,
        _getTrips = getTrips,
        _completeTrip = completeTrip,
        _context=context,
        model =model,
        super(
          AddTripState(model: model)) {


    on<AddCustomPathEvent>(_addCustomPath);
    on<GetTripsEvent>(_getTripsHandler);
    on<GetTripsStationEvent>(_getTripStationHandler);
    on<setCustomPathDataEvent>(_setCustomPathData);
    on<DeleteTripPath>(_deleteTripPath);
    on<EditTripPathData>(_editTripPathData);
    on<ClearErrorMsgEvent>(_clearErrorMsg);
    on<SubmitEvent>(_submitHandler);

  }




  Future<void> _setCustomPathData(setCustomPathDataEvent e, Emitter emitter) async {

   var newTripPath= state.addTripPath;
   newTripPath ??= TripDetailsModel(startupInfo: TripInfo(), arrivalInfo: TripInfo());
if(e.isStartupInfo == true) {
  newTripPath = newTripPath.copyWith(
      startupInfo: newTripPath.startupInfo?.copyWith(
          typeName: e.item?.typeName,
          typeId: e.item?.typeId,
          cityName: e.item?.cityName,
          name: e.item?.name,
          date: e.item?.date,
          time: e.item?.time));
}
else
  {
    newTripPath = newTripPath.copyWith(
        arrivalInfo: newTripPath.arrivalInfo?.copyWith(
            typeName: e.item?.typeName,
            typeId: e.item?.typeId,
            cityName: e.item?.cityName,
            name: e.item?.name,
            date: e.item?.date,
            time: e.item?.time));

  }
   if(isClosed) return;
   emitter(state.copyWith(addTripPath: newTripPath));


  }

  Future<void> _submitHandler(SubmitEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _completeTrip(state.model.requestId!);

    await failureOrSuccess.fold((failure) {
      CommonFunctions.showError((failure as ServerFailure).errorMessage);
      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));

    }, (success) async {
     // await _updateDriverLocatioHandler();
      emitter(state.copyWith(
        status: BlocStatus.success,
        errorMessage: "",
      ));
      
      // NavigationService.navigatorKey.currentState
      //     ?.popUntil((route) => route.settings.name == RouteName.driverEkramTransportationListScreen);
      NavigationService.navigatorKey.currentState
          ?.pushNamedAndRemoveUntil(RouteName.driverEkramTransportationListScreen,(route) => route.settings.name == RouteName.SpecificServicePage);

     // NavigationService.navigatorKey.currentContext!.read<TransportRequestsBloc>().add(GetDeceasedTransportRequestsEvent(isDriver: true));
      CommonFunctions.showSuccess("tripCompletesucessfully".tr());


    });

  }
  Future<void> _clearErrorMsg(ClearErrorMsgEvent e, Emitter emitter) async {

    BlocStatus status = BlocStatus.retry;

    emitter(state.copyWith(status: status,errorMessage: ""));
  }

  Future<void> _getTripsHandler(GetTripsEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _getTrips(state.model.requestId!);

    failureOrSuccess.fold((failure) async {
      CommonFunctions.showError((failure as ServerFailure).errorMessage);
      emitter(state.copyWith(status: BlocStatus.retry, errorMessage: "",));

    }, (success) async {


      if(success.data?.result != null) {

        List<TripDetailsModel>? data = filtterData(success.data!.result!);

        emitter(state.copyWith(
          status: BlocStatus.success,
          data: data,
          addTripPath:null,
          errorMessage: "",

        ));
      }
      else
        {
          CommonFunctions.showError("noData".tr());
          emitter(state.copyWith(status: BlocStatus.retry, errorMessage: "",));

        }

    });


  }


  Future<void> _getTripStationHandler(GetTripsStationEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _getTripStations(
        state.model.requestId!);

    failureOrSuccess.fold((failure) async {
      CommonFunctions.showError((failure as ServerFailure).errorMessage);
      if(isClosed) return;
      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));

    }, (success) async {

      if(isClosed) return;
      emitter(state.copyWith(
        status: BlocStatus.success,
        lstTripStation: success.data?.result,
        errorMessage: "",
      ));





    });
  }
  Future<void> _editTripPathData(EditTripPathData e, Emitter emitter) async {

    emitter(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _editTrip(
        [state.model.requestId,e.item!]);

    failureOrSuccess.fold((failure) async {

      CommonFunctions.showError((failure as ServerFailure).errorMessage);
      if(isClosed) return;
      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));


    }, (success) async {


      if(success.data?.result == true) {

        if(e.hidenScreen== true) {
          Navigator.pop(_context);
        }


        CommonFunctions.showSuccess("update_appointment_success_msg".tr());
        add(GetTripsEvent());
      }

    });




  }

  Future<void> _addCustomPath(AddCustomPathEvent e, Emitter emitter) async {




    emitter(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _addTrip(
        [state.model.requestId!,state.addTripPath]);

    failureOrSuccess.fold((failure) async {
      CommonFunctions.showError((failure as ServerFailure).errorMessage);
      if(isClosed) return;
      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));



    }, (success) async {

      if(isClosed) return;


      if(success.data?.result == true) {


          Navigator.pop(_context);
        CommonFunctions.showSuccess("update_appointment_success_msg".tr());
          add(GetTripsEvent());


      }

    });




  }


  Future<void> _deleteTripPath(DeleteTripPath e, Emitter emitter) async {

    emitter(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _deleteTrip(
        [state.model.requestId,e.tripId]);

    failureOrSuccess.fold((failure) async {

      CommonFunctions.showError((failure as ServerFailure).errorMessage);
      if(isClosed) return;
      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));


    }, (success) async {


      if(success.data?.result == true) {


        CommonFunctions.showSuccess("path_deleted".tr());
        add(GetTripsEvent());
      }

    });




  }

  List<TripDetailsModel> filtterData(List<TripDetailsModel> data)
  {

    if(data.isNotEmpty) {
      for (var index = 0; index < data.length; index++) {
        if (data[index].startupInfo?.date != null &&
            data[index].startupInfo?.time != null) {
          data[index].isSuggestPath = false;
        }
        else {
          data[index].isSuggestPath = true;
        }
      }
      data[0].isSuggestPath = false;
    }
    return data;

  }


}
