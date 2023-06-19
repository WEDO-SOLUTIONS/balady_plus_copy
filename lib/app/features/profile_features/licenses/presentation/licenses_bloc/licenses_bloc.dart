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
import '../../licenses_exports.dart'
    show
        GetLicenseStatuses,
        GetLicenseSubTypes,
        GetLicenseTypes,
        GetLicenses,
        LicenseEntity,
        LicenseStatusEntity,
        LicenseSubTypeEntity,
        LicenseSubTypeParams,
        LicenseTypeEntity,
        LicensesPrams;

part 'licenses_event.dart';
part 'licenses_state.dart';

class LicensesBloc extends Bloc<LicensesEvent, LicensesState> {
  final GetLicenses getLicenses;
  final GetLicenseTypes getLicenseTypes;
  final GetLicenseStatuses getLicenseStatuses;
  final GetMunicipalities getMunicipalities;
  final GetSubMunicipalities getSubMunicipalities;
  final GetLicenseSubTypes getLicenseSubTypes;

  LicensesBloc({
    required this.getLicenses,
    required this.getLicenseTypes,
    required this.getLicenseStatuses,
    required this.getMunicipalities,
    required this.getSubMunicipalities,
    required this.getLicenseSubTypes,
  }) : super(const LicensesState()) {
    on<GetLicensesEvent>((event, emit) async {
      emit(
        state.copyWith(requestsStatus: BlocRequestStatus.submissionGetLoading),
      );

      final failureOrSuccess = await getLicenses(
        LicensesPrams(
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

    on<SearchLicensesEvent>((event, emit) async {
      emit(
        state.copyWith(requestNumberQuery: event.query),
      );
      add(GetLicensesEvent());
    });

    on<GetLicenseStatusesEvent>((event, emit) async {
      emit(
        state.copyWith(
          requestStatusesStatus: BlocRequestStatus.submissionGetLoading,
        ),
      );

      final failureOrSuccess = await getLicenseStatuses(NoParams());

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

    on<LicenseStatusSelectedEvent>((event, emit) async {
      emit(
        state.copyWith(
          selectedLicenseStatus: event.requestStatus,
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

    on<GetLicenseTypesEvent>((event, emit) async {
      emit(
        state.copyWith(
          requestTypesStatus: BlocRequestStatus.submissionGetLoading,
        ),
      );

      final failureOrSuccess = await getLicenseTypes(NoParams());

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

    on<LicenseTypeSelectedEvent>((event, emit) async {
      emit(
        state.copyWith(
          selectedLicenseType: event.requestType,
        ),
      );
    });

    on<GetLicenseSubtypesEvent>((event, emit) async {
      if (state.selectedLicenseType == null) {
        return;
      }
      emit(
        state.copyWith(
          requestSubTypesStatus: BlocRequestStatus.submissionGetLoading,
        ),
      );

      final failureOrSuccess = await getLicenseSubTypes(
        LicenseSubTypeParams(
          id: state.selectedLicenseType!.id,
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

    on<LicenseSubTypeSelectedEvent>((event, emit) async {
      emit(
        state.copyWith(
          selectedLicenseSubType: event.requestSubtype,
        ),
      );
    });

    on<LicensesLoadMoreEvent>((event, emit) async {
      if (state.requestsStatus == BlocRequestStatus.submissionGetLoading ||
          !state.hasReachedMax) {
        return;
      }
      emit(
        state.copyWith(
          page: state.page + 1,
        ),
      );
      add(GetLicensesEvent());
    });

    //LicenseDateSelectedEvent
    on<LicenseDateSelectedEvent>((event, emit) async {
      emit(
        state.copyWith(
          selectedLicenseDate: event.date,
        ),
      );
    });

    on<LicensesSortChangedEvent>((event, emit) async {
      emit(
        state.copyWith(
          sortType: event.sortType,
        ),
      );
    });
  }
}
