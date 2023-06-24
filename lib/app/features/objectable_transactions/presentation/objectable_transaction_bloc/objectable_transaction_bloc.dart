import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/dependency_injection/injection_container.dart';
import '../../../../core/errors/errors_exports.dart'
    show NoDataFoundFailure, ServerFailure;
import '../../../../core/services/services_exports.dart' show NoParams;
import '../../../../core/utils/utils_exports.dart'
    show
        BlocRequestStatus,
        CommonProperties,
        Nullable,
        PaginationConstants,
        SortType;
import '../../objections_exports.dart'
    show
        GetObjectionRequests,
        GetRequestStatuses,
        GetRequestSubTypes,
        GetRequestTypes,
        ObjectableTransactionsEntity,
        TransactionsRequestsPrams,
        RequestStatusEntity,
        RequestSubTypeEntity,
        RequestSubTypeParams,
        RequestTypeEntity;

part 'objectable_transaction_event.dart';
part 'objectable_transaction_state.dart';

class ObjectableTransactionBloc
    extends Bloc<ObjectableTransactionEvent, ObjectableTransactionState> {
  final GetObjectionRequests getRequests;
  final GetRequestTypes getRequestTypes;
  final GetRequestStatuses getRequestStatuses;
  final GetRequestSubTypes getRequestSubTypes;

  ObjectableTransactionBloc()
      : getRequests = GetObjectionRequests(repository: sl()),
        getRequestTypes = GetRequestTypes(repository: sl()),
        getRequestStatuses = GetRequestStatuses(repository: sl()),
        getRequestSubTypes = GetRequestSubTypes(repository: sl()),
        super(const ObjectableTransactionState()) {
    on<GetRequestsEvent>((event, emit) async {
      emit(
        state.copyWith(requestsStatus: BlocRequestStatus.submissionGetLoading),
      );

      final unifiedNationalNumber =
          CommonProperties.selectedDelegator?.unifiedNationalNumber;
      final identityNumber = CommonProperties.selectedDelegator?.crNumber;

      final failureOrSuccess = await getRequests(
        TransactionsRequestsPrams(
          unifiedNationalNumber: unifiedNationalNumber,
          identityNumber: identityNumber,
          page: state.page,
          size: PaginationConstants.limit,
          requestNo: state.requestNumberQuery,
          productId: state.selectedRequestType?.id.toString(),
          requestTypeId: state.selectedRequestSubType?.id.toString(),
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
          List<ObjectableTransactionsEntity> newRequests = [];
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
      emit(state.copyWith(
        selectedRequestStatus: Nullable(null),
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
        selectedRequestType: Nullable(event.selectedRequestType),
        selectedRequestSubType: Nullable(event.selectedRequestSubType),
        selectedRequestDate: Nullable(event.selectedRequestDate),
      ));
    });
  }
}
