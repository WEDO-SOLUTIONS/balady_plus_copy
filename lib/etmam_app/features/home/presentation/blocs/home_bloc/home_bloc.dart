import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/etmam_app/core/errors/failures.dart';
import 'package:balady_plus/etmam_app/core/services/local/use_case.dart';

import 'package:balady_plus/etmam_app/core/utils/common_properties.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart';
import 'package:balady_plus/etmam_app/features/etmam_entry_point/presentation/cubit/etmam_entry_point_cubit.dart';
import 'package:balady_plus/etmam_app/features/home/domain/entities/ads/ads_response.dart';
import 'package:balady_plus/etmam_app/features/home/domain/use_cases/get_ads.dart';
import 'package:balady_plus/etmam_app/features/home/home_exports.dart'
    show
        EtmamSubServicesPage,
        GetMainServices,
        GetSubService,
        GetTopOrderedSubService,
        GetTopRatedProviders,
        MainServiceParams,
        MainServiceResponse,
        SubServicePageArgs,
        SubServiceParams,
        SubServiceResponse,
        TopOrderedSubServiceParams,
        TopRatedProviderParams;
import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:balady_plus/etmam_app/features/providers/providers_exports.dart';
import 'package:balady_plus/etmam_app/features/services/services_exports.dart'
    show ServiceParams, GetServicesProvidersByService;
import 'package:balady_plus/app/core/utils/utils_exports.dart' show BlocStatus;
import 'package:flutter/material.dart';

