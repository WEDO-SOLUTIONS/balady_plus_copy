import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/errors/errors_exports.dart' show ServerFailure;
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
        state.copyWith(requestsStatus: BlocRequestStatus.submissionGetLoading),
      );

      final failureOrSuccess = await getInvoices(
        InvoicesPrams(
          page: state.page,
          size: PaginationConstants.limit,
          requestNumber: state.requestNumberQuery,
        ),
      );

      failureOrSuccess.fold(
        (failure) {
          emit(
            state.copyWith(
              requestsStatus: BlocRequestStatus.submissionGetFailure,
              errorMessage: (failure as ServerFailure).errorMessage,
            ),
          );
        },
        (requests) {
          emit(
            state.copyWith(
              requestsStatus: BlocRequestStatus.submissionGetSuccess,
              requests: requests,
            ),
          );
        },
      );
    });

    on<SearchInvoicesEvent>((event, emit) async {
      emit(
        state.copyWith(requestNumberQuery: event.query),
      );
      add(GetInvoicesEvent());
    });

    on<GetInvoiceStatusesEvent>((event, emit) async {
      emit(
        state.copyWith(
          requestStatusesStatus: BlocRequestStatus.submissionGetLoading,
        ),
      );

      final failureOrSuccess = await getInvoiceStatuses(NoParams());

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

    on<InvoiceStatusSelectedEvent>((event, emit) async {
      emit(
        state.copyWith(
          selectedInvoiceStatus: event.requestStatus,
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

    on<GetInvoiceTypesEvent>((event, emit) async {
      emit(
        state.copyWith(
          requestTypesStatus: BlocRequestStatus.submissionGetLoading,
        ),
      );

      final failureOrSuccess = await getInvoiceTypes(NoParams());

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

    on<InvoiceTypeSelectedEvent>((event, emit) async {
      emit(
        state.copyWith(
          selectedInvoiceType: event.requestType,
        ),
      );
    });

    on<GetInvoiceSubtypesEvent>((event, emit) async {
      if (state.selectedInvoiceType == null) {
        return;
      }
      emit(
        state.copyWith(
          requestSubTypesStatus: BlocRequestStatus.submissionGetLoading,
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

    on<InvoiceSubTypeSelectedEvent>((event, emit) async {
      emit(
        state.copyWith(
          selectedInvoiceSubType: event.requestSubtype,
        ),
      );
    });

    on<InvoicesLoadMoreEvent>((event, emit) async {
      if (state.requestsStatus == BlocRequestStatus.submissionGetLoading ||
          !state.hasReachedMax) {
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
  }
}
