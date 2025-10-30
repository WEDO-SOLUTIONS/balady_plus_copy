import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/violation_guide/presentation/bloc/violation_event.dart';
import 'package:balady_plus/app/features/violation_guide/presentation/bloc/violation_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/dependency_injection/injection_container.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/constants/route_names.dart';
import '../../../../core/utils/constants/ux_cam_events.dart';
import '../../data/models/establishment_size_response.dart';
import '../../data/models/regualation_cluses_details.dart';
import '../../data/models/regulation_clause_response.dart';
import '../../data/models/violator_response.dart';
import '../../domain/entites/regulation_clauses_details_params.dart';
import '../../domain/entites/regulation_clauses_params.dart';
import '../../domain/usecase/get_establishment_size.dart';
import '../../domain/usecase/get_regulation_clause.dart';
import '../../domain/usecase/get_regulation_clause_details.dart';
import '../../domain/usecase/get_violation_guide_classifications.dart';
import '../../domain/usecase/get_violators.dart';

class ViolationBloc extends Bloc<ViolationEvent, ViolationState> {
  final GetViolators _getViolators;
  final GetEstablishmentSize _establishmentSize;
  final GetViolationGuideClassifications _getViolationGuideClassifications;
  final GetRegulationClause _getRegulationClause;
  final GetRegulationClauseDetails _getRegulationClauseDetails;

  PageController pageController = PageController(initialPage: 0);

  ViolationBloc(
      {RegulationClausesResponse? regulationClausesResponse,
      RegulationClauseDetails? regulationClauseDetails})
      : _getViolators = GetViolators(repository: sl()),
        _establishmentSize = GetEstablishmentSize(repository: sl()),
        _getViolationGuideClassifications =
            GetViolationGuideClassifications(repository: sl()),
        _getRegulationClause = GetRegulationClause(repository: sl()),
        _getRegulationClauseDetails =
            GetRegulationClauseDetails(repository: sl()),
        super((ViolationState(
          selectedIndex: 0,
          status: BlocStatus.initial,
          regulationClausesResponse: regulationClausesResponse,
          details: regulationClauseDetails,
          currentStep: 0,
        ))) {
    on<ViolationEvent>((event, emit) {
      emit(state);
    });
    add(const ViolationEvent());
    on<CategorySelectedEvent>(_categoryHandler);
    on<ChangePageEvent>(_pageChangeHandler);

    on<GetEstablishmentSizeEvent>(_getEstablishmentSizeHanlder);

    on<GetViolatorsEvents>(_getViolatorsHandler);

    on<GetViolationGuideClassificationsEvents>(
        _getGetViolationGuideClassificationsHandler);

    on<GetRegulationClausess>(_getRegulationClausessHandler);

    on<GetRegulationClausesDetails>(_getRegulationClausesDetailsHandler);
  }
  Future<void> _pageChangeHandler(ChangePageEvent e, Emitter emitter) async {
    emitter(state.copyWith(
      currentStep: e.index,
    ));
  }

  Future<void> _categoryHandler(
      CategorySelectedEvent e, Emitter emitter) async {
    int selectedIndex = e.index;

    add(GetRegulationClausesDetails(
        item: state.selectedRegulationClauseItem!,
        refresh: true,
        index: selectedIndex));
  }

