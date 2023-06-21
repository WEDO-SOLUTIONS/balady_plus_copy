import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/errors/errors_exports.dart'
    show NoDataFoundFailure, ServerFailure;
import '../../../../../core/services/services_exports.dart' show NoParams;
import '../../../../../core/utils/utils_exports.dart'
    show BlocRequestStatus, PaginationConstants, SortType;
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

  RequestsBloc({
    required this.getRequests,
    required this.getRequestTypes,
    required this.getRequestStatuses,
    required this.getMunicipalities,
    required this.getSubMunicipalities,
    required this.getRequestSubTypes,
  }) : super(const RequestsState()) {
    on<GetRequestsEvent>((event, emit) async {
      emit(
        state.copyWith(requestsStatus: BlocRequestStatus.submissionGetLoading),
      );

      final failureOrSuccess = await getRequests(
        RequestsPrams(
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
          selectedRequestStatus: event.requestStatus,
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
          selectedMunicipality: event.municipality,
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
          id: state.selectedMunicipality!.id,
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
          selectedSubMunicipality: event.subMunicipality,
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
          selectedRequestType: event.requestType,
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
          selectedRequestSubType: event.requestSubtype,
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
          selectedRequestDate: event.date,
        ),
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
      emit(state.clearFilters());
      add(GetRequestsEvent());
    });

    on<ApplyRequestsFiltersEvent>((event, emit) async {
      emit(state.copyWith(
        page: 0,
      ));
      add(GetRequestsEvent());
    });
  }
}
