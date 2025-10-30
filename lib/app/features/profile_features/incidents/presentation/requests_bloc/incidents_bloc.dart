import 'package:balady_plus/app/features/profile_features/requests/domain/entities/crm_request_entity.dart';
import 'package:balady_plus/app/features/profile_features/requests/domain/entities/crm_request_params.dart';
import 'package:balady_plus/app/features/profile_features/requests/domain/use_cases/get_crm_requests.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/dependency_injection/injection_container.dart';
import '../../../../../core/errors/errors_exports.dart'
    show NoDataFoundFailure, ServerFailure;
import '../../../../../core/services/services_exports.dart' show NoParams;
import '../../../../../core/utils/enums/enums.dart';
import '../../../../../core/utils/utils_exports.dart'
    show
        BlocRequestStatus,
        CommonProperties,
        DateForm,
        Nullable,
        PaginationConstants,
        SortType;

part 'incidents_event.dart';
part 'incidents_state.dart';

class IncidentsBloc extends Bloc<IncidentsEvent, IncidentsState> {
  final GetCRMRequests getCRMRequests;

  IncidentsBloc()
      : getCRMRequests = GetCRMRequests(repository: sl()),
        super(const IncidentsState()) {
    on<GetCRMRequestEvent>((event, emit) async {
      if (state.crmRequestsStatus == BlocRequestStatus.submissionGetLoading)
        return;

      emit(
        state.copyWith(
            crmRequestsStatus: BlocRequestStatus.submissionGetLoading,
            crmRequestType: event.crmRequestType),
      );

      final failureOrSuccess = await getCRMRequests(
        CRMRequestsParams(
          id: CommonProperties.userInfo?.idNo ?? "",
          mobileNumber: CommonProperties.userInfo?.getPhone() ?? "",
        ),
      );

      failureOrSuccess.fold(
        (failure) {
          if (failure is NoDataFoundFailure) {
            emit(
              state.copyWith(
                crmRequestsStatus: BlocRequestStatus.submissionGetSuccess,
                crmRequests: CRMRequestEntity(incidentRequestList: []),
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
          var filtredRequest = requests.incidentRequestList?.where((element) {
            if (element.getRequestType() == event.crmRequestType) return true;
            return false;
          }).toList();

          emit(
            state.copyWith(
              crmRequestsStatus: BlocRequestStatus.submissionGetSuccess,
              crmRequestsList: CRMRequestEntity(
                  totalRecordCount: filtredRequest?.length.toString(),
                  incidentRequestList: filtredRequest ?? []),
              crmRequests: CRMRequestEntity(
                  totalRecordCount: filtredRequest?.length.toString(),
                  incidentRequestList: filtredRequest ?? []),
            ),
          );
        },
      );
    });

    on<SearchCRMIncidentsEvent>((event, emit) async {
      emit(
        state.copyWith(
          crmRequestsStatus: BlocRequestStatus.submissionGetLoading,
        ),
      );

      var filtredRequest =
          state.crmRequests?.incidentRequestList?.where((element) {
        if (element.getRequestType() == state.crmRequestType &&
            element.getId().toLowerCase().contains(event.query.toLowerCase()))
          return true;
        return false;
      }).toList();
      emit(
        state.copyWith(
          crmRequestsStatus: BlocRequestStatus.submissionGetSuccess,
          crmRequestsList: CRMRequestEntity(
              totalRecordCount: filtredRequest?.length.toString(),
              incidentRequestList: filtredRequest ?? []),
        ),
      );

      emit(
        state.copyWith(
          crmRequestsStatus: BlocRequestStatus.submissionGetSuccess,
        ),
      );
    });
  }
}
