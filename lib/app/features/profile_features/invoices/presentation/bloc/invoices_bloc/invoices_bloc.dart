import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/errors/errors_exports.dart'
    show NoDataFoundFailure, ServerFailure;
import '../../../../../../core/services/services_exports.dart' show NoParams;
import '../../../../../../core/utils/utils_exports.dart'
    show
        BlocRequestStatus,
        CommonProperties,
        DateForm,
        Nullable,
        PaginationConstants,
        SortType;
import '../../../../requests/requests_exports.dart'
    show GetMunicipalities, GetSubMunicipalities;
import '../../../invoices_exports.dart'
    show
        GetInvoiceStatuses,
        GetInvoiceSubTypes,
        GetInvoiceTypes,
        GetInvoices,
        InvoiceEntity,
        InvoiceStatusEntity,
        InvoiceSubTypeEntity,
        InvoiceSubTypeParams,
        InvoiceTypeEntity,
        InvoicesPrams;

part 'invoices_event.dart';
part 'invoices_state.dart';

class InvoicesBloc extends Bloc<InvoicesEvent, InvoicesState> {
  final GetInvoices getInvoices;
  final GetInvoiceTypes getInvoiceTypes;
  final GetInvoiceStatuses getInvoiceStatuses;
  final GetMunicipalities getMunicipalities;
  final GetSubMunicipalities getSubMunicipalities;
  final GetInvoiceSubTypes getInvoiceSubTypes;

