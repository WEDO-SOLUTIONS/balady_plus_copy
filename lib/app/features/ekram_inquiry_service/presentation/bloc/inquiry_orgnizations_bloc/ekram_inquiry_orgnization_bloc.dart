import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/dependency_injection/injection_container.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/utils/enums/bloc_status.dart';
import '../../../../new_appointment/presentation/core/models/lookup_list_model.dart';
import '../../../domain/entities/find_cemetry_request.dart';
import '../../../domain/use_cases/get_charity_orgnizations.dart';
import '../../../domain/use_cases/get_ekram_cities.dart';
import 'ekram_inquiry_orgnization_state.dart';
import 'ekram_inquiry_orgnization_event.dart';

class EkramInquiryOrgnizationBloc
    extends Bloc<EkramOrgnizationCemetryEvent, EkramOrgnizationCemetryState> {
  final GetCharityOrgnizations _getCharityOrgnizations;
  final GetEkramCities _getEkramCities;
  EkramInquiryOrgnizationBloc()
      : _getCharityOrgnizations = GetCharityOrgnizations(repository: sl()),
        _getEkramCities = GetEkramCities(repository: sl()),
        super(EkramOrgnizationCemetryState()) {
    on<FindCemetriesEvent>(_findCemetiresHandler);
    on<GetEkramCitiesEvent>(_getEkramCitiesEventHandler);
    on<SelectCityEvent>(_selectCityHandler);
    on<ClearEvent>(_clearHandler);
  }

  Future<void> _clearHandler(ClearEvent e, Emitter emitter) async {
    emitter(state.copyWith(
      status: BlocStatus.loading,
    ));

    emitter(state.copyWith(
      status: BlocStatus.success,
      selectedCity: Nullable(null),
      errorMsg: "",
    ));
  }

  Future<void> _selectCityHandler(SelectCityEvent e, Emitter emitter) async {
    emitter(state.copyWith(
      status: BlocStatus.loading,
    ));

    emitter(state.copyWith(
      status: BlocStatus.success,
      selectedCity: Nullable(e.item),
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
    final failureOrSuccess =
        await _getCharityOrgnizations(state.selectedCity!.id!);

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
        charityOrgnizations: r.result,
        errorMsg: "",
      ));

      NavigationService.navigatorKey.currentState!.pushNamed(
          RouteName.EkramInquiryOrgnizationsResultsPage,
          arguments: this);
    });
  }
}
