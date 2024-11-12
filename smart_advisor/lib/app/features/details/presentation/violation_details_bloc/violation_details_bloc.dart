import 'package:smart_advisor/app/features/details/presentation/violation_details_bloc/violation_details_state.dart';

import '../../domain/use_cases/violation_details_vd.dart';
import '/app/core/dependency_injection/dependency_injection_exports.dart';
import '/app/core/errors/errors_exports.dart';
import '/app/core/services/services_exports.dart';
import '/app/core/utils/utils_exports.dart';
import '/app/features/select_activity/domain/entities/activity_details_page_params.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/entity_violation_activity_details_request_params.dart';
import '../../domain/entities/entity_violation_activity_request_params.dart';
import '../../domain/use_cases/get_violation_details.dart';
import '../../domain/use_cases/get_violation_entity_activity_detailes.dart';
import '../widgets/tabs/third/Details.dart';
import 'violation_details_event.dart';

class ViolationDetailsBloc
    extends Bloc<ViolationDetailsEvent, ViolationDetailsState> {
  ActivityDetailsPageParams args;
  final String linkId;

  final GetViolationDetailsUC _getViolationDetails;

  ViolationDetailsBloc({required this.args, required this.linkId})
      : _getViolationDetails = GetViolationDetailsUC(repository: sl()),
        super(ViolationDetailsState()) {
    on<GetViolationDetailsEvent>(_getViolationDetailsHanlder);
    add(GetViolationDetailsEvent(noOfOccurences: 1));
  }

  void _getViolationDetailsHanlder(
      GetViolationDetailsEvent event, Emitter emit) async {
    emit(state.copyWith(
        violationDetailsStatus: BlocStatus.loading,
        noOfOccurences: event.noOfOccurences));
    final result = await _getViolationDetails(
        EntityViolationActivityDetailsRequestParams(
            activityID: args.activityId?.id ?? 0,
            violationID: linkId ?? "",
            latitude: args.gisRequest?.lat ?? 0,
            longitude: args.gisRequest?.lon ?? 0,
            municipalityId: args.gisData?.municipalityId ?? "",
            submunicipalityId: args.gisData?.subMunicipalityId ?? "",
            isVillage: args.gisData?.isVillage ?? false,
            noOfOccurences: event.noOfOccurences));

    result.fold((failure) {
      emit(state.copyWith(
          violationDetailsStatus: BlocStatus.failure,
          regulationErrorMsg: (failure as ServerFailure).errorMessage));
    }, (success) {
      emit(state.copyWith(
          violationDetailsStatus: BlocStatus.success, response: success));
    });
  }
}
