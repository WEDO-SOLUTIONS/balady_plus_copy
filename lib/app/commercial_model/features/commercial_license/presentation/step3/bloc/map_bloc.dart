import 'dart:async';
import 'package:balady_plus/app/core/utils/constants/remote_config.dart';
import 'package:balady_plus/app/features/municipal_services/municipal_advisor/domain/use_cases/get_gis_image.dart';
import 'package:balady_plus/app/features/vd/vd_exports.dart'
    show MapScreenParams, GetGISData, GISParams, GISResponse;
import 'package:bloc/bloc.dart';
import 'package:dgis_map/dgis_map_controller.dart';
import 'package:dgis_map/library.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:localize_and_translate/localize_and_translate.dart';
import 'dart:io';
import 'dart:math' show cos, sqrt, asin;

import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';

import '../../../../commercial_license_approvel_export/domain/use_cases/setp2_get_spl_notification.dart';
import '../../../commercial_license_exports.dart'
    show
        CommercialLicenseBloc,
        GoToNextPageEvent,
        SaveLocationDataRequest,
        SaveLocationDetails,
        UpdateRequestFieldEvent;
import '../../../data/models/commercial_request_details_response.dart';
import '../../../domain/entities/save_location_response.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  TextEditingController mapNpController = TextEditingController();
  TextEditingController landNpController = TextEditingController();

  final GetGISData _getGisData;
  late DgisMapController mapController;
  final SaveLocationDetails _saveLocationDetails;
  final GetGISImage _getGISImage;
  GetSPLNotification _getSPLNotification;

  MapBloc({MapScreenParams? params})
      : _getGisData = GetGISData(repository: sl()),
        _saveLocationDetails = SaveLocationDetails(repository: sl()),
        _getGISImage = GetGISImage(sl()),
        _getSPLNotification = GetSPLNotification(repository:sl()),
        super(MapState(
          gisResponse: params?.gisResponse,
          location: params?.gisParams,
          readOnly: params?.readOnly,
          requestNo: params?.requestNo,
          userLocation: params?.currentUserLocation,
        )) {
    on<GetGISDataEvent>(_getGisDataHandler);
    on<InitMapEvent>(_initMapHandler);

    on<GetCurentUserLocationEvent>(_getCurrenttUserLocationHandler);
    on<SelectLocationEvent>(_selectLocationEventHandler);
    on<SaveLocationDataEvent>(_saveLocationHandler);
    on<UpdateFieldsEvent>(_updateFieldsHandler);
  }



  void _handleSPLNotication() async {

    if(state.gisResponse != null && state.gisResponse?.subMunicipalityguid != null ) {
      emit(state.copyWith(status: BlocStatus.loading, errorMessage: "",));

      String requestTypeId= "1004";
      // if(sl<CommercialLicenseBloc>().state.isFromIntialApproval ==true)
      //   requestTypeId ="1801";

      final response = await _getSPLNotification([requestTypeId,state.gisResponse!.subMunicipalityguid!]);

      response.fold(
              (failure) =>
              emit(state.copyWith(
                status: BlocStatus.failure,
                errorMessage: (failure as ServerFailure).errorMessage,
              )), (res) {
        emit(state.copyWith(status: BlocStatus.success,));
        if(res.isNotEmpty) {

          emit(state.copyWith(
              status: BlocStatus.success,
              errorMessage: "",
              splNotification: res
          ));






        }



      });
    }
  }



  Future<void> _getGisDataHandler(GetGISDataEvent e, Emitter emitter) async {
    if ((state.status == BlocStatus.loading)) return;
    emitter(state.copyWith(status: BlocStatus.loading, errorMessage: ""));
    GISParams params = e.params;

    if (e.popPage) params.requestNo = state.requestNo;

    final failureOrSuccess = await _getGisData(e.params);

    await failureOrSuccess.fold((failure) {
      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) async {
      emitter(state.copyWith(
        status: BlocStatus.success,
        gisResponse: success,
        mapNo: !e.refreshLocation
            ? success.planNo != "Null"
                ? success.planNo ?? ""
                : ""
            : null,
        landNo: !e.refreshLocation
            ? success.parcelNo != "Null"
                ? success.parcelNo ?? ""
                : ""
            : null,
        errorMessage: "",
      ));

      if (e.popPage) {
        mapNpController.text =
            success.planNo != "Null" ? success.planNo ?? "" : "";
        landNpController.text =
            success.parcelNo != "Null" ? success.parcelNo ?? "" : "";
        String? url = await getImageUrl(e.params);

        if (url != null) {
          success.locationURL = url;

          NavigationService.navigatorKey.currentState
              ?.pop(MapScreenParams(gisParams: e.params, gisResponse: success));
        }

        _handleSPLNotication();
      }
    });
  }

  Future<String?> getImageUrl(GISParams params) async {
    emit(state.copyWith(status: BlocStatus.loading, errorMessage: ""));

    final failOrSuccess = await _getGISImage(params);

    return await failOrSuccess.fold((failure) async {
      emit(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (r) {
      emit(state.copyWith(status: BlocStatus.success, errorMessage: ""));

      return r;
    });
  }

  Future<void> _getCurrenttUserLocationHandler(
      GetCurentUserLocationEvent e, Emitter emitter) async {
    try {
      emitter(state.copyWith(status: BlocStatus.loading, errorMessage: ""));

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best,
          timeLimit: const Duration(seconds: 20));
      emitter(state.copyWith(
          status: BlocStatus.success,
          location: GISParams(x: position.longitude, y: position.latitude),
          userLocation:
              GISParams(x: position.longitude, y: position.latitude)));
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      Position? position;
      try {
        position = await Geolocator.getLastKnownPosition();
      } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
      if (position != null) {
        emitter(state.copyWith(
            status: BlocStatus.success,
            location: GISParams(x: position.longitude, y: position.latitude),
            userLocation:
                GISParams(x: position.longitude, y: position.latitude)));
      }
    }

    add(GetGISDataEvent(
        params: state.location!, popPage: false, refreshLocation: true));

    animateCamera(state.location!.y, state.location!.x);
  }

  Future<void> _selectLocationEventHandler(
      SelectLocationEvent e, Emitter emitter) async {
    print("SelectLocationEvent");
    emitter(state.copyWith(status: BlocStatus.loading, errorMessage: ""));

    emitter(state.copyWith(
        status: BlocStatus.success,
        isLocationAllowed: true,
        location: GISParams(x: e.location.longitude, y: e.location.latitude)));
    add(GetGISDataEvent(
        params: GISParams(x: e.location.longitude, y: e.location.latitude),
        popPage: false));
  }

  Future<void> _saveLocationHandler(
      SaveLocationDataEvent e, Emitter emitter) async {
    int requestId = sl<CommercialLicenseBloc>().state.requestId!;
    emitter(state.copyWith(status: BlocStatus.loading, errorMessage: ""));

    final failOrSuccess = await _saveLocationDetails(SaveLocationDataRequest(
        requestId: requestId,
        krokiUrl: state.gisResponse?.locationURL,
        streetCode: (state.gisResponse?.streetCode?.isEmpty ?? true)
            ? "-1"
            : state.gisResponse?.streetCode,
        subMunicipalityGisCode: state.gisResponse?.municipalityuniquecode,
        districtCode: state.gisResponse?.Balady_DistrictID,
        latitude: state.location?.lat,
        longitude: state.location?.lon,
        mapNo: state.mapNo,
        landNo: state.landNo));

    await failOrSuccess.fold((l) {
      emitter(state.copyWith(
          status: BlocStatus.failure,
          errorMessage: (l as ServerFailure).errorMessage));
    }, (r) async {

      sl<CommercialLicenseBloc>().add((const GoToNextPageEvent()));
      sl<CommercialLicenseBloc>().updateGISData(gis: state.gisResponse);
      emitter(state.copyWith(status: BlocStatus.success, locationResponse: r));

      sl<CommercialLicenseBloc>().add((UpdateRequestFieldEvent(
          saveLocationResponse: r, requestId: requestId)));
    });
  }

  Future<void> _updateFieldsHandler(
      UpdateFieldsEvent e, Emitter emitter) async {
    emitter(state.copyWith(mapNo: e.mapNo, landNo: e.landNo, errorMessage: ""));
  }

  Future<void> _initMapHandler(InitMapEvent e, Emitter emitter) async {
    if (state.readOnly == true) {
    } else {
      if (state.location != null && state.gisResponse == null) {
        add(GetGISDataEvent(params: state.location!, popPage: false));
      } else if (state.location != null && state.gisResponse != null) {
      } else {
        try {
          emitter(state.copyWith(status: BlocStatus.loading));

          Position position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.best,
              timeLimit: const Duration(seconds: 20));
          emitter(state.copyWith(
              status: BlocStatus.success,
              location: GISParams(x: position.longitude, y: position.latitude),
              userLocation:
                  GISParams(x: position.longitude, y: position.latitude)));
        } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
          Position? position;
          try {
            position = await Geolocator.getLastKnownPosition();
          } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
          if (position != null) {
            emitter(state.copyWith(
                status: BlocStatus.success,
                location:
                    GISParams(x: position.longitude, y: position.latitude),
                userLocation:
                    GISParams(x: position.longitude, y: position.latitude)));
          }
        }

        if (state.location == null) {
          emitter(state.copyWith(
              status: BlocStatus.success,
              location: GISParams(
                  x: CommonProperties.defaultLocation.longitude,
                  y: CommonProperties.defaultLocation.latitude),
              userLocation: GISParams(
                  x: CommonProperties.defaultLocation.longitude,
                  y: CommonProperties.defaultLocation.latitude)));
        }
      }
      animateCamera(state.location!.y, state.location!.x);
    }
  }

  void animateCamera(double lat, double lng) {
    try {
      // mapController.animateCamera(
      //   CameraUpdate.newCameraPosition(
      //     CameraPosition(target: LatLng(lat, lng), zoom: 16.0),
      //   ),
      // );

      mapController.moveCamera(
        CameraPositionMessage(
          point: GeoPointMessage(latitude: lat, longitude: lng),
          zoom: 16.0,
          tilt: 0.0,
          bearing: 0.0,
        ),
        0.3, // duration
        CameraAnimationTypeMessage.linear,
      );

    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
    }
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    if (lat1 == null || lon1 == null || lat2 == null || lon2 == null) return 0;
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a)) * 1000;
  }

  bool checkDistanceBetweenUserLocationAndSelectedLocation(
      {LatLng? userLocation, LatLng? selectedLocation}) {
    if (userLocation == null || selectedLocation == null) return false;
    double distanceInMeters = calculateDistance(
        userLocation.latitude,
        userLocation.longitude,
        selectedLocation.latitude,
        selectedLocation.longitude);

    if (distanceInMeters <= RemoteConfig.mapRadius) {
      return true;
    }
    return false;
  }

  static showCustomDialog(Widget dialog, {bool isDismiss = true}) {
    showDialog(
        context: NavigationService.navigatorKey.currentState!.context,
        barrierDismissible: isDismiss,
        builder: (ctx) => Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            child: dialog));
  }

  void initDraft() async {
    bool isDraft = sl<CommercialLicenseBloc>().state.isDraft ?? false;
    bool draftLoaded = state.draftLoaded ?? false;

    print(isDraft);
    print(draftLoaded);
    if ( isDraft) {
      // if (true) {
      emit(state.copyWith(
        draftStatus: BlocStatus.success,
      ));
      CommercialRequestDetailsResponse? requestData =
          sl<CommercialLicenseBloc>().state.requestData;

      double? latitude =
          double.tryParse(requestData?.locationInfo?.latitude ?? "");
      double? longitude =
          double.tryParse(requestData?.locationInfo?.longitude ?? "");

      if (latitude != null && longitude != null) {
        if(sl<CommercialLicenseBloc>().state.isFromIntialApproval!=true) {
          add(GetGISDataEvent(
              params: GISParams(x: longitude, y: latitude),
              popPage: false,
              refreshLocation: true));
        }
        else {
          emit(state.copyWith(
            status: BlocStatus.success,
            gisResponse: GISResponse(
                adminMunicipalityId: requestData?.locationInfo?.municipalityId,
                adminMunicipalityName: requestData?.locationInfo?.municipalityName,
                Balady_DistrictID: "${requestData?.locationInfo?.districtCode}",
                Balady_DistrictName: requestData?.locationInfo?.districtName,
                districtId: "${requestData?.locationInfo?.districtCode}",
                districtName: requestData?.locationInfo?.districtName,
                municipalityId: requestData?.locationInfo?.municipalityId,
                municipalityuniquecode: requestData?.locationInfo?.subMunicipalityGisCode,
                municipalityName: requestData?.locationInfo?.municipalityName,
                region: requestData?.locationInfo?.regionName,
                streetCode: "${requestData?.locationInfo?.streetCode}",
                streetName: requestData?.locationInfo?.streetName,
                subMunicipalityId: requestData?.locationInfo?.subMunicipalityId,
                subMunicipalityName: requestData?.locationInfo?.subMunicipalityName,
                subMunicipalityguid:requestData?.locationInfo?.subMunicipalityGisCode ,
                locationURL: requestData?.locationInfo?.krokiUrl),
            mapNo: requestData?.locationInfo?.mapNo,
            landNo: requestData?.locationInfo?.landNo,
            errorMessage: "",
          ));

          _handleSPLNotication();
        }


        emit(state.copyWith(
          draftLoaded: true,
          draftStatus: BlocStatus.success,
          location: GISParams(x: longitude, y: latitude),
          userLocation: GISParams(x: longitude, y: latitude),
          mapNo: requestData?.locationInfo?.mapNo,
          landNo: requestData?.locationInfo?.landNo,
        ));

        print("LANNNND ${requestData?.locationInfo?.landNo}");
        mapNpController.text = requestData?.locationInfo?.mapNo ?? "";
        landNpController.text = requestData?.locationInfo?.landNo ?? "";
      }
    } else {
      emit(state.copyWith(
        draftStatus: BlocStatus.success,
      ));
    }
  }
}
