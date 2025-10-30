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
import '../../requests_exports.dart'
    show
        GetMunicipalities,
        GetRequestStatuses,
        GetRequestSubTypes,
        GetRequestTypes,
        GetRequests,
        GetSubMunicipalities,
        MunicipalityEntity,
        RequestEntity,
        RequestStatusEntity,
        RequestSubTypeEntity,
        RequestSubTypeParams,
        RequestTypeEntity,
        RequestsPrams,
        SubMunicipalityEntity,
        SubMunicipalityParams;

part 'requests_event.dart';
part 'requests_state.dart';

class RequestsBloc extends Bloc<RequestsEvent, RequestsState> {
  final GetRequests getRequests;
  final GetRequestTypes getRequestTypes;
  final GetRequestStatuses getRequestStatuses;
  final GetMunicipalities getMunicipalities;
  final GetSubMunicipalities getSubMunicipalities;
  final GetRequestSubTypes getRequestSubTypes;
  final GetCRMRequests getCRMRequests;

  RequestsBloc({
    required this.getRequests,
    required this.getRequestTypes,
    required this.getRequestStatuses,
    required this.getMunicipalities,
    required this.getSubMunicipalities,
    required this.getRequestSubTypes,
  })  : getCRMRequests = GetCRMRequests(repository: sl()),
        super(const RequestsState()) {
    on<GetRequestsEvent>((event, emit) async {
      emit(
        state.copyWith(requestsStatus: BlocRequestStatus.submissionGetLoading),
      );

      final unifiedNationalNumber =
          CommonProperties.selectedDelegator?.unifiedNationalNumber;
      final identityNumber = CommonProperties.selectedDelegator?.crNumber;

      final failureOrSuccess = await getRequests(
        RequestsPrams(
          unifiedNationalNumber: unifiedNationalNumber,
          identityNumber: identityNumber,
          page: state.page,
          size: PaginationConstants.limit,
          requestNumber: state.requestNumberQuery,
          creationDate: state.selectedRequestDate?.toIso8601String(),
          dashboardStatusId: state.selectedRequestStatus?.id.toString(),
          municipalityId: state.selectedMunicipality?.id.toString(),
          subMunicipalityId: state.selectedSubMunicipality?.id.toString(),
          productId: state.selectedRequestType?.id.toString(),
          requestTypeId: state.selectedRequestSubType?.id.toString(),
          sort: state.sortType,
        ),
      );

      failureOrSuccess.fold(
        (failure) {
          if (failure is NoDataFoundFailure) {
            emit(
              state.copyWith(
                requestsStatus: BlocRequestStatus.submissionGetSuccess,
                noMoreData: true,
                requests: state.page == 0 ? [] : state.requests,
              ),
            );
            return;
          }
          emit(
            state.copyWith(
              requestsStatus: BlocRequestStatus.submissionGetFailure,
              errorMessage: (failure as ServerFailure).errorMessage,
            ),
          );
        },
        (requests) {
          List<RequestEntity> newRequests = [];
          if (state.page != 0) {
            newRequests.addAll(state.requests);
          }
          newRequests.addAll(requests);
          emit(
            state.copyWith(
              requestsStatus: BlocRequestStatus.submissionGetSuccess,
              requests: newRequests,
            ),
          );
        },
      );
    });

    on<SearchRequestsEvent>((event, emit) async {
      emit(
        state.copyWith(requestNumberQuery: event.query),
      );
      add(GetRequestsEvent());
    });

    on<RequestsLoadLookupsEvent>((event, emit) async {
      if (state.requestTypesStatus == BlocRequestStatus.initial) {
        add(GetRequestTypesEvent());
      }
      if (state.requestStatusesStatus == BlocRequestStatus.initial) {
        add(GetRequestStatusesEvent());
      }
      if (state.municipalitiesStatus == BlocRequestStatus.initial) {
        add(GetMunicipalitiesEvent());
      }
    });

    on<GetRequestStatusesEvent>((event, emit) async {
      emit(
        state.copyWith(
          requestStatusesStatus: BlocRequestStatus.submissionGetLoading,
        ),
      );

      final failureOrSuccess = await getRequestStatuses(NoParams());

      failureOrSuccess.fold(
        (failure) {
          emit(
            state.copyWith(
              requestStatusesStatus: BlocRequestStatus.submissionGetFailure,
              errorMessage: (failure as ServerFailure).errorMessage,
            ),
          );
        },
        (requestStatuses) {
          emit(
            state.copyWith(
              requestStatusesStatus: BlocRequestStatus.submissionGetSuccess,
              requestStatuses: requestStatuses,
            ),
          );
        },
      );
    });

    on<RequestStatusSelectedEvent>((event, emit) async {
      emit(
        state.copyWith(
          selectedRequestStatus: Nullable(event.requestStatus),
        ),
      );
    });

    on<GetMunicipalitiesEvent>((event, emit) async {
      emit(
        state.copyWith(
          municipalitiesStatus: BlocRequestStatus.submissionGetLoading,
        ),
      );

      final failureOrSuccess = await getMunicipalities(NoParams());

      failureOrSuccess.fold(
        (failure) {
          emit(
            state.copyWith(
              municipalitiesStatus: BlocRequestStatus.submissionGetFailure,
              errorMessage: (failure as ServerFailure).errorMessage,
            ),
          );
        },
        (municipalities) {
          emit(
            state.copyWith(
              municipalitiesStatus: BlocRequestStatus.submissionGetSuccess,
              municipalities: municipalities,
            ),
          );
        },
      );
    });

    on<MunicipalitySelectedEvent>((event, emit) async {
      if (state.selectedMunicipality?.id == event.municipality.id) {
        return;
      }
      add(GetSubMunicipalitiesEvent(municipality: event.municipality));
      emit(
        state.copyWith(
          selectedMunicipality: Nullable(event.municipality),
        ),
      );
    });

    on<GetSubMunicipalitiesEvent>((event, emit) async {
      if (state.selectedMunicipality == null) {
        return;
      }
      emit(
        state.copyWith(
          subMunicipalitiesStatus: BlocRequestStatus.submissionGetLoading,
        ),
      );

      final failureOrSuccess = await getSubMunicipalities(
        SubMunicipalityParams(
          id: state.selectedMunicipality!.municipalId,
        ),
      );

      failureOrSuccess.fold(
        (failure) {
          emit(
            state.copyWith(
              subMunicipalitiesStatus: BlocRequestStatus.submissionGetFailure,
              errorMessage: (failure as ServerFailure).errorMessage,
            ),
          );
        },
        (subMunicipalities) {
          emit(
            state.copyWith(
              subMunicipalitiesStatus: BlocRequestStatus.submissionGetSuccess,
              subMunicipalities: subMunicipalities,
            ),
          );
        },
      );
    });

    on<SubMunicipalitySelectedEvent>((event, emit) async {
      emit(
        state.copyWith(
          selectedSubMunicipality: Nullable(event.subMunicipality),
        ),
      );
    });

    on<GetRequestTypesEvent>((event, emit) async {
      emit(
        state.copyWith(
          requestTypesStatus: BlocRequestStatus.submissionGetLoading,
        ),
      );

      final failureOrSuccess = await getRequestTypes(NoParams());

      failureOrSuccess.fold(
        (failure) {
          emit(
            state.copyWith(
              requestTypesStatus: BlocRequestStatus.submissionGetFailure,
              errorMessage: (failure as ServerFailure).errorMessage,
            ),
          );
        },
        (requestTypes) {
          emit(
            state.copyWith(
              requestTypesStatus: BlocRequestStatus.submissionGetSuccess,
              requestTypes: requestTypes,
            ),
          );
        },
      );
    });

    on<RequestTypeSelectedEvent>((event, emit) async {
      if (state.selectedRequestType?.id == event.requestType.id) {
        return;
      }
      add(GetRequestSubtypesEvent(requestType: event.requestType));
      emit(
        state.copyWith(
          selectedRequestType: Nullable(event.requestType),
        ),
      );
    });

    on<GetRequestSubtypesEvent>((event, emit) async {
      if (state.selectedRequestType == null) {
        return;
      }
      emit(
        state.copyWith(
          requestSubTypesStatus: BlocRequestStatus.submissionGetLoading,
        ),
      );

      final failureOrSuccess = await getRequestSubTypes(
        RequestSubTypeParams(
          id: state.selectedRequestType!.id,
        ),
      );

      failureOrSuccess.fold(
        (failure) {
          emit(
            state.copyWith(
              requestSubTypesStatus: BlocRequestStatus.submissionGetFailure,
              errorMessage: (failure as ServerFailure).errorMessage,
            ),
          );
        },
        (requestSubTypes) {
          emit(
            state.copyWith(
              requestSubTypesStatus: BlocRequestStatus.submissionGetSuccess,
              requestSubTypes: requestSubTypes,
            ),
          );
        },
      );
    });

    on<RequestSubTypeSelectedEvent>((event, emit) async {
      emit(
        state.copyWith(
          selectedRequestSubType: Nullable(event.requestSubtype),
        ),
      );
    });

    on<RequestsLoadMoreEvent>((event, emit) async {
      if (state.requestsStatus != BlocRequestStatus.submissionGetSuccess ||
          state.noMoreData) {
        return;
      }
      emit(
        state.copyWith(
          page: state.page + 1,
        ),
      );
      add(GetRequestsEvent());
    });

    //RequestDateSelectedEvent
    on<RequestDateSelectedEvent>((event, emit) async {
      emit(
        state.copyWith(
            selectedRequestDate: Nullable(event.date),
            dateForm: Nullable(event.formDate)),
      );
    });

    on<RequestsSortChangedEvent>((event, emit) async {
      emit(
        state.copyWith(
          sortType: event.sortType,
        ),
      );
    });

    on<ClearRequestsFiltersEvent>((event, emit) async {
      emit(state.copyWith(
        selectedRequestStatus: Nullable(null),
        selectedMunicipality: Nullable(null),
        selectedSubMunicipality: Nullable(null),
        selectedRequestType: Nullable(null),
        selectedRequestSubType: Nullable(null),
        selectedRequestDate: Nullable(null),
        sortType: SortType.desc,
        page: 0,
      ));
      add(GetRequestsEvent());
    });

    on<ApplyRequestsFiltersEvent>((event, emit) async {
      emit(state.copyWith(
        page: 0,
      ));
      add(GetRequestsEvent());
    });

    on<ResetRequestsFiltersEvent>((event, emit) async {
      emit(state.copyWith(
        sortType: event.selectedSortType,
        selectedRequestStatus: Nullable(event.selectedRequestStatus),
        selectedMunicipality: Nullable(event.selectedMunicipality),
        selectedSubMunicipality: Nullable(event.selectedSubMunicipality),
        selectedRequestType: Nullable(event.selectedRequestType),
        selectedRequestSubType: Nullable(event.selectedRequestSubType),
        selectedRequestDate: Nullable(event.selectedRequestDate),
        dateForm: Nullable(event.dateForm),
      ));
    });

    on<GetCRMRequestEvent>((event, emit) async {
      emit(
        state.copyWith(
          crmRequestsStatus: BlocRequestStatus.submissionGetLoading,
          crmRequestType: event.crmRequestType,
        ),
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

    on<SearchCRMRequestsEvent>((event, emit) async {
      emit(
        state.copyWith(
          crmRequestsStatus: BlocRequestStatus.submissionGetLoading,
        ),
      );

      var filtredRequest =
          state.crmRequests?.incidentRequestList?.where((element) {
        if (element.getRequestType() == state.crmRequestType &&
            element.getId().contains(event.query)) return true;
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
