import 'dart:convert';

import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:collection/collection.dart';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/dependency_injection/injection_container.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/services/local/navigation_services.dart';
import '../../../../../core/utils/enums/bloc_status.dart';
import '../../../data/model/veichles_list_page_params.dart';
import '../../../domain/entities/vehicle_item.dart';
import '../../../domain/entities/vehicle_item_params.dart';
import '../../../domain/use_cases/get_my_vechicles.dart';
part 'retrieve_vehicles_event.dart';

part 'retrieve_vehicles_state.dart';

class RetrieveVehiclesBloc
    extends Bloc<RetrieveVehiclesEvent, RetrieveVehiclesState> {
  final GetMyVehicles _getMyVehicles;
  final String type;
  List<VehicleItem>? items;
  RetrieveVehiclesBloc({required this.type, this.items})
      : _getMyVehicles = GetMyVehicles(repository: sl()),
        super(RetrieveVehiclesState(vehicleItem: items, type: type)) {
    on<GetMyVehiclesEvent>(_getMyVehiclesRequestsHandler);
    on<ChangeFieldsEvent>(_changeFieldsHandler);
    on<GetViehclesEvent>(_getVehiclesRequestsHandler);
    on<SelectViehclesEvent>(_selectViehclesEvent);
    if (type == "OnBehalfOfMyself") add(GetMyVehiclesEvent());
  }

  Future<void> _changeFieldsHandler(
      ChangeFieldsEvent e, Emitter emitter) async {
    emitter(state.copyWith(
      agentNumber: e.agentNumber,
      carOwnerId: e.carOwnerId,
      deadId: e.deadId,
      crNumber: e.crNumber,
      errorMessage: "",
    ));
  }

  Future<void> _selectViehclesEvent(
      SelectViehclesEvent e, Emitter emitter) async {
    VehicleItem? item = state.vehicleItem?.firstWhere(
      (element) => element.pyId == e.id,
    );
    emitter(state.copyWith(selectedVehicle: item));
  }

  Future<void> _getMyVehiclesRequestsHandler(
      GetMyVehiclesEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));
    final failureOrSuccess = await _getMyVehicles(VehicleItemParams(
        pageNumber: 1,
        pageSize: 100,
        action: "FetchCreateVehicleRecoveryRequest",
        type: type,
        vehicleInquiryOptions: type));

    failureOrSuccess.fold((failure) {
      ServerFailure f = (failure as ServerFailure);
      final BlocStatus status =
          f.errorCode == "CS_API_003" ? BlocStatus.success : BlocStatus.failure;
      emitter(state.copyWith(
        status: status,
        errorMessage: f.errorMessage,
      ));
    }, (success) {
      emitter(state.copyWith(
        status: BlocStatus.success,
        vehicleItem: success.data?.result?.items,
        pageCount: ((success.data?.result?.totalCount ?? 0) / 10).toInt(),
        errorMessage: "",
      ));
    });
  }

  Future<void> _getVehiclesRequestsHandler(
      GetViehclesEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));
    final failureOrSuccess = await _getMyVehicles(VehicleItemParams(
        pageNumber: 1,
        pageSize: 10,
        type: type,
        action: "FetchCreateVehicleRecoveryRequest",
        vehicleInquiryOptions: type,
        agencyNumber: state.agentNumber,
        carOwnerId: state.carOwnerId,
        beneficiaryID: state.deadId,
        commercialRegistrationNumber: state.crNumber));

    failureOrSuccess.fold((failure) {
      String msg = (failure as ServerFailure).errorMessage;
      if (failure.statusCode == 400 && type == "OnBehalfOfDeadPerson")
        msg = ("no_veichles_error_message").tr();

      emitter(state.copyWith(status: BlocStatus.failure, errorMessage: msg));
    }, (success) {
      emitter(state.copyWith(
        status: BlocStatus.success,
        vehicleItem: success.data?.result?.items,
        pageCount: ((success.data?.result?.totalCount ?? 0) / 10).toInt(),
        errorMessage: "",
      ));

      NavigationService.navigatorKey.currentState!.pushNamed(
          RouteName.VeichlesListPage,
          arguments: VeichlesListPageParams(
              type: type, items: success.data?.result?.items));
    });
  }
}
