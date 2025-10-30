import '../../../select_activity/domain/use_cases/get_work_flow.dart';
import '../../domain/entities/violation_details_vd_request_params.dart';
import '../../domain/use_cases/violation_details_vd.dart';
import '/app/core/dependency_injection/dependency_injection_exports.dart';
import '/app/core/errors/errors_exports.dart';
import '/app/core/services/services_exports.dart';
import '/app/core/utils/utils_exports.dart';
import '/app/features/details/domain/entities/entity_activity_details_request_params.dart';
import '/app/features/details/domain/entities/regulation_request_params.dart';
import '/app/features/details/domain/use_cases/get_entity_activity_details.dart';
import '/app/features/details/domain/use_cases/get_regulations.dart';
import '/app/features/details/presentation/bloc/details_event.dart';
import '/app/features/details/presentation/bloc/details_state.dart';
import '/app/features/select_activity/domain/entities/activity_details_page_params.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../data/models/entity_violation_activity_details_model.dart';
import '../../domain/entities/entity_violation_activity_details_request_params.dart';
import '../../domain/entities/entity_violation_activity_request_params.dart';
import '../../domain/use_cases/get_violation_details.dart';
import '../../domain/use_cases/get_violation_entity_activity_detailes.dart';
import '../widgets/tabs/third/Details.dart';
//import 'package:balady_plus/app/features/_shared_feature_/balady_features/services/services.dart';

class DetailsBloc extends Bloc<DetailsEvent, DetailsState> {
  ActivityDetailsPageParams args;
  final GetRegulationsUc _getRegulationsUc;
  final GetEntityActivityDetailssUc _getEntityActivityDetailssUc;
  final GetViolationEntityActivityDetailsUC _getViolationEntityActivityDetailsUC;

  final GetViolationDetailsUC _getViolationDetails;

  final GetViolationVDUC _getViolationVD;

  final GetWorkFlowUc _getWorkFlowUc;

  DetailsBloc({required this.args})
      : _getViolationVD = GetViolationVDUC(repository: sl()),
        _getRegulationsUc = GetRegulationsUc(repository: sl()),
        _getEntityActivityDetailssUc = GetEntityActivityDetailssUc(repository: sl()),
        _getViolationEntityActivityDetailsUC = GetViolationEntityActivityDetailsUC(repository: sl()),
        _getViolationDetails = GetViolationDetailsUC(repository: sl()),
        _getWorkFlowUc = GetWorkFlowUc(repository: sl()),
        super(DetailsState()) {
    on<GetRegulationsEvent>(_getRegulations);
    on<GetEntityActivityDetailsEvent>(_getEntityActivityDetails);
    on<GetViolationsListEvent>(_getViolationsList);
    on<GetViolationDetailsEvent>(_getViolationDetailsHanlder);
    on<GetViolationVD>(_getVDViolation);
    add(GetEntityActivityDetailsEvent());
  }

  void _getViolationDetailsHanlder(GetViolationDetailsEvent event, Emitter emit) async {
    showModalBottomSheet(
      backgroundColor: const Color(0xff000000),
      isScrollControlled: true,
      context: NavigationService.navigatorKey.currentContext!,
      builder: (BuildContext context) => ViolationDetails(
        args: args,
        linkId: event.item.linkId ?? "",
      ),
    );

    return;
    emit(state.copyWith(violationDetailsStatus: BlocStatus.loading));
    final result = await _getViolationDetails(EntityViolationActivityDetailsRequestParams(
        activityID: args.activityId?.id ?? 0,
        violationID: event.item.linkId ?? "",
        latitude: args.gisRequest?.lat ?? 0,
        longitude: args.gisRequest?.lon ?? 0,
        municipalityId: args.gisData?.municipalityId ?? "",
        submunicipalityId: args.gisData?.subMunicipalityId ?? "",
        isVillage: true,
        noOfOccurences: 1));

    result.fold((failure) {
      emit(state.copyWith(
          violationDetailsStatus: BlocStatus.failure, regulationErrorMsg: (failure as ServerFailure).errorMessage));
    }, (success) {
      emit(state.copyWith(violationDetailsStatus: BlocStatus.success));

      showModalBottomSheet(
        backgroundColor: const Color(0xff000000),
        isScrollControlled: true,
        context: NavigationService.navigatorKey.currentContext!,
        builder: (BuildContext context) => ViolationDetails(
          args: args,
          linkId: event.item.linkId ?? "",
        ),
      );
    });
  }

