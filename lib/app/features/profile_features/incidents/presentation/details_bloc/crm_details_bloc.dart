import 'package:balady_plus/app/features/profile_features/incidents/domain/use_cases/get_request_details.dart';
import 'package:balady_plus/app/features/profile_features/incidents/presentation/pages/incident_details.dart';
import 'package:balady_plus/app/features/profile_features/requests/domain/entities/crm_request_entity.dart';
import 'package:balady_plus/app/features/profile_features/requests/domain/entities/crm_request_params.dart';
import 'package:balady_plus/app/features/profile_features/requests/domain/use_cases/get_crm_requests.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/dependency_injection/injection_container.dart';
import '../../../../../core/errors/errors_exports.dart'
    show NoDataFoundFailure, ServerFailure;
import '../../../../../core/services/services_exports.dart' show NoParams;
import '../../../../../core/utils/enums/bloc_status.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../../data/models/request_details_response.dart';
import '../../domain/entities/request_details_page_params.dart';
import '../../domain/entities/request_details_response.dart';
import '../../domain/use_cases/get_inc_details.dart';
import '../../domain/use_cases/get_inq_details.dart';
import '../../domain/use_cases/get_msr_details.dart';

part 'crm_details_event.dart';
part 'crm_details_state.dart';

class CrmDetailsBloc extends Bloc<CrmDetailsEvent, CrmDetailsState> {
  final GetIncDetails getIncDetails;
  final GetInqDetails getInqDetails;
  final GetMsrDetails getMsrDetails;
  final GetRequestDetails getRequestDetails;

  CrmDetailsBloc(
      {required RequestsType crmRequestType,
      required RequestDetailsPageParams pageParams})
      : getIncDetails = GetIncDetails(repository: sl()),
        getInqDetails = GetInqDetails(repository: sl()),
        getMsrDetails = GetMsrDetails(repository: sl()),
        getRequestDetails = GetRequestDetails(repository: sl()),
        super(CrmDetailsState(
            crmRequestType: crmRequestType, pageParams: pageParams)) {
    on<GetCRMRequestEvent>((event, emit) async {
      emit(
        state.copyWith(
          crmRequestsStatus: BlocRequestStatus.submissionGetLoading,
        ),
      );
      var failureOrSuccess;

      if (state.crmRequestType != RequestsType.DC ||
          state.crmRequestType != RequestsType.VHR) {
        if (state.crmRequestType == RequestsType.REQ) {
          failureOrSuccess = await getMsrDetails(event.id);
        } else if (state.crmRequestType == RequestsType.INC) {
          failureOrSuccess = await getIncDetails(event.id);
        } else if (state.crmRequestType == RequestsType.INQ) {
          failureOrSuccess = await getInqDetails(event.id);
        }
        failureOrSuccess.fold(
          (failure) {
            if (failure is NoDataFoundFailure) {
              emit(
                state.copyWith(
                  crmRequestsStatus: BlocRequestStatus.submissionGetSuccess,
                ),
              );
              return;
            }
            emit(
              state.copyWith(
                crmRequestsStatus: BlocRequestStatus.submissionGetFailure,
                errorMessage: (failure as ServerFailure).errorMessage,
              ),
            );
          },
          (requests) {
            emit(
              state.copyWith(
                  crmRequestsStatus: BlocRequestStatus.submissionGetSuccess,
                  details: requests),
            );
          },
        );
      } else {
        failureOrSuccess = await getRequestDetails(event.id);
        failureOrSuccess.fold(
          (failure) {
            if (failure is NoDataFoundFailure) {
              emit(
                state.copyWith(
                  crmRequestsStatus: BlocRequestStatus.submissionGetSuccess,
                ),
              );
              return;
            }
            emit(
              state.copyWith(
                crmRequestsStatus: BlocRequestStatus.submissionGetFailure,
                errorMessage: (failure as ServerFailure).errorMessage,
              ),
            );
          },
          (requests) {
            emit(
              state.copyWith(
                  crmRequestsStatus: BlocRequestStatus.submissionGetSuccess,
                  requestDetails: requests),
            );
          },
        );
      }
    });
  }
}
