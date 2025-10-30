import 'package:balady_plus/app/features/objectable_transactions/domain/use_cases/get_transaction_details.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/dependency_injection/injection_container.dart';
import '../../../../core/errors/errors_exports.dart'
    show NoDataFoundFailure, ServerFailure;
import '../../../../core/services/services_exports.dart'
    show NavigationService, NoParams;
import '../../../../core/utils/utils_exports.dart'
    show
        BlocRequestStatus,
        CommonProperties,
        DateForm,
        Nullable,
        PaginationConstants,
        RouteName,
        SortType;
import '../../domain/entities/create_objection_page_params.dart';
import '../../domain/entities/transaction_details_params.dart';
import '../../domain/entities/validate_objection_params.dart';
import '../../domain/use_cases/validate_objectable_transactions.dart';
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
  final GetTransactionDetails getTransactionDetails;
  final ValidateObjectableTransaction validateObjectableTransaction;

  ObjectableTransactionBloc()
      : getRequests = GetObjectionRequests(repository: sl()),
        getRequestTypes = GetRequestTypes(repository: sl()),
        getRequestStatuses = GetRequestStatuses(repository: sl()),
        getRequestSubTypes = GetRequestSubTypes(repository: sl()),
        getTransactionDetails = GetTransactionDetails(repository: sl()),
        validateObjectableTransaction =
            ValidateObjectableTransaction(repository: sl()),
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
          violationLastApplyDate: state.selectedRequestDate != null
              ? DateFormat(("yyyy/mm/dd"))
                  .format(state.selectedRequestDate!)
                  .toString()
              : null,
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
          id: state.selectedRequestType!.id!,
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
        dateForm: Nullable(event.dateForm),
      ));
    });

    on<GetTransactionDetailsEvent>(_getTransactionsDetailsHandler);
    on<ValidateObjectionTransactions>(_validateObjectableTransaction);
  }

  Future<void> _validateObjectableTransaction(
      ValidateObjectionTransactions e, Emitter emitter) async {
    emitter(
        state.copyWith(detailsStatus: BlocRequestStatus.submissionGetLoading));

    var failureOrSuccess = await validateObjectableTransaction(
        ValidateObjectionParams(
            applicationId: e.params.applicationId,
            transactionId: e.params.transactionId));

    await failureOrSuccess.fold((failure) {
      emitter(state.copyWith(
        detailsStatus: BlocRequestStatus.submissionGetFailure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) async {
      emitter(state.copyWith(
        detailsStatus: BlocRequestStatus.submissionGetSuccess,
        errorMessage: "",
      ));
      if (success)
        NavigationService.navigatorKey.currentState!
            .pushNamed(RouteName.createObjectionDetails,
                arguments: CreateObjectionPageParams(
                  item: e.params,
                ));
    });
  }

  Future<void> _getTransactionsDetailsHandler(
      GetTransactionDetailsEvent e, Emitter emitter) async {
    emitter(
        state.copyWith(detailsStatus: BlocRequestStatus.submissionGetLoading));

    var failureOrSuccess = await getTransactionDetails(e.params);

    await failureOrSuccess.fold((failure) {
      emitter(state.copyWith(
        detailsStatus: BlocRequestStatus.submissionGetFailure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) async {
      emitter(state.copyWith(
        detailsStatus: BlocRequestStatus.submissionGetSuccess,
        errorMessage: "",
      ));

      if (e.apply) {
        NavigationService.navigatorKey.currentState!.pushNamed(
            RouteName.createObjectionDetails,
            arguments: CreateObjectionPageParams(
                details: success, item: e.params.item));
      } else {
        NavigationService.navigatorKey.currentState!.pushNamed(
            RouteName.transactionDetailsPage,
            arguments: CreateObjectionPageParams(
                details: success, item: e.params.item));
      }
    });
  }
}