import '../../../../../../app/core/dependency_injection/injection_container.dart';
import '../../../../dynamic_form/domain/use_cases/find_by_request_type.dart';
import '../../../../dynamic_form/presentation/dialogs/bidding_types_dialog.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetMainServices _getMainServices;
  final GetTopOrderedSubService _getTopOrderedSubService;
  final GetTopRatedProviders _getTopRatedProviders;
  final GetSubService _getSubService;
  final GetServicesProvidersByService _getServicesProvidersByService;
  final GetProviderDetails _getProviderDetails;
  final GetAds _getAds;
  final FindByRequestType _findByRequestType;
  bool isMunicipalService = true;
  HomeBloc({
    required GetMainServices getMainServices,
    required GetTopOrderedSubService getTopOrderedSubService,
    required GetTopRatedProviders getTopRatedProviders,
    required GetSubService getSubService,
    required GetServicesProvidersByService getServicesProvidersByService,
    required GetProviderDetails getProviderDetails,
    required GetAds getAds,
    required bool isMunicipalService,
  })  : _getMainServices = getMainServices,
        _getTopOrderedSubService = getTopOrderedSubService,
        _getTopRatedProviders = getTopRatedProviders,
        _getSubService = getSubService,
        _getServicesProvidersByService = getServicesProvidersByService,
        _getProviderDetails = getProviderDetails,
        _getAds = getAds,
        _findByRequestType = FindByRequestType(repository: sl()),
        isMunicipalService = isMunicipalService,
        super(const HomeState()) {
    sl<EtmamEntryPointCubit>().changeServiceType(
        classificationId:
            isMunicipalService == true ? "municipal" : "life-style");
    on<HomeEvent>((event, emit) {});

    on<GetMainServicesEvent>(_getMainServicesHandler);
    on<GetTopOrderedSubServicesEvent>(_getGetTopOrderedSubServicesHandler);
    on<GetTopRatedProvidersEvent>(_getGetTopRatedProvidersHandler);
    on<GetSubServicesEvent>(_getSubServicesHandler);
    on<GetProviders>(_getProvidersHandler);
    on<ChangeCityEvent>(_chaneCityHandler);

    on<GetProviderDetailsEvent>(_getProviderDetailsHandler);
    on<GetAdsEvent>(_getAdsDetailsHandler);
    on<FindByRequestTypeEvent>(_findByRequestTypeEventHandler);

    on<FindByRequestTypeEventChangedCity>(
        _findByRequestTypeEventChangedCityHandler);
    add(
      GetMainServicesEvent(
        params: MainServiceParams(
            cityId: CommonProperties.cityId, pageIndex: "0", pageSize: "10"),
      ),
    );
    add(
      GetTopOrderedSubServicesEvent(
        params: TopOrderedSubServiceParams(
            cityId: CommonProperties.cityId, pageSize: "4", pageIndex: "1"),
      ),
    );

    add(
      GetTopRatedProvidersEvent(
        params: TopRatedProviderParams(
            cityId: CommonProperties.cityId, pageSize: "4", pageIndex: "1"),
      ),
    );

    add(FindByRequestTypeEventChangedCity());
    add(GetAdsEvent());
  }

  Future<void> _findByRequestTypeEventHandler(
      FindByRequestTypeEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));
    final failureOrSuccess = await _findByRequestType(NoParams());
    failureOrSuccess.fold((failure) {
      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) {
      NavigationService.navigatorKey.currentState!
          .pushNamed(EtmamRoutesNames.biddingReleationTypes);
      emitter(state.copyWith(
        status: BlocStatus.success,
        hideBidding: false,
        errorMessage: "",
      ));
    });
  }

  Future<void> _findByRequestTypeEventChangedCityHandler(
      FindByRequestTypeEventChangedCity e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));
    final failureOrSuccess = await _findByRequestType(NoParams());
    failureOrSuccess.fold((failure) {
      var errorCode = (failure as ServerFailure).errorCode;
      emitter(state.copyWith(
          status: BlocStatus.failure,
          hideBidding: errorCode ==
              "baladystore-service-catalog.errors.request-type-has-no-relations"));
    }, (success) {
      emitter(state.copyWith(
        status: BlocStatus.success,
        hideBidding: false,
        errorMessage: "",
      ));
    });
  }

  Future<void> _getMainServicesHandler(
      GetMainServicesEvent e, Emitter emitter) async {
    emitter(state.copyWith(
        mainServiceStatus: BlocStatus.loading, errorMessage: ""));

    final failureOrSuccess = await _getMainServices(e.params);

    failureOrSuccess.fold((failure) {
      emitter(state.copyWith(
        mainServiceStatus: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) {
      emitter(state.copyWith(
        mainServiceStatus: BlocStatus.success,
        mainServiceResponse: success.data?.result,
        errorMessage: "",
      ));
    });
  }

  Future<void> _getGetTopOrderedSubServicesHandler(
      GetTopOrderedSubServicesEvent e, Emitter emitter) async {
    emitter(state.copyWith(
        topOrderedSubServiceStatus: BlocStatus.loading, errorMessage: ""));

    final failureOrSuccess = await _getTopOrderedSubService(e.params);

    failureOrSuccess.fold((failure) {
      emitter(state.copyWith(
        topOrderedSubServiceStatus: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) {
      emitter(state.copyWith(
        topOrderedSubServiceStatus: BlocStatus.success,
        topOrderedsubServiceResponse: success.data?.result,
        errorMessage: "",
      ));
    });
  }

  Future<void> _getGetTopRatedProvidersHandler(
      GetTopRatedProvidersEvent e, Emitter emitter) async {
    emitter(state.copyWith(
        topRatedProvidersStatus: BlocStatus.loading, errorMessage: ""));

    final failureOrSuccess = await _getTopRatedProviders(e.params);

    failureOrSuccess.fold((failure) {
      emitter(state.copyWith(
        topRatedProvidersStatus: (failure as ServerFailure).errorCode == "2"
            ? BlocStatus.success
            : BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorCode == "2"
            ? ""
            : (failure as ServerFailure).errorMessage,
      ));
    }, (success) {
      emitter(state.copyWith(
        topRatedProvidersStatus: BlocStatus.success,
        topRatedProviderResponse: success.data?.result,
        errorMessage: "",
      ));
    });
  }

  Future<void> _getSubServicesHandler(
      GetSubServicesEvent e, Emitter emitter) async {
    if (state.status == BlocStatus.loading) return;
    emitter(state.copyWith(status: BlocStatus.loading, errorMessage: ""));

    final failureOrSuccess = await _getSubService(e.params);

    failureOrSuccess.fold((failure) {
      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) {
      emitter(state.copyWith(
        status: BlocStatus.success,
        errorMessage: "",
      ));

      // Navigate to subservice screen
      /*NavigationService.pushNamed(
          routeName: EtmamRoutesNames.subServicesPage,
          args: SubServicePageArgs(
              mainServiceName: e.params.mainServiceName,
              subServiceResponse: success.data!.result!));*/
      showModalBottomSheet(
        isScrollControlled: true,
        useRootNavigator: true,
        backgroundColor: Colors.transparent,
        context: NavigationService.navigatorKey.currentContext!,
        builder: (context) => EtmamSubServicesPage(
          subServicePageArgs: SubServicePageArgs(
            mainServiceName: e.params.mainServiceName,
            subServiceResponse: success.data!.result!,
          ),
        ),
      );
    });
  }

  Future<void> _getProvidersHandler(GetProviders e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading, errorMessage: ""));

    final failureOrSuccess = await _getServicesProvidersByService(e.params);

    failureOrSuccess.fold((failure) {
      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) {
      emitter(state.copyWith(
        status: BlocStatus.success,
        errorMessage: "",
      ));

      // Navigate to Providers screen

      NavigationService.pushNamed(
          routeName: EtmamRoutesNames.providersByService,
          args: ServicePageParams(response: success.data!.result!));
    });
  }

  Future<void> _getProviderDetailsHandler(
      GetProviderDetailsEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading, errorMessage: ""));

    final failureOrSuccess = await _getProviderDetails(e.params);

    failureOrSuccess.fold(
      (failure) {
        emitter(state.copyWith(
          status: BlocStatus.failure,
          errorMessage: (failure as ServerFailure).errorMessage,
        ));
      },
      (success) {
        emitter(state.copyWith(
          status: BlocStatus.success,
          errorMessage: "",
        ));

        // Navigate to Providers screen
        NavigationService.pushNamed(
          routeName: EtmamRoutesNames.providersDetails,
          args: success.data!.result!,
        );
      },
    );
  }

  Future<void> _chaneCityHandler(ChangeCityEvent e, Emitter emitter) async {
    add(
      GetMainServicesEvent(
        params: MainServiceParams(
          cityId: CommonProperties.cityId,
          pageIndex: "0",
          pageSize: "20",
        ),
      ),
    );
    add(
      GetTopOrderedSubServicesEvent(
        params: TopOrderedSubServiceParams(
          cityId: CommonProperties.cityId,
          pageSize: "4",
          pageIndex: "1",
        ),
      ),
    );

    add(
      GetTopRatedProvidersEvent(
        params: TopRatedProviderParams(
            cityId: CommonProperties.cityId, pageSize: "4", pageIndex: "1"),
      ),
    );

    add(FindByRequestTypeEventChangedCity());
  }

  Future<void> _getAdsDetailsHandler(GetAdsEvent e, Emitter emitter) async {
    emitter(state.copyWith(
        adsResponseStatus: BlocStatus.loading, errorMessage: ""));

    final failureOrSuccess = await _getAds(NoParams());

    failureOrSuccess.fold((failure) {
      emitter(state.copyWith(
        adsResponseStatus: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) {
      emitter(state.copyWith(
        adsResponseStatus: BlocStatus.success,
        adsResponse: success.data?.result,
        errorMessage: "",
      ));
    });
  }
}
