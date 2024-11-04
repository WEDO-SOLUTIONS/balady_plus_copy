import 'dart:math';

import 'package:flutter/material.dart';
import 'package:smart_advisor/app/core/services/services_exports.dart';
import 'package:smart_advisor/app/core/utils/utils_exports.dart';
import 'package:smart_advisor/app/features/map/data/enums/map_enums.dart';

import '../../data/models/map_requests_params.dart';
import '../../data/models/point_layers_data.dart';
import '../../domain/use_cases/get_imtethal_layer.dart';
import '../pages/area_page.dart';
import '/app/core/dependency_injection/injection_container.dart';
import '/app/core/errors/failures.dart';
import '/app/core/utils/enums/bloc_status.dart';
import '/app/features/_shared_feature_/domain/entities/lookUp_response.dart';
import '/app/features/map/domain/entities/get_zones_request.dart';
import '/app/features/map/domain/entities/gis_data_request.dart';
import '/app/features/map/domain/entities/gis_data_response.dart';
import '/app/features/map/domain/entities/validate_point_request.dart';
import '/app/features/map/domain/entities/validate_point_response.dart';
import '/app/features/map/domain/entities/zone_item.dart';
import '/app/features/map/domain/use_cases/get_gis_data.dart';
import '/app/features/map/domain/use_cases/get_zones.dart';
import '/app/features/map/domain/use_cases/validate_point.dart';
import '/app/features/select_activity/domain/entities/activites_page_params.dart';
import '/app/features/select_activity/domain/entities/activity_details_page_params.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'map_event.dart';

part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final GetZonesUC _getZonesUC;
  final ValidatePointUC _validatePointUC;
  final GetGISDataUC _getGISDataUC;
  final GetImtethalLayer _getImtethalLayer;

  final ActivityDetailsPageParams args;

  MapBloc({required this.args})
      : _getZonesUC = GetZonesUC(repository: sl()),
        _validatePointUC = ValidatePointUC(repository: sl()),
        _getGISDataUC = GetGISDataUC(repository: sl()),
        _getImtethalLayer = GetImtethalLayer(repository: sl()),
        super(const MapState()) {
    on<GetZonesEvent>(getZonesHandler);
    on<ValidatePointEvent>(validatePointHandler);
    on<GetGISDataEvent>(getGISDataHandler);
    on<ClearGISDataEvent>(clearGISDataHandler);
    on<GetLayersEvent>(getLayersHandler);
  }

  void getLayersHandler(GetLayersEvent event, Emitter emit) async {
    emit(state.copyWith(layerStatus: BlocStatus.loading));

    final failureOrSuccess = await _getImtethalLayer.call(MapRequestParams(
      layer: GISMapLayers.BSAimtithalBuildingsCertificateL,
      southWestLongitude: event.southWestLongitude,
      southWestLlatitude: event.southWestLlatitude,
      northEastLongitude: event.northEastLongitude,
      northEastLatitude: event.northEastLatitude,
    ));

    await failureOrSuccess.fold(
      (failure) async {
        print(failure);
        emit(state.copyWith(
          layerStatus: BlocStatus.failure,
          errorMessage: (failure as ServerFailure).errorMessage,
        ));
      },
      (success) async {
        print(success);
        emit(state.copyWith(
          layerStatus: BlocStatus.success,
          layerData: success,
        ));
      },
    );

    emit(state.copyWith(layerStatus: BlocStatus.success));
  }

  void clearGISDataHandler(ClearGISDataEvent event, Emitter emit) async {
    emit(state.copyWith(gisDataStatus: BlocStatus.loading));

    emit(state.copyWith(
      gisDataStatus: BlocStatus.initial,
      clearGISData: true,
    ));
  }

  void getZonesHandler(GetZonesEvent event, Emitter emit) async {
    emit(state.copyWith(zonesStatus: BlocStatus.loading));

    final failureOrSuccess = await _getZonesUC(GetZonesRequest(
        serviceTypeId: 1004,
        longitude: event.lon,
        latitude: event.lat,
        activityId: args.activityId!.id));
    await failureOrSuccess.fold(
      (failure) async {
        print(failure);
        emit(state.copyWith(zonesStatus: BlocStatus.closeLoading));
        emit(state.copyWith(
          zonesStatus: BlocStatus.failure,
          errorMessage: (failure as ServerFailure).errorMessage,
        ));
      },
      (success) async {
        print(success);
        emit(state.copyWith(
          zonesStatus: BlocStatus.success,
          zones: success,
        ));
      },
    );
  }

  void validatePointHandler(ValidatePointEvent event, Emitter emit) async {
    emit(state.copyWith(validatePointStatus: BlocStatus.loading));

    final failureOrSuccess = await _validatePointUC(ValidatePointRequest(
        requestTypeId: 1004,
        x: event.lon.toString(),
        y: event.lat.toString(),
        activities: [args.activityId!.id]));
    await failureOrSuccess.fold(
      (failure) async {
        print(failure);
        emit(state.copyWith(validatePointStatus: BlocStatus.closeLoading));
        emit(state.copyWith(
          validatePointStatus: BlocStatus.failure,
          errorMessage: (failure as ServerFailure).errorMessage,
        ));

        CommonFunctions.showError((failure).errorMessage);
      },
      (success) async {
        emit(state.copyWith(
          validatePointStatus: BlocStatus.success,
          valiadtePoints: success,
        ));
        bool valid = false;
        for (var element in success) {
          if (element.allowed == true) {
            valid = true;
            break;
          }
        }
        if (success.isEmpty) {
          valid = true;
        }
        if (valid)
          add(GetGISDataEvent(lat: event.lat, lon: event.lon));
        else {
          CommonFunctions.showError(
              "منطقة حظر! لا يمكن مزاولة هذا النشاط في هذه المنطقة.");
        }
      },
    );
  }

  void getGISDataHandler(GetGISDataEvent event, Emitter emit) async {
    emit(state.copyWith(gisDataStatus: BlocStatus.loading));

    final failureOrSuccess = await _getGISDataUC(GISDataRequest(
      lon: event.lon,
      lat: event.lat,
    ));
    await failureOrSuccess.fold(
      (failure) async {
        print(failure);
        emit(state.copyWith(gisDataStatus: BlocStatus.closeLoading));
        emit(state.copyWith(
          gisDataStatus: BlocStatus.failure,
          errorMessage: (failure as ServerFailure).errorMessage,
        ));
      },
      (success) async {
        print(success);
        emit(state.copyWith(
            gisDataStatus: BlocStatus.success,
            gisDataResponse: success,
            gisDataRequest: GISDataRequest(
              lon: event.lon,
              lat: event.lat,
            )));
      },
    );
  }
}
