import 'package:balady_plus/app/commercial_model/features/comercial_license_renew/data/data_sources/renew_cr_remote_data_source.dart';
import 'package:balady_plus/app/features/ekram/data/model/add_trip_params.dart';
import 'package:balady_plus/app/features/ekram/domain/entities/add_trip_dialog_params.dart';
import 'package:balady_plus/app/features/ekram/domain/entities/lookup_item_location.dart';
import 'package:balady_plus/app/features/ekram/domain/entities/update_driver_location_params.dart';
import 'package:balady_plus/app/features/ekram/domain/use_cases/add_trip.dart';
import 'package:balady_plus/app/features/ekram/domain/use_cases/get_ekram_lookups.dart';
import 'package:balady_plus/app/features/ekram/domain/use_cases/get_launduries.dart';
import 'package:balady_plus/app/features/ekram/domain/use_cases/get_mosques.dart';
import 'package:balady_plus/app/features/ekram/domain/use_cases/update_driver_location.dart';
import 'package:balady_plus/app/features/ekram/ekram_exports.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/services/local/helpers.dart';
import '../../../../../core/services/local/navigation_services.dart';
import '../../../../../core/utils/common_functions.dart';
import '../../../../../core/utils/enums/bloc_status.dart';
import '../../../../new_appointment/presentation/core/models/lookup_list_model.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

import '../../../data/model/driver/trip_details_model.dart';
import '../../../data/model/driver/trip_stations.dart';
import '../../../domain/use_cases/edit_trip.dart';
import '../../../domain/use_cases/get_trip_stations.dart';
import '../../../domain/use_cases/get_trips.dart';

part 'add_trip_event.dart';
part 'add_trip_state.dart';

class AddTripBloc extends Bloc<TripEvent, AddTripState> {
  final AddTrip _addTrip;
  final EditTrip _editTrip;
  final UpadateDriverLocation _upadateDriverLocation;
 final GetTripStations _getTripStations;
 final GetTrips _getTrips;
  final TransportRequestItemModel model;

  AddTripBloc(
      {
        required GetTrips getTrips,
        required GetTripStations getTripStations,
      required AddTrip addTrip,
        required EditTrip editTrip,
      required TransportRequestItemModel model,
      required UpadateDriverLocation updateDriverLocation})
      :
        _addTrip = addTrip,
        _editTrip = editTrip,
        _getTripStations=getTripStations,
        _upadateDriverLocation = updateDriverLocation,
        _getTrips = getTrips,
        model =model,
        super(
          AddTripState(model: model)) {


    on<AddNewPathEvent>(_addNewPath);
    on<GetTripsEvent>(_getTripsHandler);
    on<GetTripsStationEvent>(_getTripStationHandler);
    on<setNewPathData>(_setNewPathData);
    on<EditTripPathData>(_editTripPathData);

    on<ClearErrorMsgEvent>(_clearErrorMsg);
    on<SubmitEvent>(_submitHandler);
    // on<UpdateDriverLocationEvent>(_updateDriverLocatioHandler);

  }




  Future<void> _setNewPathData(setNewPathData e, Emitter emitter) async {


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
   emitter(state.copyWith(addTripPath: newTripPath));


  }

