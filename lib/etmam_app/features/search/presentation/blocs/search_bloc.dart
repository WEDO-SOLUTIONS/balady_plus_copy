import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:balady_plus/etmam_app/core/errors/errors_exports.dart'
    show ServerFailure;
import 'package:balady_plus/app/core/utils/utils_exports.dart';

import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show BlocStatus, RouteName;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/data/entities/services_page_params.dart';
import 'package:balady_plus/etmam_app/features/home/domain/entities/sub_services/sub_service_params.dart';
import 'package:balady_plus/etmam_app/features/home/home_exports.dart'
    show GetSubService;
import 'package:balady_plus/etmam_app/features/search/search_exports.dart'
    show SearchItem, SearchParams, GetSearchData;
import 'package:balady_plus/etmam_app/features/services/services_exports.dart';
import 'package:flutter/material.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final GetSearchData _getSearchData;
  final GetSubService _getSubService;
  final GetServicesProvidersByService _getServicesProvidersByService;
  final ScrollController scrollController;

  SearchBloc(
      {required GetSearchData getSearchData,
      required GetSubService getSubService,
      required this.scrollController,
      required GetServicesProvidersByService getServicesProvidersByService})
      : _getSearchData = getSearchData,
        _getSubService = getSubService,
        _getServicesProvidersByService = getServicesProvidersByService,
        super(SearchState(status: BlocStatus.initial)) {
    on<SearchEvent>((event, emit) {});

    on<GetSearchDataEvent>(_getSearchDataHandler);
    on<GetSubServiceEvent>(_getSubServicesHandler);
    on<GetProvidersEvent>(_getProvidersHandler);
    on<LoadMoreSearchDataEvent>(_loadMoreSearchDataHandler);

    scrollController.addListener(_scrollListener);

    //add(GetSearchDataEvent(params: SearchParams(pageIndex: "1", text: "")));
  }

  Future<void> _getSearchDataHandler(
      GetSearchDataEvent e, Emitter emitter) async {
    emitter(state.copyWith(
        status: BlocStatus.loadingShimmer, text: e.params?.text));

    final failureOrSuccess = await _getSearchData(
        e.params ?? SearchParams(pageIndex: "1", text: state.text ?? ""));

    failureOrSuccess.fold((failure) {
      bool clearItems = false;
      if ((failure as ServerFailure).statusCode == 400)
        emitter(state.copyWith(
          status: BlocStatus.failure,
          items: [],
          errorMessage: failure.errorMessage,
        ));
      else {
        emitter(state.copyWith(
          status: BlocStatus.retry,
          errorMessage: failure.errorMessage,
        ));
      }
    }, (success) {
      /*  List<SearchItem> currentItems = state.items ?? [];
      (e.loadMore)
          ? currentItems.addAll(success.data?.result?.items ?? [])
          : currentItems = success.data?.result?.items ?? [];
*/
      emitter(state.copyWith(
        status: BlocStatus.success,
        items: success.data?.result?.items,
        nextPageIndex: 2,
        totalPageCount: success.data?.result?.totalPageCount,
        totalItemCount: success.data?.result?.totalItemCount,
        errorMessage: "",
      ));
    });
  }

  Future<void> _getSubServicesHandler(
      GetSubServiceEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

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

      NavigationService.pushNamed(
          routeName: EtmamRoutesNames.subServicesPage,
          args: success.data!.result!);
    });
  }

  Future<void> _getProvidersHandler(
      GetProvidersEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

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
          args: ServicePageParams(
            response: success.data!.result!,
          ));
    });
  }

  Future<void> _loadMoreSearchDataHandler(
      LoadMoreSearchDataEvent e, Emitter emitter) async {
    if (state.nextPageIndex > (state.totalPageCount ?? 0)) {
      emitter(state.copyWith(status: BlocStatus.success));
      return;
    }
    emitter(state.copyWith(status: BlocStatus.loadMore));

    final failureOrSuccess = await _getSearchData(SearchParams(
        pageIndex: state.nextPageIndex.toString(), text: state.text ?? ""));

    failureOrSuccess.fold((failure) {
      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) {
      List<SearchItem> newItems = success.data?.result?.items ?? [];
      List<SearchItem> oldItems = state.items ?? [];

      List<SearchItem> newList = [];
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
      add(LoadMoreSearchDataEvent());
    }
  }
}
