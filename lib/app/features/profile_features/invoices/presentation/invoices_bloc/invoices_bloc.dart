import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/errors/errors_exports.dart'
    show NoDataFoundFailure, ServerFailure;
import '../../../../../core/services/services_exports.dart' show NoParams;
import '../../../../../core/utils/utils_exports.dart'
    show BlocRequestStatus, PaginationConstants, SortType;
import '../../../requests/requests_exports.dart'
    show
        GetMunicipalities,
        GetSubMunicipalities,
        MunicipalityEntity,
        SubMunicipalityEntity,
        SubMunicipalityParams;
import '../../invoices_exports.dart'
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

      final failureOrSuccess = await getInvoices(
        InvoicesPrams(
          page: state.page,
          size: PaginationConstants.limit,
          invoiceNumber: state.invoiceNumberQuery,
          creationDate: state.selectedInvoiceDate?.toIso8601String(),
          dashboardStatusId: state.selectedInvoiceStatus?.id.toString(),
          municipalityId: state.selectedMunicipality?.id.toString(),
          subMunicipalityId: state.selectedSubMunicipality?.id.toString(),
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

    on<SearchInvoicesEvent>((event, emit) async {
      emit(
        state.copyWith(invoiceNumberQuery: event.query),
      );
      add(GetInvoicesEvent());
    });

    on<InvoicesLoadLookupsEvent>((event, emit) async {
      if (state.invoiceTypesStatus == BlocRequestStatus.initial) {
        add(GetInvoiceTypesEvent());
      }
      if (state.invoiceStatusesStatus == BlocRequestStatus.initial) {
        add(GetInvoiceStatusesEvent());
      }
      if (state.municipalitiesStatus == BlocRequestStatus.initial) {
        add(GetMunicipalitiesEvent());
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
          selectedInvoiceStatus: event.invoiceStatus,
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
          selectedSubMunicipality: event.subMunicipality,
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
          selectedInvoiceType: event.invoiceType,
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
          selectedInvoiceSubType: event.invoiceSubtype,
        ),
      );
    });

    on<InvoicesLoadMoreEvent>((event, emit) async {
      if (state.invoicesStatus == BlocRequestStatus.submissionGetLoading ||
          !state.noMoreData) {
        return;
      }
      emit(
        state.copyWith(
          page: state.page + 1,
        ),
      );
      add(GetInvoicesEvent());
    });

    //InvoiceDateSelectedEvent
    on<InvoiceDateSelectedEvent>((event, emit) async {
      emit(
        state.copyWith(
          selectedInvoiceDate: event.date,
        ),
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
      emit(state.clearFilters());
      add(GetInvoicesEvent());
    });

    on<ApplyInvoicesFiltersEvent>((event, emit) async {
      emit(state.copyWith(
        page: 0,
      ));
      add(GetInvoicesEvent());
    });
  }
}
