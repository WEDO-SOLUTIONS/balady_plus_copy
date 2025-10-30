import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/dependency_injection/injection_container.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/utils/enums/bloc_status.dart';
import '../../../../ekram/domain/use_cases/get_nationalities.dart';
import '../../../../ekram/domain/use_cases/get_nationality_types.dart';
import '../../../../new_appointment/presentation/core/models/lookup_list_model.dart';
import '../../../domain/entities/find_grave_request.dart';
import '../../../domain/use_cases/find_grave.dart';
import '../../../domain/use_cases/get_ekram_cities.dart';
import '../../../domain/use_cases/get_ekram_districts.dart';
import '../../../domain/use_cases/get_ekram_identity_types.dart';
import 'ekram_inquiry_grave_event.dart';
import 'ekram_inquiry_grave_state.dart';

class EkramInquiryGraveBloc
    extends Bloc<EkramInquiryGraveEvent, EkramInquiryGraveState> {
  final FindGrave _findCemetries;
  final GetEkramCities _getEkramCities;
  final GetEkramIdentityTypes _getEkramIdentityTypes;
  final GetNationalities _getNationalities;

  EkramInquiryGraveBloc()
      : _findCemetries = FindGrave(repository: sl()),
        _getEkramCities = GetEkramCities(repository: sl()),
        _getEkramIdentityTypes = GetEkramIdentityTypes(repository: sl()),
        _getNationalities = GetNationalities(repository: sl()),
        super(EkramInquiryGraveState()) {
    on<FindCemetriesEvent>(_findCemetiresHandler);
    on<GetEkramCitiesEvent>(_getEkramCitiesEventHandler);
    on<SelectCityEvent>(_selectCityHandler);
    on<SelectNationalityEvent>(_selectNationalityHandler);

    on<SelectNationalIdTypeEvent>(_selectNationalIdHandler);

    on<ChangeFullNameEvent>(_changeFullNameHandler);
    on<ChangeIdentityNoEvent>(_changeIdentityNoEvent);
    getEkramNationalitiesEventHandler();
    getEkramNationalIdTypesEventHandler();
  }

  Future<void> _changeIdentityNoEvent(
      ChangeIdentityNoEvent e, Emitter emitter) async {
    emitter(state.copyWith(
      status: BlocStatus.loading,
    ));

    emitter(state.copyWith(
      status: BlocStatus.success,
      nationalId: e.value,
      errorMsg: "",
    ));
  }

  Future<void> _changeFullNameHandler(
      ChangeFullNameEvent e, Emitter emitter) async {
    emitter(state.copyWith(
      status: BlocStatus.loading,
    ));

    emitter(state.copyWith(
      status: BlocStatus.success,
      fullName: e.value,
      errorMsg: "",
    ));
  }

  Future<void> _selectNationalityHandler(
      SelectNationalityEvent e, Emitter emitter) async {
    emitter(state.copyWith(
      status: BlocStatus.loading,
    ));

    emitter(state.copyWith(
      status: BlocStatus.success,
      selectedNationality: e.item,
      errorMsg: "",
    ));
  }

  Future<void> _selectNationalIdHandler(
      SelectNationalIdTypeEvent e, Emitter emitter) async {
    emitter(state.copyWith(
      status: BlocStatus.loading,
    ));

    emitter(state.copyWith(
      status: BlocStatus.success,
      selectedNationalIdType: e.item,
      errorMsg: "",
    ));
  }

  Future<void> _selectCityHandler(SelectCityEvent e, Emitter emitter) async {
    emitter(state.copyWith(
      status: BlocStatus.loading,
    ));

    emitter(state.copyWith(
      status: BlocStatus.success,
      selectedCity: e.item,
      errorMsg: "",
    ));
  }

  Future<List<LookUpItem>?> getEkramCitiesEventHandler() async {
    emit(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _getEkramCities(NoParams());
    return failureOrSuccess.fold((failure) {
      emit(state.copyWith(
        status: BlocStatus.failure,
        errorMsg: (failure as ServerFailure).errorMessage,
      ));
      return null;
    }, (success) {
      emit(state.copyWith(
        status: BlocStatus.success,
        cities: success,
        errorMsg: "",
      ));
      return success;
    });
  }

  Future<List<LookUpItem>?> getEkramNationalitiesEventHandler() async {
    emit(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _getNationalities(NoParams());
    return failureOrSuccess.fold((failure) {
      emit(state.copyWith(
        status: BlocStatus.failure,
        errorMsg: (failure as ServerFailure).errorMessage,
      ));
      return null;
    }, (success) {
      emit(state.copyWith(
        status: BlocStatus.success,
        nationalities: success.data?.result,
        errorMsg: "",
      ));
      return success.data?.result;
    });
  }

  Future<List<LookUpItem>?> getEkramNationalIdTypesEventHandler() async {
    emit(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _getEkramIdentityTypes(NoParams());
    return failureOrSuccess.fold((failure) {
      emit(state.copyWith(
        status: BlocStatus.failure,
        errorMsg: (failure as ServerFailure).errorMessage,
      ));
      return null;
    }, (success) {
      emit(state.copyWith(
        status: BlocStatus.success,
        nationalIdTypes: success,
        errorMsg: "",
      ));
      return success;
    });
  }

  Future<void> _getEkramCitiesEventHandler(
      GetEkramCitiesEvent e, Emitter emitter) async {
    emitter(state.copyWith(
      status: BlocStatus.loading,
    ));
    final failureOrSuccess = await _getEkramCities(NoParams());

    failureOrSuccess.fold((l) {
      if (l == NoDataFoundFailure())
        emitter(state.copyWith(status: BlocStatus.success, cities: []));
      else {
        emitter(
          state.copyWith(
              status: BlocStatus.failure,
              errorMsg: (l as ServerFailure).errorMessage),
        );
      }
    }, (r) {
      emitter(state.copyWith(
        status: BlocStatus.success,
        cities: r,
        errorMsg: "",
      ));
    });
  }

  Future<void> _findCemetiresHandler(
      FindCemetriesEvent e, Emitter emitter) async {
    emitter(state.copyWith(
      status: BlocStatus.loading,
    ));
    final failureOrSuccess = await _findCemetries(FindGraveRequest(
      cityId: state.selectedCity?.id,
      deceasedName: state.fullName,
      identityNumber: state.nationalId,
      identityType: state.selectedNationalIdType?.id,
      nationalityId: state.selectedNationality?.id,
    ));

    failureOrSuccess.fold((l) {
      print("failure");
      emitter(
        state.copyWith(
            status: BlocStatus.failure,
            errorMsg: (l as ServerFailure).errorMessage),
      );
    }, (r) {
      emitter(state.copyWith(
        status: BlocStatus.success,
        findGraveResponse: r.result,
        errorMsg: "",
      ));

      NavigationService.navigatorKey.currentState!
          .pushNamed(RouteName.EkramInquiryGravesResultsPage, arguments: this);
    });
  }
}
