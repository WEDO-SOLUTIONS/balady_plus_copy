import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/etmam_app/core/errors/failures.dart';
import 'package:balady_plus/etmam_app/core/services/services_exports.dart';
import 'package:balady_plus/etmam_app/core/utils/common_properties.dart';
import 'package:balady_plus/etmam_app/features/home/home_exports.dart'
    show
        EtmamSubServicesPage,
        MainServiceResponse,
        SubServicePageArgs,
        SubServiceParams;
import 'package:balady_plus/app/core/utils/utils_exports.dart' show BlocStatus;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:balady_plus/etmam_app/features/home/home_exports.dart'
    show
        GetMainServices,
        MainServiceResponse,
        MainServiceParams,
        GetSubService,
        SubServiceParams;

import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/sub_services/sub_services_response.dart';
part 'main_services_event.dart';
part 'main_services_state.dart';

class MainServicesBloc extends Bloc<MainServicesEvent, MainServicesState> {
  final GetSubService _getSubService;
  final GetMainServices _getMainServices;
  final String classificationId;

  MainServicesBloc(
      {required MainServiceResponse mainServiceResponse,
      required GetSubService getSubService,
      required GetMainServices getMainServices,
      required this.classificationId})
      : _getSubService = getSubService,
        _getMainServices = getMainServices,
        super(MainServicesState(mainServiceResponse: mainServiceResponse)) {
    on<MainServicesEvent>((event, emit) {});
    on<GetMainServiceEvent>(_getMainServicesHandler);
    on<GetSubServiceEvent>(_getSubServicesHandler);

    add(GetMainServiceEvent(
        params: MainServiceParams(
      cityId: CommonProperties.cityId,
      pageIndex: "1",
      pageSize: "30",
    )));
  }

  Future<void> _getMainServicesHandler(
      GetMainServiceEvent e, Emitter emitter) async {
    emitter(state.copyWith(blocStatus: BlocStatus.loading));

    final failureOrSuccess = await _getMainServices(e.params);

    failureOrSuccess.fold((failure) {
      emitter(state.copyWith(
        blocStatus: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) {
      emitter(state.copyWith(
        blocStatus: BlocStatus.success,
        mainServiceResponse: success.data?.result,
        errorMessage: "",
      ));
    });
  }

  Future<void> _getSubServicesHandler(
      GetSubServiceEvent e, Emitter emitter) async {
    emitter(state.copyWith(blocStatus: BlocStatus.loading));

    final failureOrSuccess = await _getSubService(e.params);

    failureOrSuccess.fold(
      (failure) {
        emitter(state.copyWith(
          blocStatus: BlocStatus.failure,
          errorMessage: (failure as ServerFailure).errorMessage,
        ));
      },
      (success) {
        emitter(state.copyWith(
          blocStatus: BlocStatus.success,
          errorMessage: "",
        ));

        // Navigate to subservice screen

// NavigationService.navigatorKey.currentContext!
        // NavigationService.pushNamed(
        //   routeName: EtmamRoutesNames.subServicesPage,
        //   args: SubServicePageArgs(
        //       mainServiceName: e.params.mainServiceName,
        //       subServiceResponse: success.data!.result!),
        // );

        //show a bottom sheet with the sub services as a grid view
      },
    );
  }
}
