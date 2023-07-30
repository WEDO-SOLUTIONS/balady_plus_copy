import 'package:balady_plus/app/core/services/local/shared_prefs_manager.dart';
import 'package:balady_plus/etmam_app/features/etmam_entry_point/presentation/cubit/etmam_entry_point_cubit.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart' show BlocStatus;

import 'package:balady_plus/etmam_app/core/dependency_injection/dependency_injection_exports.dart';
import 'package:balady_plus/etmam_app/core/services/local/use_case.dart';

import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart';
import 'package:balady_plus/etmam_app/features/on_boarding_cities/on_boarding_cities_exports.dart'
    show GetCities;
import 'package:balady_plus/etmam_app/core/errors/errors_exports.dart'
    show ServerFailure;

part 'city_event.dart';

part 'city_state.dart';

class CityBloc extends Bloc<CityEvent, CityState> {
  final GetCities _getCities;

  CityBloc({required GetCities getCities})
      : _getCities = getCities,
        super(CityState()) {
    on<CityEvent>((event, emit) {});
    on<GetLocalCities>(_getLocalCitiesHandler);
    add(const GetLocalCities());

    on<GetCitiesEvent>(_getCitiesHandler);

    add(const GetCitiesEvent());

    on<SelectCityEvent>(_selectCityHandler);

    on<SearchForCityEvent>(_searchForCityHandler);
  }

  Future<void> _getCitiesHandler(GetCitiesEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _getCities(NoParams());

    failureOrSuccess.fold((failure) {
      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) {
      emitter(state.copyWith(
          status: BlocStatus.success,
          items: success.data?.result?.items,
          totalItemCount: success.data?.result?.totalItemCount,
          totalPageCount: success.data?.result?.totalPageCount,
          errorMessage: "",
          searchedItems: success.data?.result?.items));

      sharedPrefs.setCitiesList(
          success.data?.result?.items?.map((e) => e.toModel).toList());
    });
  }

  Future<void> _selectCityHandler(SelectCityEvent e, Emitter emitter) async {
    if (e.item != null) {
      emitter(state.copyWith(status: BlocStatus.loading));

      emitter(state.copyWith(status: BlocStatus.success, selectedItem: e.item));
      sharedPrefs.setCurrentCity(e.item!.toModel);

      CommonProperties.cityId = e.item?.id ?? "";
      sl<EtmamEntryPointCubit>().setTheme();
    }
  }

  Future<void> _getLocalCitiesHandler(GetLocalCities e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));
    List<CityItem>? items = sharedPrefs.getCitiesList();
    CityItem? item = sharedPrefs.getCity();

    if (items != null) {
      emitter(state.copyWith(
          status: BlocStatus.success,
          items: items,
          selectedItem: item,
          searchedItems: items));
    }
  }

  Future<void> _searchForCityHandler(
      SearchForCityEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));
    List<CityItem>? items = state.items
            ?.where((element) => element.name?.contains(e.text ?? "") ?? false)
            .toList() ??
        [];

    emitter(state.copyWith(status: BlocStatus.success, searchedItems: items));
  }
}