  Future<void> _getEstablishmentSizeHanlder(
      GetEstablishmentSizeEvent e, Emitter emitter) async {
    emitter(state.copyWith(establishmentStatus: BlocStatus.loading));

    var failureOrSuccess = await _establishmentSize(NoParams());

    await failureOrSuccess.fold((failure) {
      emitter(state.copyWith(
        establishmentStatus: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) async {
      emitter(state.copyWith(
          establishmentStatus: BlocStatus.success,
          errorMessage: "",
          establishmentSizeResponse: success));

      /*  NavigationService.navigatorKey.currentState!
          .pushNamed(RouteName.objectionsDetailsPage, arguments: success);*/
    });
  }

  Future<void> _getViolatorsHandler(
      GetViolatorsEvents e, Emitter emitter) async {
    emitter(state.copyWith(ViolatorsStatus: BlocStatus.loading));

    var failureOrSuccess = await _getViolators(NoParams());

    await failureOrSuccess.fold((failure) {
      print(failure);
      emitter(state.copyWith(
        ViolatorsStatus: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) async {
      emitter(state.copyWith(
          ViolatorsStatus: BlocStatus.success,
          errorMessage: "",
          violatorResponse: success));

      /*  NavigationService.navigatorKey.currentState!
          .pushNamed(RouteName.objectionsDetailsPage, arguments: success);*/
    });
  }

  Future<void> _getGetViolationGuideClassificationsHandler(
      GetViolationGuideClassificationsEvents e, Emitter emitter) async {
    emitter(state.copyWith(
        classificationStatus: BlocStatus.loading,
        gisParams: e.location,
        selectedEstablishmentSizeItem: Nullable(null)));

    var failureOrSuccess =
        await _getViolationGuideClassifications(e.location ?? state.gisParams!);

    await failureOrSuccess.fold((failure) {
      emitter(state.copyWith(
        classificationStatus: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) async {
      print("Succress ${success.classificationName}");
      emitter(state.copyWith(
        classificationStatus: BlocStatus.success,
        violationClassificationResponse: success,
        errorMessage: "",
      ));

      /*  NavigationService.navigatorKey.currentState!
          .pushNamed(RouteName.objectionsDetailsPage, arguments: success);*/
    });
  }

  Future<void> _getRegulationClausessHandler(
      GetRegulationClausess e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    var failureOrSuccess = await _getRegulationClause(RegulationClausesParams(
        violatorTypeID: state.violatorItem?.violatorIdNumber ?? "",
        classificationID:
            state.violationClassificationResponse?.classificationId ?? "",
        establishmentSizeID: state
                .selectedEstablishmentSizeItem?.establishmentsizeId
                .toString() ??
            ""));

    await failureOrSuccess.fold((failure) {
      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) async {
      emitter(state.copyWith(
        status: BlocStatus.success,
        regulationClausesResponse: success,
        errorMessage: "",
      ));
      CommonFunctions.sendUXCamEvent(
          UXCamEvents.ViolationGuide_Open_Result_Event);

      NavigationService.navigatorKey.currentState!
          .pushNamed(RouteName.violationResultsPage, arguments: this);
    });
  }

  Future<void> _getRegulationClausesDetailsHandler(
      GetRegulationClausesDetails e, Emitter emitter) async {
    emitter(state.copyWith(
      status: BlocStatus.loading,
      selectedRegulationClauseItem: e.item,
    ));

    var failureOrSuccess =
        await _getRegulationClauseDetails(RegulationClauseDetailsParams(
      regulationClauseID: e.item.regulationClauseId,
      establishmentSizeID:
          state.selectedEstablishmentSizeItem?.establishmentsizeId != null
              ? state.selectedEstablishmentSizeItem?.establishmentsizeId
                  .toString()
              : null,
      noofRepetition: e.index != null ? (e.index! + 1).toString() : null,
      classificationID:
          state.violationClassificationResponse?.classificationId ?? "",
    ));

    await failureOrSuccess.fold((failure) {
      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) async {
      emitter(state.copyWith(
        status: BlocStatus.success,
        details: success,
        selectedIndex: e.refresh == false ? 0 : e.index,
        errorMessage: "",
      ));
      if (!e.refresh) {
        NavigationService.navigatorKey.currentState!.pushNamed(
            RouteName.violationRegulationDetailsPage,
            arguments: this);

        CommonFunctions.sendUXCamEvent(
            UXCamEvents.PViolationGuide_Open_Result_Select_Violation_Event);
      }
    });
  }

  void selectViolatorType(ViolatorItem item) {
    emit(state.copyWith(violatorItem: item, currentStep: 1));
    pageController.jumpToPage(1);

    CommonFunctions.sendUXCamEvent(
        UXCamEvents.PViolationGuide_Open_Select_Type_Step_Event);
  }

  void selectEstablishment(EstablishmentSizeItem? item) {
    emit(state.copyWith(selectedEstablishmentSizeItem: Nullable(item)));

    CommonFunctions.sendUXCamEvent(
        UXCamEvents.ViolationGuide_Open_Select_Establishment_Size_Event);
  }
}
