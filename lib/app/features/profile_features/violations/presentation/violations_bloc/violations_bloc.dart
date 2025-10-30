import 'package:balady_plus/app/features/profile_features/violations/domain/use_cases/get_violations.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/dependency_injection/injection_container.dart';
import '../../../../../core/errors/errors_exports.dart'
    show NoDataFoundFailure, ServerFailure;
import '../../../../../core/services/services_exports.dart' show NoParams;
import '../../../../../core/utils/utils_exports.dart'
    show
        BlocRequestStatus,
        CommonProperties,
        DateForm,
        Nullable,
        PaginationConstants,
        SortType;
import '../../violations_exports.dart'
    show
        GetInvoiceStatuses,
        GetViolationsStatuses,
        InvoiceStatusesEntity,
        ViolationsEntity,
        ViolationsPrams,
        ViolationsStatusEntity;

part 'violations_event.dart';
part 'violations_state.dart';

class ViolationsBloc extends Bloc<ViolationsEvent, ViolationsState> {
  final GetInvoiceStatuses _getInvoiceStatuses;
  final GetViolationsStatuses _getViolationsStatuses;
  final GetViolations _getViolations;

  ViolationsBloc()
      : _getInvoiceStatuses = GetInvoiceStatuses(repository: sl()),
        _getViolationsStatuses = GetViolationsStatuses(repository: sl()),
        _getViolations = GetViolations(repository: sl()),
        super(const ViolationsState()) {
    on<ViolationsSortChangedEvent>((event, emit) async {
      emit(
        state.copyWith(
          sortType: event.sortType,
        ),
      );
    });

    on<SearchWithLicenseNumberEvent>((event, emit) async {
      emit(
        state.copyWith(
            licenseNumberQuery:
                Nullable(event.query.isEmpty ? null : event.query)),
      );
    });

    on<SearchWithViolationNumberEvent>((event, emit) async {
      emit(
        state.copyWith(
            invoiceNumberQuery:
                Nullable(event.query.isEmpty ? null : event.query)),
      );
    });

    on<GetViolationsEvent>((event, emit) async {
      emit(
        state.copyWith(
            violationsStatus: BlocRequestStatus.submissionGetLoading),
      );

      final unifiedNationalNumber =
          CommonProperties.selectedDelegator?.unifiedNationalNumber;
      final identityNumber = CommonProperties.selectedDelegator?.crNumber;

      final failureOrSuccess = await _getViolations(
        ViolationsPrams(
          unifiedNationalNumber: unifiedNationalNumber,
          identityNumber: identityNumber,
          page: state.page,
          size: PaginationConstants.limit,
          sort: state.sortType,
          violationInvoiceNumber: state.invoiceNumberQuery,
          licenseNumber: state.licenseNumberQuery,
          violationInvoiceStatusId: state.selectedInvoiceStatus?.id.toString(),
          violationIssueDate:
              state.selectedViolationIssueDate?.toIso8601String(),
          violationLastApplyDate:
              state.selectedObjectionLastApplyDate?.toIso8601String(),
          violationStatusId: state.selectedViolationStatus?.id.toString(),
        ),
      );

      failureOrSuccess.fold(
        (failure) {
          if (failure is NoDataFoundFailure) {
            emit(
              state.copyWith(
                violationsStatus: BlocRequestStatus.submissionGetSuccess,
                noMoreData: true,
                violations: state.page == 0 ? [] : state.violations,
              ),
            );
            return;
          }
          emit(
            state.copyWith(
              violationsStatus: BlocRequestStatus.submissionGetFailure,
              errorMessage: (failure as ServerFailure).errorMessage,
            ),
          );
        },
        (violations) {
          List<ViolationsEntity> newViolations = [];
          if (state.page != 0) {
            newViolations.addAll(state.violations);
          }
          newViolations.addAll(violations);
          emit(
            state.copyWith(
              violationsStatus: BlocRequestStatus.submissionGetSuccess,
              violations: newViolations,
            ),
          );
        },
      );
    });

    on<ViolationsLoadLookupsEvent>((event, emit) async {
      if (state.invoiceStatusesStatus == BlocRequestStatus.initial) {
        add(GetInvoiceStatusesEvent());
      }
      if (state.violationsStatusesStatus == BlocRequestStatus.initial) {
        add(GetViolationsStatusesEvent());
      }
    });

    on<GetViolationsStatusesEvent>((event, emit) async {
      emit(
        state.copyWith(
          violationsStatus: BlocRequestStatus.submissionGetLoading,
        ),
      );

      final failureOrSuccess = await _getViolationsStatuses(NoParams());

      failureOrSuccess.fold(
        (failure) {
          emit(
            state.copyWith(
              violationsStatus: BlocRequestStatus.submissionGetFailure,
              errorMessage: (failure as ServerFailure).errorMessage,
            ),
          );
        },
        (requestStatuses) {
          emit(
            state.copyWith(
              violationsStatus: BlocRequestStatus.submissionGetSuccess,
              violationsStatuses: requestStatuses,
            ),
          );
        },
      );
    });

    on<ViolationsStatusSelectedEvent>((event, emit) async {
      emit(
        state.copyWith(
          selectedViolationStatus: Nullable(event.violationsStatus),
        ),
      );
    });

    on<GetInvoiceStatusesEvent>((event, emit) async {
      emit(
        state.copyWith(
          invoiceStatusesStatus: BlocRequestStatus.submissionGetLoading,
        ),
      );

      final failureOrSuccess = await _getInvoiceStatuses(NoParams());

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

    on<InvoiceStatusesSelectedEvent>((event, emit) async {
      if (state.selectedInvoiceStatus?.id == event.invoiceStatus.id) {
        return;
      }
      emit(
        state.copyWith(
          selectedInvoiceStatus: Nullable(event.invoiceStatus),
        ),
      );
    });

    on<ViolationsLoadMoreEvent>((event, emit) async {
      if (state.violationsStatus != BlocRequestStatus.submissionGetSuccess ||
          state.noMoreData) {
        return;
      }
      emit(
        state.copyWith(
          page: state.page + 1,
        ),
      );
      add(GetViolationsEvent());
    });

    //ObjectionLastApplyDateSelectedEvent
    on<ObjectionLastApplyDateSelectedEvent>((event, emit) async {
      emit(
        state.copyWith(
            selectedObjectionLastApplyDate: Nullable(event.date),
            lastDateForm: Nullable(event.formDate)),
      );
    });

    //ViolationIssueDateSelectedEvent
    on<ViolationIssueDateSelectedEvent>((event, emit) async {
      emit(
        state.copyWith(
            selectedViolationIssueDate: Nullable(event.date),
            issueDateForm: Nullable(event.formDate)),
      );
    });

    on<ClearViolationsFiltersEvent>((event, emit) async {
      emit(state.copyWith(
        selectedViolationStatus: Nullable(null),
        selectedInvoiceStatus: Nullable(null),
        selectedObjectionLastApplyDate: Nullable(null),
        selectedViolationIssueDate: Nullable(null),
        invoiceNumberQuery: Nullable(null),
        licenseNumberQuery: Nullable(null),
        sortType: SortType.desc,
        page: 0,
      ));
      add(GetViolationsEvent());
    });

    on<ApplyViolationsFiltersEvent>((event, emit) async {
      emit(state.copyWith(
        page: 0,
      ));
      add(GetViolationsEvent());
    });

    on<ResetViolationsFiltersEvent>((event, emit) async {
      emit(state.copyWith(
        sortType: event.selectedSortType,
        selectedViolationStatus: Nullable(event.selectedRequestStatus),
        selectedInvoiceStatus: Nullable(event.selectedRequestType),
        selectedViolationIssueDate: Nullable(event.selectedRequestDate),
        selectedObjectionLastApplyDate: Nullable(event.selectedRequestDate),
        lastDateForm: Nullable(event.dateForm),
        issueDateForm: Nullable(event.dateForm),
        invoiceNumberQuery: Nullable(null),
        licenseNumberQuery: Nullable(null),
      ));
    });
  }
}
