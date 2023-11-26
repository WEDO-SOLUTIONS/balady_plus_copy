import 'package:balady_new_app/app/core/shared_local_services/helpers.dart';
import 'package:balady_new_app/app/features/ekram/data/model/add_trip_params.dart';
import 'package:balady_new_app/app/features/ekram/domain/entities/add_trip_dialog_params.dart';
import 'package:balady_new_app/app/features/ekram/domain/entities/lookup_item_location.dart';
import 'package:balady_new_app/app/features/ekram/domain/entities/update_driver_location_params.dart';
import 'package:balady_new_app/app/features/ekram/domain/use_cases/add_trip.dart';
import 'package:balady_new_app/app/features/ekram/domain/use_cases/get_launduries.dart';
import 'package:balady_new_app/app/features/ekram/domain/use_cases/get_mosques.dart';
import 'package:balady_new_app/app/features/ekram/domain/use_cases/update_driver_location.dart';
import 'package:balady_new_app/app/features/ekram/ekram_exports.dart';
import 'package:balady_new_app/shared/core/data/entities/lookup_item.dart';
import 'package:balady_new_app/shared/core/errors/errors_exports.dart';
import 'package:balady_new_app/shared/core/services/services_exports.dart';
import 'package:balady_new_app/shared/core/utils/utils_exports.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

part 'ekram_add_trip_event.dart';
part 'ekram_add_trip_state.dart';

class EkramAddTripBloc extends Bloc<EkramAddTripEvent, EkramAddTripState> {
  final GetLookUp _getLookUp;
  final GetHospitals _getHospitals;
  final GetMosques _getMosquess;
  final GetLaundries _getLaundries;

  final AddTrip _addTrip;
  final UpadateDriverLocation _upadateDriverLocation;
  EkramAddTripBloc(
      {required GetLookUp getLookUp,
      required AddTrip addTrip,
      required GetMosques getMosquess,
      required GetLaundries getLaundries,
      required GetHospitals getHospitals,
      required AddTripDialogParams params,
      required UpadateDriverLocation updateDriverLocation})
      : _getLookUp = getLookUp,
        _addTrip = addTrip,
        _getHospitals = getHospitals,
        _getLaundries = getLaundries,
        _getMosquess = getMosquess,
        _upadateDriverLocation = updateDriverLocation,
        super(EkramAddTripState(
          data: params,
          currentTripStationArrivalTime: params.currentTripStationArrivalTime,
          currentTripStationName: params.currentTripStationName,
          currentTripStationId: params.currentTripStationId,
          currentTripStationLocationX: params.currentTripStationLocationX,
          currentTripStationLocationY: params.currentTripStationLocationY,
          currentTripStationTypeId: params.currentTripStationTypeId,
        )) {
    on<EkramAddTripEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<ChangeNextTripStationType>(_changeNextTripStationType);
    on<ChangeArrivalTimeEvent>(_changeaArrivalTimeEvent);
    on<ChangeNextTripStationName>(_changeNextStationNameEvent);
    on<ChangeNextTripHospitalStation>(_changeNextStationHospitalEvent);
    on<ChangeNextTripMosuqeStation>(_changeNextStationMosqueEvent);
    on<ChangeNextTripLaundryStation>(_changeNextStationLandryEvent);
    on<ClearErrorMsgEvent>(_clearErrorMsg);

    on<SubmitEvent>(_submitHandler);
    // on<UpdateDriverLocationEvent>(_updateDriverLocatioHandler);
    getNextStationTypeLookUp();
  }

  Future<void> _changeNextTripStationType(
      ChangeNextTripStationType e, Emitter emitter) async {
    emitter(
        state.copyWith(nextTripStationTypeId: e.item, clearNextStation: true));
  }

  Future<void> _changeaArrivalTimeEvent(
      ChangeArrivalTimeEvent e, Emitter emitter) async {
    DateTime? time = await DatePicker.showDateTimePicker(
        NavigationService.navigatorKey.currentContext!,
        showTitleActions: true,
        minTime: DateTime(2010, 1, 1),
        theme: DatePickerTheme(),
        maxTime: DateTime(2050, 1, 1), onChanged: (date) {
      print('change $date');
    }, onConfirm: (date) {
      print('confirm $date');
    }, currentTime: DateTime.now(), locale: LocaleType.ar);

    String formatted =
        DateFormat("yyyy/MM/dd hh:mm:ss").format(time!).toString();
    emitter(state.copyWith(
      nextTripStationArrivalTime: formatted,
    ));
  }

  Future<void> _changeNextStationNameEvent(
      ChangeNextTripStationName e, Emitter emitter) async {
    emitter(state.copyWith(
      nextTripStationName: e.text,
    ));
  }

  Future<void> _changeNextStationHospitalEvent(
      ChangeNextTripHospitalStation e, Emitter emitter) async {
    emitter(state.copyWith(
      nextHospitalStation: e.item,
    ));
  }

