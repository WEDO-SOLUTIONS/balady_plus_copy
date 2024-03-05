import 'package:balady_plus/app/core/services/local/shared_prefs_manager.dart';
import 'package:balady_plus/etmam_app/features/etmam_entry_point/presentation/cubit/etmam_entry_point_cubit.dart';
import 'package:balady_plus/etmam_app/features/services/domain/entities/services/service_params.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart'
    show BlocStatus, EtmamRoutesNames;

import 'package:balady_plus/etmam_app/core/dependency_injection/dependency_injection_exports.dart';
import 'package:balady_plus/etmam_app/core/services/local/use_case.dart';

import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart';
import 'package:balady_plus/etmam_app/features/on_boarding_cities/on_boarding_cities_exports.dart'
    show GetCities;
import 'package:balady_plus/etmam_app/core/errors/errors_exports.dart'
    show ServerFailure;
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../app/core/services/local/navigation_services.dart';
import '../../../services/domain/use_cases/get_services.dart';
import '../../domain/entities/city_params.dart';

part 'city_event.dart';

part 'city_state.dart';

class CityBloc extends Bloc<CityEvent, CityState> {
  final GetCities _getCities;
  final GetServicesProvidersByService _getServicesProvidersByService;

  CityBloc({required GetCities getCities})
      : _getCities = getCities,
        _getServicesProvidersByService =
            GetServicesProvidersByService(repository: sl()),
        super(CityState()) {
    on<CityEvent>((event, emit) {});
    on<GetLocalCities>(_getLocalCitiesHandler);
    //add(const GetLocalCities());

    on<GetCitiesEvent>(_getCitiesHandler);

    add(const GetCitiesEvent());

    on<SelectCityEvent>(_selectCityHandler);

    on<SearchForCityEvent>(_searchForCityHandler);
    on<GetProvidersForASubServiceEvent>(_getProvidersHandler);

    on<GetMoreCitiesEvent>(_getMoreCitiesHandler);
  }

  Future<void> _getCitiesHandler(GetCitiesEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess =
        await _getCities(CityParams(pageNo: 1, pageSize: 20));

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
          nextPageIndex: ((success.data?.result?.items?.length ?? 0) > 0)
              ? state.nextPageIndex + 1
              : state.nextPageIndex,
          searchedItems: success.data?.result?.items));

      // sharedPrefs.setCitiesList(
      //     success.data?.result?.items?.map((e) => e.toModel).toList());
    });
  }

  Future<void> _getMoreCitiesHandler(
      GetMoreCitiesEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loadMore));

    final failureOrSuccess =
        await _getCities(CityParams(pageNo: state.nextPageIndex, pageSize: 20));

    failureOrSuccess.fold((failure) {
      emitter(state.copyWith(
        status: (failure as ServerFailure).statusCode == "2"
            ? BlocStatus.success
            : BlocStatus.failure,
        errorMessage: (failure as ServerFailure).statusCode == "2"
            ? ""
            : (failure as ServerFailure).errorMessage,
      ));
    }, (success) {
      List<CityItem> searchedItems = state.searchedItems ?? [];
      searchedItems.addAll(success.data?.result?.items ?? []);
      emitter(state.copyWith(
          status: BlocStatus.success,
          totalItemCount: success.data?.result?.totalItemCount,
          totalPageCount: success.data?.result?.totalPageCount,
          nextPageIndex: ((success.data?.result?.items?.length ?? 0) > 0)
              ? state.nextPageIndex + 1
              : state.nextPageIndex,
          errorMessage: "",
          searchedItems: searchedItems));

      // sharedPrefs.setCitiesList(searchedItems.map((e) => e.toModel).toList());
    });
  }

  Future<void> _selectCityHandler(SelectCityEvent e, Emitter emitter) async {
    if (e.item != null) {
      emitter(state.copyWith(providersStatus: BlocStatus.loading));

      sharedPrefs.setCurrentCity(e.item!.toModel);

      // CommonProperties.cityId = e.item?.id ?? "";
      sl<EtmamEntryPointCubit>().setTheme();
      if (e.item?.id != null) {
        print("update city ${e.item!.id!}");
        sl<EtmamEntryPointCubit>().updateCity(e.item!);
      }
      if (e.subServiceid != null && e.subServiceid!.isNotEmpty) {
        await sl<EtmamEntryPointCubit>().onLogin();
        print("CALLLLED ${e.subServiceid}");
        add(GetProvidersForASubServiceEvent(subServiceId: e.subServiceid));
      }

      emitter(state.copyWith(
          providersStatus: BlocStatus.success, selectedItem: e.item));
    }
  }

  void updateCurrentCity(CityItem item) {
    emit(state.copyWith(status: BlocStatus.loading));

    emit(state.copyWith(status: BlocStatus.success, selectedItem: item));
  }

  Future<void> _getLocalCitiesHandler(GetLocalCities e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));
    //  List<CityItem>? items = sharedPrefs.getCitiesList();
    //  CityItem? item = sharedPrefs.getCity();

    /* if (items != null) {
      emitter(state.copyWith(
          status: BlocStatus.success,
          items: items,
          selectedItem: item,
          searchedItems: items));
    }*/
  }

  Future<void> _searchForCityHandler(
      SearchForCityEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loadingShimmer));

    final failureOrSuccess =
        await _getCities(CityParams(pageNo: 1, pageSize: 20, text: e.text));

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
          searchText: e.text,
          nextPageIndex: 2,
          searchedItems: success.data?.result?.items));

      // sharedPrefs.setCitiesList(
      //     success.data?.result?.items?.map((e) => e.toModel).toList());
    });
  }

  Future<void> _getProvidersHandler(
      GetProvidersForASubServiceEvent e, Emitter emitter) async {
    emitter(state.copyWith(providersStatus: BlocStatus.loading));

    final failureOrSuccess = await _getServicesProvidersByService(ServiceParams(
        pageIndex: "1",
        cityId: CommonProperties.cityId,
        subServiceId: e.subServiceId ?? "",
        subServiceName: "Building_Compliance_Certificate_Issuance".tr()));

    failureOrSuccess.fold((failure) {
      emitter(state.copyWith(
        providersStatus: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) {
      emitter(state.copyWith(
        providersStatus: BlocStatus.success,
        errorMessage: "",
      ));

      // Navigate to Providers screen
      NavigationService.navigatorKey.currentState!
          .pushReplacementNamed(EtmamRoutesNames.providersByService,
              arguments: ServicePageParams(
                response: success.data!.result!,
              ));
    });
  }

  void clearSearch() {}
}