  void _getViolationsList(GetViolationsListEvent event, Emitter emit) async {
    if (state.violationStatus == BlocStatus.success) return;
    emit(state.copyWith(violationStatus: BlocStatus.loading));
    final result = await _getViolationEntityActivityDetailsUC(EntityViolationActivityRequestParams(
        activityId: args.activityId?.id ?? 0,
        latitude: args.gisRequest?.lat ?? 0,
        longitude: args.gisRequest?.lon ?? 0,
        municipalityId: args.gisData?.municipalityId ?? "",
        submunicipalityId: args.gisData?.subMunicipalityId ?? "",
        isVillage: args.gisData?.isVillage ?? false));

    result.fold((failure) {
      emit(state.copyWith(
          violationStatus: BlocStatus.failure, regulationErrorMsg: (failure as ServerFailure).errorMessage));
    }, (success) {
      emit(state.copyWith(violationStatus: BlocStatus.success, violations: success));
    });
  }

  void _getRegulations(GetRegulationsEvent event, Emitter emit) async {
    if (state.regulationStatus == BlocStatus.success) return;
    emit(state.copyWith(regulationStatus: BlocStatus.loading));
    final result = await _getRegulationsUc(RegulationRequestParams(
        activityId: args.activityId?.id ?? 0,
        lat: args.gisRequest?.lat ?? 0,
        lng: args.gisRequest?.lon ?? 0,
        serviceType: 1004,
        area: (args.suggestedArea?.to ?? args.suggestedArea?.from ?? 0).toDouble()));

    result.fold((failure) {
      emit(state.copyWith(
          regulationStatus: BlocStatus.failure, regulationErrorMsg: (failure as ServerFailure).errorMessage));
    }, (success) {
      emit(state.copyWith(regulationStatus: BlocStatus.success, regulationResponse: success));
    });
  }

  void _getEntityActivityDetails(GetEntityActivityDetailsEvent event, Emitter emit) async {
    try {
      if (state.entityActivityDetailsStatus == BlocStatus.success) return;
      emit(state.copyWith(entityActivityDetailsStatus: BlocStatus.loading));
      final result = await _getEntityActivityDetailssUc(EntityActivityDetailRequestParams(
          mainActivityId: args.activityId?.id ?? 0,
          latitude: args.gisRequest?.lat ?? 0,
          longitude: args.gisRequest?.lon ?? 0,
          serviceType: 1004,
          shopArea: ((args.suggestedArea?.to ?? args.suggestedArea?.from) ?? 0).toDouble()));

      result.fold((failure) {
        emit(state.copyWith(
            entityActivityDetailsStatus: BlocStatus.failure,
            entityActivityDetailsErrorMsg: (failure as ServerFailure).errorMessage));
      }, (success) {
        args = args.copyWith(entityActivityDetailsResponse: success);
        emit(state.copyWith(entityActivityDetailsStatus: BlocStatus.success, entityActivityDetailsResponse: success));

        sharedPrefs.saveRecentlyOpened(args);
      });
    } catch (ex) {}
  }

  void _getVDViolation(GetViolationVD event, Emitter emit) async {
    print("GGGGHHH ${args.gisData?.municipalityId} ${args.gisData?.subMunicipalityId}");
    emit(state.copyWith(vdViolationStatus: BlocStatus.loading));
    final result = await _getViolationVD(ViolationDetailsVdRequestParams(
        activityId: args.activityId?.id ?? 0,
        latitude: args.gisRequest?.lat ?? 0,
        longitude: args.gisRequest?.lon ?? 0,
        municipalityId: args.gisData?.municipalityId ?? "",
        submunicipalityId: args.gisData?.subMunicipalityId ?? "",
        isVillage: args.gisData?.isVillage ?? false));

    result.fold((failure) {
      emit(state.copyWith(
          vdViolationStatus: BlocStatus.failure, regulationErrorMsg: (failure as ServerFailure).errorMessage));
    }, (success) {
      emit(state.copyWith(vdViolationStatus: BlocStatus.success, vdViolationList: success));
    });
  }

  Future<String?> getComplinaceData(BuildContext context) async {
    return "";
    /*  final String? d = await BaladyServices.getBuildingCompliance(
        context, args.gisRequest!.lat, args.gisRequest!.lon);
    return d;*/
  }
}