  InvoicesBloc({
    required this.getInvoices,
    required this.getInvoiceTypes,
    required this.getInvoiceStatuses,
    required this.getMunicipalities,
    required this.getSubMunicipalities,
    required this.getInvoiceSubTypes,
  }) : super(const InvoicesState()) {
    on<GetInvoicesEvent>((event, emit) async {
      emit(
        state.copyWith(invoicesStatus: BlocRequestStatus.submissionGetLoading),
      );
      final unifiedNationalNumber =
          CommonProperties.selectedDelegator?.unifiedNationalNumber;
      final identityNumber = CommonProperties.selectedDelegator?.crNumber;

      final failureOrSuccess = await getInvoices(
        InvoicesPrams(
          unifiedNationalNumber: unifiedNationalNumber,
          identityNumber: identityNumber,
          page: state.page,
          size: PaginationConstants.limit,
          requestNumber: state.requestNumberQuery,
          invoiceId: state.invoiceNumberQuery,
          productId: state.selectedInvoiceType?.id.toString(),
          requestTypeId: state.selectedInvoiceSubType?.id.toString(),
          invoiceStatusId: state.selectedInvoiceStatus?.id.toString(),
          sadadDate: state.selectedInvoiceDueDate?.toIso8601String(),
          creationDate: state.selectedInvoiceIssueDate?.toIso8601String(),
          sort: state.sortType,
        ),
      );

      failureOrSuccess.fold(
        (failure) {
          if (failure is NoDataFoundFailure) {
            emit(
              state.copyWith(
                invoicesStatus: BlocRequestStatus.submissionGetSuccess,
                noMoreData: true,
                invoices: state.page == 0 ? [] : state.invoices,
              ),
            );
            return;
          }
          emit(
            state.copyWith(
              invoicesStatus: BlocRequestStatus.submissionGetFailure,
              errorMessage: (failure as ServerFailure).errorMessage,
            ),
          );
        },
        (invoices) {
          List<InvoiceEntity> newList = [];
          if (state.page != 0) {
            newList.addAll(state.invoices);
          }
          newList.addAll(invoices);
          emit(
            state.copyWith(
              invoicesStatus: BlocRequestStatus.submissionGetSuccess,
              invoices: newList,
            ),
          );
        },
      );
    });

    on<SearchWithInvoiceNumberEvent>((event, emit) async {
      emit(
        state.copyWith(
            invoiceNumberQuery:
                Nullable(event.query.isEmpty ? null : event.query)),
      );
    });

    on<SearchWithRequestNumberEvent>((event, emit) async {
      emit(
        state.copyWith(
            requestNumberQuery:
                Nullable(event.query.isEmpty ? null : event.query)),
      );
    });

    on<InvoicesLoadLookupsEvent>((event, emit) async {
      if (state.invoiceTypesStatus == BlocRequestStatus.initial) {
        add(GetInvoiceTypesEvent());
      }
      if (state.invoiceStatusesStatus == BlocRequestStatus.initial) {
        add(GetInvoiceStatusesEvent());
      }
    });

    on<GetInvoiceStatusesEvent>((event, emit) async {
      emit(
        state.copyWith(
          invoiceStatusesStatus: BlocRequestStatus.submissionGetLoading,
        ),
      );

      final failureOrSuccess = await getInvoiceStatuses(NoParams());

      failureOrSuccess.fold(
        (failure) {
          emit(
            state.copyWith(
              invoiceStatusesStatus: BlocRequestStatus.submissionGetFailure,
              errorMessage: (failure as ServerFailure).errorMessage,
            ),
          );
        },
        (invoiceStatuses) {
          emit(
            state.copyWith(
              invoiceStatusesStatus: BlocRequestStatus.submissionGetSuccess,
              invoiceStatuses: invoiceStatuses,
            ),
          );
        },
      );
    });

    on<InvoiceStatusSelectedEvent>((event, emit) async {
      emit(
        state.copyWith(
          selectedInvoiceStatus: Nullable(event.invoiceStatus),
        ),
      );
    });

    on<GetInvoiceTypesEvent>((event, emit) async {
      emit(
        state.copyWith(
          invoiceTypesStatus: BlocRequestStatus.submissionGetLoading,
        ),
      );

      final failureOrSuccess = await getInvoiceTypes(NoParams());

      failureOrSuccess.fold(
        (failure) {
          emit(
            state.copyWith(
              invoiceTypesStatus: BlocRequestStatus.submissionGetFailure,
              errorMessage: (failure as ServerFailure).errorMessage,
            ),
          );
        },
        (invoiceTypes) {
          emit(
            state.copyWith(
              invoiceTypesStatus: BlocRequestStatus.submissionGetSuccess,
              invoiceTypes: invoiceTypes,
            ),
          );
        },
      );
    });

    on<InvoiceTypeSelectedEvent>((event, emit) async {
      if (state.selectedInvoiceType?.id == event.invoiceType.id) {
        return;
      }
      add(GetInvoiceSubtypesEvent(invoiceType: event.invoiceType));

      emit(
        state.copyWith(
          selectedInvoiceType: Nullable(event.invoiceType),
        ),
      );
    });

    on<GetInvoiceSubtypesEvent>((event, emit) async {
      if (state.selectedInvoiceType == null) {
        return;
      }
      emit(
        state.copyWith(
          invoiceSubTypesStatus: BlocRequestStatus.submissionGetLoading,
        ),
      );

      final failureOrSuccess = await getInvoiceSubTypes(
        InvoiceSubTypeParams(
          id: state.selectedInvoiceType!.id,
        ),
      );

      failureOrSuccess.fold(
        (failure) {
          emit(
            state.copyWith(
              invoiceSubTypesStatus: BlocRequestStatus.submissionGetFailure,
              errorMessage: (failure as ServerFailure).errorMessage,
            ),
          );
        },
        (invoiceSubTypes) {
          emit(
            state.copyWith(
              invoiceSubTypesStatus: BlocRequestStatus.submissionGetSuccess,
              invoiceSubTypes: invoiceSubTypes,
            ),
          );
        },
      );
    });

    on<InvoiceSubTypeSelectedEvent>((event, emit) async {
      emit(
        state.copyWith(
          selectedInvoiceSubType: Nullable(event.invoiceSubtype),
        ),
      );
    });

    on<InvoicesLoadMoreEvent>((event, emit) async {
      if (state.invoicesStatus == BlocRequestStatus.submissionGetLoading ||
          state.noMoreData) {
        return;
      }

      emit(
        state.copyWith(
          page: state.page + 1,
        ),
      );
      add(GetInvoicesEvent());
    });

    on<InvoiceDueDateSelectedEvent>((event, emit) async {
      emit(
        state.copyWith(
            selectedInvoiceDueDate: Nullable(event.date),
            dateFormForDueDate: Nullable(event.formDate)),
      );
    });

    on<InvoiceIssueDateSelectedEvent>((event, emit) async {
      emit(
        state.copyWith(
            selectedInvoiceIssueDate: Nullable(event.date),
            dateFormForIssue: Nullable(event.formDate)),
      );
    });

    on<InvoicesSortChangedEvent>((event, emit) async {
      emit(
        state.copyWith(
          sortType: event.sortType,
        ),
      );
    });

    on<ClearInvoicesFiltersEvent>((event, emit) async {
      emit(
        state.copyWith(
          selectedInvoiceType: Nullable(null),
          selectedInvoiceSubType: Nullable(null),
          selectedInvoiceStatus: Nullable(null),
          selectedInvoiceDueDate: Nullable(null),
          selectedInvoiceIssueDate: Nullable(null),
          dateFormForDueDate: Nullable(null),
          dateFormForIssue: Nullable(null),
          invoiceNumberQuery: Nullable(null),
          requestNumberQuery: Nullable(null),
          sortType: SortType.desc,
          page: 0,
        ),
      );
      add(GetInvoicesEvent());
    });

    on<ApplyInvoicesFiltersEvent>((event, emit) async {
      emit(state.copyWith(
        page: 0,
      ));
      add(GetInvoicesEvent());
    });

    on<ResetInvoicesFiltersEvent>((event, emit) async {
      emit(state.copyWith(
        sortType: event.selectedSortType,
        selectedInvoiceType: Nullable(event.selectedInvoiceType),
        selectedInvoiceSubType: Nullable(event.selectedInvoiceSubType),
        selectedInvoiceDueDate: Nullable(event.selectedInvoiceDueDate),
        selectedInvoiceIssueDate: Nullable(event.selectedInvoiceIssueDate),
        selectedInvoiceStatus: Nullable(event.selectedInvoiceStatus),
        invoiceNumberQuery: Nullable(event.invoiceNumberQuery),
        requestNumberQuery: Nullable(event.requestNumberQuery),
        dateFormForDueDate: Nullable(event.dateFormForDueDate),
        dateFormForIssue: Nullable(event.dateFormForIssue),
      ));
    });
  }
}
