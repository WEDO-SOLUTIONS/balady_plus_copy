import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/etmam_app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart' show BlocStatus;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:balady_plus/etmam_app/core/utils/common_properties.dart';
import 'package:balady_plus/etmam_app/core/utils/enums/bloc_status.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show ProviderItem;
import 'package:balady_plus/etmam_app/features/home/home_exports.dart';
import 'package:balady_plus/etmam_app/features/providers/providers_exports.dart'
    show GetProviderDetails, ProviderDetailsParams;
import 'package:flutter/material.dart';

part 'provider_event.dart';
part 'provider_state.dart';

class ProvidersBloc extends Bloc<ProvidersEvent, ProviderState> {
  final GetTopRatedProviders _getTopRatedProviders;

  GetProviderDetails _getProviderDetails;
  final ScrollController scrollController;

  ProvidersBloc({
    //required ProviderResponse response,
    required GetTopRatedProviders getProvider,
    required GetProviderDetails getProviderDetails,
    required this.scrollController,
  })  : _getTopRatedProviders = getProvider,
        _getProviderDetails = getProviderDetails,
        super(ProviderState(
            // items: response.items,
            //
            // totalItemCount: response.totalItemCount,
            // totalPageCount: response.totalPageCount,

            // subServiceId: response.serviceId,
            //nextPageIndex: 2
            )) {
    on<ProvidersEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<GetPRoviderDetailsEvent>(_getProviderDetailsHandler);

    on<GetTopProvidersEvent>(_getGetTopRatedProvidersHandler);

    on<LoadMoreProviders>(_loadMoreProvidersHandler);

    add(GetTopProvidersEvent(
        params: TopRatedProviderParams(
            cityId: CommonProperties.cityId, pageSize: "10", pageIndex: "1")));

    scrollController.addListener(_scrollListener);
  }

  /* Future<void> _getGetServiceDetailsHandler(
      GetServiceDetailsEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _getServiceDetails(e.params);

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

      NavigationService.pushNamed(
          routeName: EtmamRoutesNames.serviceProvidersDetails,
          args: success.data?.result);
    });
  }*/

  Future<void> _getGetTopRatedProvidersHandler(
      GetTopProvidersEvent e, Emitter emitter) async {
    emitter(state.copyWith(
        name: e.params.name,
        status: e.params.name == null
            ? BlocStatus.loadingShimmer
            : BlocStatus.loading));

    final failureOrSuccess = await _getTopRatedProviders(e.params);

    failureOrSuccess.fold((failure) {
      BlocStatus? status = (failure as ServerFailure).errorCode != "2"
          ? BlocStatus.failure
          : BlocStatus.success;

      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: status == BlocStatus.success
            ? ""
            : (failure as ServerFailure).errorMessage,
        items: status == BlocStatus.success ? [] : state.items,
        totalItemCount: 0,
        totalPageCount: 0,
        nextPageIndex: 2,
      ));
    }, (success) {
      emitter(state.copyWith(
        status: BlocStatus.success,
        items: success.data?.result?.items,
        nextPageIndex: 2,
        totalItemCount: success.data?.result?.totalItemCount,
        totalPageCount: success.data?.result?.totalPageCount,
        errorMessage: "",
      ));
    });
  }

  Future<void> _getProviderDetailsHandler(
      GetPRoviderDetailsEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _getProviderDetails(e.params);

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
          routeName: EtmamRoutesNames.providersDetails,
          args: success.data!.result!);
    });
  }

  Future<void> _loadMoreProvidersHandler(
      LoadMoreProviders e, Emitter emitter) async {
    if (state.nextPageIndex > (state.totalPageCount ?? 0)) {
      emitter(state.copyWith(status: BlocStatus.success));
      return;
    }

    emitter(state.copyWith(status: BlocStatus.loadMore));

    final failureOrSuccess = await _getTopRatedProviders(TopRatedProviderParams(
        pageSize: "10",
        name: state.name,
        pageIndex: state.nextPageIndex.toString(),
        cityId: CommonProperties.cityId));

    failureOrSuccess.fold((failure) {
      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) {
      List<ProviderItem> newItems = success.data?.result?.items ?? [];
      List<ProviderItem> oldItems = state.items ?? [];

      List<ProviderItem> newList = [];
      for (int i = 0; i < oldItems.length; i++) {
        newList.add(oldItems[i]);
      }
      for (int i = 0; i < newItems.length; i++) {
        newList.add(newItems[i]);
      }

      emitter(state.copyWith(
        status: BlocStatus.success,
        items: newList,
        totalItemCount: success.data?.result?.totalItemCount,
        totalPageCount: success.data?.result?.totalPageCount,
        nextPageIndex: state.nextPageIndex + 1,
        errorMessage: "",
      ));
    });
  }

  void _scrollListener() {
    if (scrollController.position.maxScrollExtent == scrollController.offset) {
      add(LoadMoreProviders());
    }
  }
}
