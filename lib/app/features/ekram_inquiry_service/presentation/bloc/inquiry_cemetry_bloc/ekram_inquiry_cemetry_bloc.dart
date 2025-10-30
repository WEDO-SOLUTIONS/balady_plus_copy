import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/dependency_injection/injection_container.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/utils/enums/bloc_status.dart';
import '../../../../new_appointment/presentation/core/models/lookup_list_model.dart';
import '../../../domain/entities/find_cemetry_request.dart';
import '../../../domain/use_cases/find_cemetries.dart';
import '../../../domain/use_cases/get_ekram_cities.dart';
import '../../../domain/use_cases/get_ekram_districts.dart';
import 'ekram_inquiry_cemetry_event.dart';
import 'ekram_inquiry_cemetry_state.dart';

class EkramInquiryCemetryBloc
    extends Bloc<EkramInquiryCemetryEvent, EkramInquiryCemetryState> {
  final FindCemetries _findCemetries;
  final GetEkramCities _getEkramCities;
  final GetEkramDistricts _getEkramDistricts;
  EkramInquiryCemetryBloc()
      : _findCemetries = FindCemetries(repository: sl()),
        _getEkramCities = GetEkramCities(repository: sl()),
        _getEkramDistricts = GetEkramDistricts(repository: sl()),
        super(EkramInquiryCemetryState()) {
    on<FindCemetriesEvent>(_findCemetiresHandler);
    on<GetEkramCitiesEvent>(_getEkramCitiesEventHandler);
    on<GetEkramDistrictsEvent>(_getEkramDistrcitsEventHandler);
    on<SelectDistrcitEvent>(_selectDistrictHandler);
    on<ChangeLaundryExistEvent>(_changeLaundryExistHandler);
    on<ChangeIsMuslimEvent>(_changeIsMuslimHandler);
    on<ClearEvent>(_clearEventHandler);
  }

  Future<void> _clearEventHandler(ClearEvent e, Emitter emitter) async {
    emitter(state.copyWith(
      status: BlocStatus.loading,
    ));

    emitter(state.copyWith(
        status: BlocStatus.success,
        errorMsg: "",
        muslim: Nullable(true),
        laundryExist: Nullable(null),
        selectedDistrcit: Nullable(null),
        selectedCity: Nullable(null),
        distrcts: []));
  }

  Future<void> _changeLaundryExistHandler(
      ChangeLaundryExistEvent e, Emitter emitter) async {
    emitter(state.copyWith(
      status: BlocStatus.loading,
    ));

    emitter(state.copyWith(
      status: BlocStatus.success,
      laundryExist: Nullable(e.value),
      errorMsg: "",
    ));
  }

  Future<void> _changeIsMuslimHandler(
      ChangeIsMuslimEvent e, Emitter emitter) async {
    emitter(state.copyWith(
      status: BlocStatus.loading,
    ));

    emitter(state.copyWith(
      status: BlocStatus.success,
      muslim: Nullable(e.value),
      errorMsg: "",
    ));
  }

  Future<void> _selectDistrictHandler(
      SelectDistrcitEvent e, Emitter emitter) async {
    emitter(state.copyWith(
      status: BlocStatus.loading,
    ));

    emitter(state.copyWith(
      status: BlocStatus.success,
      selectedDistrcit: Nullable(e.item),
      errorMsg: "",
    ));
  }

  Future<void> _getEkramDistrcitsEventHandler(
      GetEkramDistrictsEvent e, Emitter emitter) async {
    emitter(state.copyWith(
      status: BlocStatus.loading,
    ));
    final failureOrSuccess = await _getEkramDistricts(e.city.id!);

    failureOrSuccess.fold((l) {
      if (l == NoDataFoundFailure())
        emitter(state.copyWith(
            status: BlocStatus.success,
            distrcts: [],
            selectedCity: Nullable(e.city),
            selectedDistrcit: Nullable(null)));
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
          distrcts: r,
          selectedCity: Nullable(e.city),
          errorMsg: "",
          selectedDistrcit: Nullable(null)));
    });
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
    final failureOrSuccess = await _findCemetries(FindCemetryRequest(
      muslim: state.muslim,
      laundryExist: state.laundryExist,
      cityId: state.selectedCity?.id,
      districtId: state.selectedDistrcit?.id,
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
        findCemetryResponse: r.result,
        errorMsg: "",
      ));

      NavigationService.navigatorKey.currentState!
          .pushNamed(RouteName.EkramInquiryCemetryResultsPage, arguments: this);
    });
  }
}
