import 'package:balady_plus/etmam_app/features/my_orders/domain/use_cases/get_my_requests_old.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:balady_plus/etmam_app/core/errors/errors_exports.dart'
    show ServerFailure;

import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/data/entities/services_page_params.dart';
import 'package:balady_plus/etmam_app/features/my_orders/domain/entities/order_details/order_details_page_params.dart';
import 'package:balady_plus/etmam_app/features/my_orders/domain/entities/order_details/order_details_params.dart';
import 'package:balady_plus/etmam_app/features/my_orders/domain/use_cases/get_order_details.dart';
import 'package:balady_plus/etmam_app/features/my_orders/my_orders_exports.dart'
    show OrderItem, GetOrdersParams, CancelOrder;
import 'package:balady_plus/etmam_app/features/services/services_exports.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../../app/core/services/local/navigation_services.dart';
import '../../../../../../app/core/utils/constants/route_names.dart';
import '../../../../../../app/core/utils/enums/bloc_status.dart';

part 'my_orders_event.dart';

part 'my_orders_state.dart';

class MyOrdersBloc extends Bloc<MyOrdersEvent, MyOrdersState> {
  final GetMyOrders _getMyOrders;
  final CancelOrder _cancelOrder;
  final GetOrderDetails _getOrderDetails;

  GetServicesProvidersByService _getServicesProvidersByService;

  final ScrollController scrollController;
  MyOrdersBloc(
      {required GetMyOrders getMyOrders,
      required CancelOrder cancelOrder,
      required GetOrderDetails getOrderDetails,
      required GetServicesProvidersByService getServicesProvidersByService,
      required this.scrollController})
      : _getServicesProvidersByService = getServicesProvidersByService,
        _cancelOrder = cancelOrder,
        _getMyOrders = getMyOrders,
        _getOrderDetails = getOrderDetails,
        super(MyOrdersState()) {
    on<MyOrdersEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<GetMyOrdersEvent>(_getMyOrdersHandler);
    if (CommonProperties.isUserLogged)
      add(GetMyOrdersEvent(params: GetOrdersParams(pageIndex: "1")));

    on<LoadMoreOrders>(_loadMoreOrdersHandler);
    on<ClearEvent>(_clearHandler);
    on<GetProvidersEvent>(_getProvidersHandler);

    on<GetOrderDetailsEvent>(_getOrderDetailsHandler);

    scrollController.addListener(_scrollListener);

    // on<CencelOrderEvent>(_cancelOrderHandler);
  }

  Future<void> _getMyOrdersHandler(GetMyOrdersEvent e, Emitter emitter) async {
    emitter(state.copyWith(
      status: BlocStatus.loadingShimmer,
      // closed: e.params.closed,
      // clearClose: e.params.closed == null ? true : false,
    ));

    final failureOrSuccess = await _getMyOrders(e.params);
    failureOrSuccess.fold((failure) {
      BlocStatus? status = (failure as ServerFailure).errorCode != "2"
          ? BlocStatus.retry
          : BlocStatus.failure;

      String? error = (failure as ServerFailure).errorCode != "2"
          ? (failure as ServerFailure).errorMessage
          : "";

      emitter(state.copyWith(
        status: status,
        closed: e.params.closed,
        items: [],
        totalItemCount: 0,
        totalPageCount: 0,
        clearClose: e.params.closed == null ? true : false,
        nextPageIndex: 1,
        errorMessage: error,
      ));
    }, (success) {
      emitter(state.copyWith(
        status: BlocStatus.success,
        items: success.data?.result?.items,
        totalItemCount: success.data?.result?.totalItemCount,
        totalPageCount: success.data?.result?.totalPageCount,
        nextPageIndex: (int.tryParse(e.params.pageIndex) ?? 0) + 1,
        closed: e.params.closed,
        clearClose: e.params.closed == null ? true : false,
        errorMessage: "",
      ));
    });
  }

  Future<void> _loadMoreOrdersHandler(LoadMoreOrders e, Emitter emitter) async {
    if (state.nextPageIndex > (state.totalPageCount ?? 0)) {
      emitter(state.copyWith(status: BlocStatus.success));
      return;
    }
    emitter(state.copyWith(status: BlocStatus.loadMore));

    final failureOrSuccess = await _getMyOrders(GetOrdersParams(
        pageIndex: state.nextPageIndex.toString(), closed: state.closed));

    failureOrSuccess.fold((failure) {
      /*  String? error = (failure as ServerFailure).errorCode != "2"
          ? (failure as ServerFailure).errorMessage
          : "";*/
      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) {
      List<OrderItem> newItems = success.data?.result?.items ?? [];
      List<OrderItem> oldItems = state.items ?? [];

      List<OrderItem> newList = [];
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

  Future<void> _clearHandler(ClearEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    emitter(MyOrdersState(status: BlocStatus.initial));
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
              changeProvider: true,
              callBack: e.callBack,
              orderId: e.orderId));
    });
  }

  Future<void> _getOrderDetailsHandler(
      GetOrderDetailsEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _getOrderDetails(e.params);

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
      /*  NavigationService.pushNamed(
          routeName: EtmamRoutesNames.orderDetailsRoute,
          args: OrderDetailsPageParams(
              response: success.data?.result, myOrdersBloc: this));*/
    });
  }

  void _scrollListener() {
    if (scrollController.position.maxScrollExtent == scrollController.offset) {
      add(LoadMoreOrders());
    }
  }
}