  Future<void> _submitHandler(SubmitEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    // AddTripParams params = AddTripParams(
    //     currentTripStationArrivalTime: state.currentTripStationArrivalTime,
    //     currentTripStationId: state.currentTripStationId,
    //     currentTripStationLocationX: state.currentTripStationLocationX,
    //     currentTripStationLocationY: state.currentTripStationLocationY,
    //     currentTripStationName: state.currentTripStationName,
    //     currentTripStationTypeId: state.currentTripStationTypeId,
    //     nextTripStationArrivalTime: state.nextTripStationArrivalTime,
    //     nextTripStationId: state.nextTripStationId,
    //     nextTripStationName: state.nextTripStationName,
    //     nextTripStationTypeId: state.nextTripStationTypeId?.id,
    //     requestProcessId: state.data.deathInfoId);
    //
    // LookUpItemLocation? locationInfo;
    // if (state.nextLaundryStation != null) {
    //   locationInfo = state.launduries?.firstWhereOrNull(
    //       (element) => element.id == state.nextLaundryStation?.id);
    //   params.nextTripStationName = state.nextLaundryStation?.name;
    //   params.nextTripStationId = state.nextLaundryStation?.id;
    // }
    // if (state.nextMosqueStation != null) {
    //   locationInfo = state.mosques?.firstWhereOrNull(
    //       (element) => element.id == state.nextMosqueStation?.id);
    //   params.nextTripStationName = state.nextMosqueStation?.name;
    //   params.nextTripStationId = state.nextMosqueStation?.id;
    // }
    //
    // if (state.nextHospitalStation != null) {
    //   params.nextTripStationName = state.nextHospitalStation?.name;
    //   params.nextTripStationId = state.nextHospitalStation?.id;
    // }
    //
    // if (state.isCemetry()) {
    //   // MM Check
    //   params.nextTripStationName = state.data.cemetryName;
    //   params.nextTripStationId = state.data.cemetryId;
    // }
    //
    // params.nextTripStationLocationX = double.tryParse(locationInfo?.x ?? "");
    // params.nextTripStationLocationY = double.tryParse(locationInfo?.y ?? "");
    //
    // final failureOrSuccess = await _addTrip(params);
    //
    // await failureOrSuccess.fold((failure) {
    //   emitter(state.copyWith(
    //     status: BlocStatus.failure,
    //     errorMessage: (failure as ServerFailure).errorMessage,
    //   ));
    // }, (success) async {
    //   await _updateDriverLocatioHandler();
    //   emitter(state.copyWith(
    //     status: BlocStatus.success,
    //     errorMessage: "",
    //   ));
    //
    //   NavigationService.navigatorKey.currentState
    //       ?.pop(success.data?.responseMessage);
    // });
  }
  Future<void> _clearErrorMsg(ClearErrorMsgEvent e, Emitter emitter) async {

    BlocStatus status = BlocStatus.retry;

    emitter(state.copyWith(status: status,errorMessage: ""));
  }

  Future<void> _updateDriverLocatioHandler() async {
    try {
      LatLng? location = await Helpers.getCurrentLocation();
      if (location != null) {
        final failureOrSuccess =
            await _upadateDriverLocation(UpdateDriverLocationParams(
                //deadInfoRecordId: state.data.deathInfoId!,
                x: location.longitude,
                y: location.latitude));
      }
    } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
  }


  Future<void> _getTripsHandler(GetTripsEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _getTrips(
        state.model);

    failureOrSuccess.fold((failure) async {
      CommonFunctions.showError((failure as ServerFailure).errorMessage);
      emitter(state.copyWith(status: BlocStatus.retry, errorMessage: "",)


      );


    }, (success) async {


      if(success.data?.result != null) {


        List<TripDetailsModel>? data = filtterData(success.data!.result!);

        emitter(state.copyWith(
          status: BlocStatus.success,
          data: data,
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
      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));




    }, (success) async {

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
      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));




    }, (success) async {

      if(success.data?.result == true) {
        CommonFunctions.showSuccess("update_appointment_success_msg".tr());
        emitter(state.copyWith(
          status: BlocStatus.success,
          errorMessage: "",
        ));
      }

    });




  }

  Future<void> _addNewPath(TripEvent e, Emitter emitter) async {




    emitter(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _addTrip(
        [state.model.requestId!,state.addTripPath]);

    failureOrSuccess.fold((failure) async {
      CommonFunctions.showError((failure as ServerFailure).errorMessage);
      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));




    }, (success) async {

      emitter(state.copyWith(
        status: BlocStatus.success,
        data: success.data?.result,
        errorMessage: "",
      ));

    });




  }




  List<TripDetailsModel> filtterData(List<TripDetailsModel> data)
  {

    for (var index = 0; index <data.length; index++) {
      if(data[index].startupInfo?.date != null && data[index].startupInfo?.time != null )
        {
          data[index].isSuggestPath=false;
        }
      else
        {
          data[index].isSuggestPath=true;
        }

    }
    data[0].isSuggestPath = false;
    return data;

  }


}
