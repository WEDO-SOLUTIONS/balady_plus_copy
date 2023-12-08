import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        GetLicenseTypes,
        GetLicenses,
        LicenseEntity,
        LicenseStatusEntity,
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

  LicensesBloc({
    required this.getLicenses,
    required this.getLicenseTypes,
    required this.getLicenseStatuses,
    required this.getMunicipalities,
    required this.getSubMunicipalities,
  }) : super(const LicensesState()) {
    on<GetLicensesEvent>((event, emit) async {
      emit(
        state.copyWith(licensesStatus: BlocRequestStatus.submissionGetLoading),
      );

      final unifiedNationalNumber =
          CommonProperties.selectedDelegator?.unifiedNationalNumber;
      final identityNumber = CommonProperties.selectedDelegator?.crNumber;

      final failureOrSuccess = await getLicenses(
        LicensesPrams(
          unifiedNationalNumber: unifiedNationalNumber,
          identityNumber: identityNumber,
          page: state.page,
          size: PaginationConstants.limit,
          licenseNumber: state.licenseNumberQuery,
          productId: state.selectedLicenseType?.id.toString(),
          dashboardStatusId: state.selectedLicenseStatus?.id.toString(),
          expireDate: state.selectedLicenseEndDate?.toIso8601String(),
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
                licensesStatus: BlocRequestStatus.submissionGetSuccess,
                noMoreData: true,
                licenses: state.page == 0 ? [] : state.licenses,
              ),
            );
            return;
          }
          emit(
            state.copyWith(
              licensesStatus: BlocRequestStatus.submissionGetFailure,
              errorMessage: (failure as ServerFailure).errorMessage,
            ),
          );
        },
        (licenses) {
          List<LicenseEntity> newList = [];
          if (state.page != 0) {
            newList.addAll(state.licenses);
          }
          newList.addAll(licenses);
          emit(
            state.copyWith(
              licensesStatus: BlocRequestStatus.submissionGetSuccess,
              licenses: newList,
            ),
          );
        },
      );
    });

    on<SearchLicensesEvent>((event, emit) async {
      emit(
        state.copyWith(licenseNumberQuery: event.query),
      );
      add(GetLicensesEvent());
    });

    on<LicensesLoadLookupsEvent>((event, emit) async {
      if (state.licenseTypesStatus == BlocRequestStatus.initial) {
        add(GetLicenseTypesEvent());
      }
      if (state.licenseStatusesStatus == BlocRequestStatus.initial) {
        add(GetLicenseStatusesEvent());
      }
      if (state.municipalitiesStatus == BlocRequestStatus.initial) {
        add(GetMunicipalitiesEvent());
      }
    });

    on<GetLicenseStatusesEvent>((event, emit) async {
      emit(
        state.copyWith(
          licenseStatusesStatus: BlocRequestStatus.submissionGetLoading,
        ),
      );

      final failureOrSuccess = await getLicenseStatuses(NoParams());

      failureOrSuccess.fold(
        (failure) {
          emit(
            state.copyWith(
              licenseStatusesStatus: BlocRequestStatus.submissionGetFailure,
              errorMessage: (failure as ServerFailure).errorMessage,
            ),
          );
        },
        (requestStatuses) {
          emit(
            state.copyWith(
              licenseStatusesStatus: BlocRequestStatus.submissionGetSuccess,
              licenseStatuses: requestStatuses,
            ),
          );
        },
      );
    });

    on<LicenseStatusSelectedEvent>((event, emit) async {
      emit(
        state.copyWith(
          selectedLicenseStatus: Nullable(event.licenseStatus),
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

    on<GetLicenseTypesEvent>((event, emit) async {
      emit(
        state.copyWith(
          licenseTypesStatus: BlocRequestStatus.submissionGetLoading,
        ),
      );

      final failureOrSuccess = await getLicenseTypes(NoParams());

      failureOrSuccess.fold(
        (failure) {
          emit(
            state.copyWith(
              licenseTypesStatus: BlocRequestStatus.submissionGetFailure,
              errorMessage: (failure as ServerFailure).errorMessage,
            ),
          );
        },
        (requestTypes) {
          emit(
            state.copyWith(
              licenseTypesStatus: BlocRequestStatus.submissionGetSuccess,
              licenseTypes: requestTypes,
            ),
          );
        },
      );
    });

    on<LicenseTypeSelectedEvent>((event, emit) async {
      if (state.selectedLicenseType?.id == event.licenseType.id) {
        return;
      }
      // add(GetLicenseSubtypesEvent(licenseType: event.licenseType));
      emit(
        state.copyWith(
          selectedLicenseType: Nullable(event.licenseType),
        ),
      );
    });

    on<LicensesLoadMoreEvent>((event, emit) async {
      if (state.licensesStatus != BlocRequestStatus.submissionGetSuccess ||
          state.noMoreData) {
        return;
      }
      emit(
        state.copyWith(
          page: state.page + 1,
        ),
      );
      add(GetLicensesEvent());
    });

    on<LicenseDateSelectedEvent>((event, emit) async {
      emit(
        state.copyWith(
            selectedLicenseEndDate: Nullable(event.date),
            dateForm: Nullable(event.formDate)),
      );
    });

    on<LicensesSortChangedEvent>((event, emit) async {
      emit(
        state.copyWith(
          sortType: event.sortType,
        ),
      );
    });

    on<ApplyLicensesFiltersEvent>((event, emit) async {
      emit(state.copyWith(
        page: 0,
      ));
      add(GetLicensesEvent());
    });

    on<ClearLicensesFiltersEvent>((event, emit) async {
      emit(state.copyWith(
        selectedLicenseStatus: Nullable(null),
        selectedMunicipality: Nullable(null),
        selectedSubMunicipality: Nullable(null),
        selectedLicenseType: Nullable(null),
        selectedLicenseEndDate: Nullable(null),
        sortType: SortType.desc,
        page: 0,
      ));
      add(GetLicensesEvent());
    });

    on<ResetLicensesFiltersEvent>((event, emit) async {
      emit(state.copyWith(
          sortType: event.selectedSortType,
          selectedLicenseStatus: Nullable(event.selectedLicenseStatus),
          selectedMunicipality: Nullable(event.selectedMunicipality),
          selectedSubMunicipality: Nullable(event.selectedSubMunicipality),
          selectedLicenseType: Nullable(event.selectedLicenseType),
          selectedLicenseEndDate: Nullable(event.selectedLicenseDate),
          dateForm: Nullable(event.dateForm)));
    });
  }
}