  Future<void> _changeNextStationMosqueEvent(
      ChangeNextTripMosuqeStation e, Emitter emitter) async {
    emitter(state.copyWith(
      nextMosqueStation: e.item,
    ));
  }

  Future<void> _changeNextStationLandryEvent(
      ChangeNextTripLaundryStation e, Emitter emitter) async {
    emitter(state.copyWith(
      nextLaundryStation: e.item,
    ));
  }

  Future<void> _submitHandler(SubmitEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    AddTripParams params = AddTripParams(
        currentTripStationArrivalTime: state.currentTripStationArrivalTime,
        currentTripStationId: state.currentTripStationId,
        currentTripStationLocationX: state.currentTripStationLocationX,
        currentTripStationLocationY: state.currentTripStationLocationY,
        currentTripStationName: state.currentTripStationName,
        currentTripStationTypeId: state.currentTripStationTypeId,
        nextTripStationArrivalTime: state.nextTripStationArrivalTime,
        nextTripStationId: state.nextTripStationId,
        nextTripStationName: state.nextTripStationName,
        nextTripStationTypeId: state.nextTripStationTypeId?.id,
        requestProcessId: state.data.deathInfoId);

    LookUpItemLocation? locationInfo;
    if (state.nextLaundryStation != null) {
      locationInfo = state.launduries?.firstWhereOrNull(
          (element) => element.id == state.nextLaundryStation?.id);
      params.nextTripStationName = state.nextLaundryStation?.name;
      params.nextTripStationId = state.nextLaundryStation?.id;
    }
    if (state.nextMosqueStation != null) {
      locationInfo = state.mosques?.firstWhereOrNull(
          (element) => element.id == state.nextMosqueStation?.id);
      params.nextTripStationName = state.nextMosqueStation?.name;
      params.nextTripStationId = state.nextMosqueStation?.id;
    }

    if (state.nextHospitalStation != null) {
      params.nextTripStationName = state.nextHospitalStation?.name;
      params.nextTripStationId = state.nextHospitalStation?.id;
    }

    params.nextTripStationLocationX = double.tryParse(locationInfo?.x ?? "");
    params.nextTripStationLocationY = double.tryParse(locationInfo?.y ?? "");

    final failureOrSuccess = await _addTrip(params);

    failureOrSuccess.fold((failure) {
      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) async {
      emitter(state.copyWith(
        status: BlocStatus.success,
        errorMessage: "",
      ));

      await _updateDriverLocatioHandler();
      NavigationService.navigatorKey.currentState
          ?.pop(success.data?.responseMessage);
    });
  }

  Future<List<LookUpItem>?> getNextStationTypeLookUp() async {
    emit(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _getLookUp(30500);
    return failureOrSuccess.fold((failure) {
      emit(state.copyWith(
        status: BlocStatus.retry,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
      return null;
    }, (success) {
      emit(state.copyWith(
        status: BlocStatus.success,
        nextStationType: success.data?.result,
        errorMessage: "",
      ));
      return success.data?.result;
    });
  }

  Future<List<LookUpItem>?> getHospitalsLookUp() async {
    emit(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _getHospitals(state.data.deathCityId!);
    return failureOrSuccess.fold((failure) {
      emit(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
      return null;
    }, (success) {
      print(success.data?.result?.first);
      emit(state.copyWith(
        status: BlocStatus.success,
        hospitals: success.data?.result,
        errorMessage: "",
      ));
      return success.data?.result;
    });
  }

  Future<List<LookUpItem>?> getMosquesLookUp() async {
    emit(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _getMosquess(state.data.deathCityId!);
    return failureOrSuccess.fold((failure) {
      emit(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
      return null;
    }, (success) {
      print(success.data?.result?.first);

      emit(state.copyWith(
        status: BlocStatus.success,
        mosques: success.data?.result,
        mosquesList: success.data?.result
            ?.map((e) => LookUpItem(id: e.id, name: e.name))
            .toList(),
        errorMessage: "",
      ));
      return success.data?.result
          ?.map((e) => LookUpItem(id: e.id, name: e.name))
          .toList();
    });
  }

  Future<List<LookUpItem>?> getLanuduriesLookUp() async {
    emit(state.copyWith(status: BlocStatus.loading));
    final failureOrSuccess = await _getLaundries(state.data.deathCityId!);
    return failureOrSuccess.fold((failure) {
      emit(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
      return null;
    }, (success) {
      emit(state.copyWith(
        status: BlocStatus.success,
        launduries: success.data?.result,
        launduriesList: success.data?.result
            ?.map((e) => LookUpItem(id: e.id, name: e.name))
            .toList(),
        errorMessage: "",
      ));
      return success.data?.result
          ?.map((e) => LookUpItem(id: e.id, name: e.name))
          .toList();
    });
  }

  Future<void> _clearErrorMsg(ClearErrorMsgEvent e, Emitter emitter) async {
    emitter(state.copyWith(errorMessage: ""));
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
    } catch (ex) {}
  }
}
