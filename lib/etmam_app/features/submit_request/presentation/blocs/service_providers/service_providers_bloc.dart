import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:balady_plus/etmam_app/core/errors/errors_exports.dart';
import 'package:balady_plus/etmam_app/core/utils/common_properties.dart';
import 'package:balady_plus/etmam_app/features/services/domain/entities/services/service_params.dart';
import 'package:balady_plus/etmam_app/features/services/domain/use_cases/get_services.dart';
import 'package:balady_plus/etmam_app/features/services/services_exports.dart'
    show ServiceResponse, ServiceItems;
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart' show BlocStatus;
part 'service_providers_event.dart';
part 'service_providers_state.dart';

class ServiceProvidersBloc
    extends Bloc<ServiceProvidersEvent, ServiceProvidersState> {
  final GetServicesProvidersByService _getServicesProvidersByService;
  final ScrollController scrollController;

  ServiceProvidersBloc(
      {required ServiceResponse response,
      String? selectedProviderId,
      required this.scrollController,
      required GetServicesProvidersByService getServicesProvidersByService})
      : _getServicesProvidersByService = getServicesProvidersByService,
        super(ServiceProvidersState(
            items: response.items,
            totalItemCount: response.totalItemCount,
            totalPageCount: response.totalPageCount,
            subServiceId: response.serviceId,
            nextPageIndex: 2)) {
    scrollController.addListener(_scrollListener);

    on<ServiceProvidersEvent>((event, emit) {});

    on<SelectServiceProviderEvent>(_selectServiceProvider);
    on<LoadMoreServices>(_loadMoreOrdersHandler);
    on<GetServicesReleationsEvent>(_getServicessHandler);
    on<SelectServiceProviderinitialEvent>((event, emit) {
      if (selectedProviderId != null) {
        ServiceItems? item = response.items
            ?.firstWhereOrNull((element) => element.id == selectedProviderId);
        item?.isSelected = true;
        emit(state.copyWith(selectedItem: item));
      }
    });

    add(SelectServiceProviderinitialEvent());
  }

  Future<void> _selectServiceProvider(
      SelectServiceProviderEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    List<ServiceItems>? items = state.items?.mapIndexed((index, item) {
      if (index == e.index) {
        item.isSelected = !(item.isSelected ?? false);
      } else {
        item.isSelected = false;
      }
      return item;
    }).toList();

    emitter(state.copyWith(
        status: BlocStatus.success,
        items: items,
        selectedItem: state.items?[e.index]));
  }

  Future<void> _getServicessHandler(
      GetServicesReleationsEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _getServicesProvidersByService(ServiceParams(
        cityId: CommonProperties.cityId,
        subServiceId: state.subServiceId ?? "",
        subServiceName: "",
        name: e.name,
        pageIndex: "1"));

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
        totalItemCount: success.data?.result?.totalItemCount,
        totalPageCount: success.data?.result?.totalPageCount,
        nextPageIndex: 2,
        errorMessage: "",
      ));
    });
  }

  Future<void> _loadMoreOrdersHandler(
      LoadMoreServices e, Emitter emitter) async {
    if (state.nextPageIndex > (state.totalPageCount ?? 0)) {
      emitter(state.copyWith(status: BlocStatus.success));
      return;
    }

    emitter(state.copyWith(status: BlocStatus.loadMore));

    final failureOrSuccess = await _getServicesProvidersByService(ServiceParams(
        cityId: CommonProperties.cityId,
        subServiceId: state.subServiceId ?? "",
        subServiceName: "",
        pageIndex: state.nextPageIndex.toString()));

    failureOrSuccess.fold((failure) {
      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) {
      List<ServiceItems> newItems = success.data?.result?.items ?? [];
      List<ServiceItems> oldItems = state.items ?? [];

      List<ServiceItems> newList = [];
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
      add(LoadMoreServices());
    }
  }
}
