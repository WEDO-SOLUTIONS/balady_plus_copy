import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/components/bottom_sheets/bottom_sheet_with_actions.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/dialogs/bottom_sheet_dialogs.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:balady_plus/etmam_app/core/errors/errors_exports.dart'
    show ServerFailure;
import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show OrderAction, PageTypes, RouteName, trans;
import 'package:balady_plus/app/core/utils/utils_exports.dart';

import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show ServicePageParams, showDialogWidget;

import 'package:balady_plus/etmam_app/features/my_orders/my_orders_exports.dart'
    show
        ActionParams,
        CancelOrderDialog,
        CancelOrderParams,
        GetOrderDetails,
        GetOrdersParams,
        MoreDialog,
        OrderDetailsPageParams,
        OrderDetailsParams,
        RatingPageParams;
import 'package:balady_plus/etmam_app/features/my_orders/domain/entities/order_details/order_details_response.dart';
import 'package:balady_plus/etmam_app/features/my_orders/presentation/blocs/my_orders/my_orders_bloc.dart';
import 'package:balady_plus/etmam_app/features/services/services_exports.dart'
    show GetServicesProvidersByService, ServiceParams;

part 'order_details_event.dart';

part 'order_details_state.dart';

class OrderDetailsBloc extends Bloc<OrderDetailsEvent, OrderDetailsState> {
  final OrderDetailsPageParams args;
  GetServicesProvidersByService _getServicesProvidersByService;
  GetOrderDetails _getOrderDetails;

  OrderDetailsBloc({
    required this.args,
    required GetServicesProvidersByService getServicesProvidersByService,
    required GetOrderDetails getOrderDetails,
  })  : _getServicesProvidersByService = getServicesProvidersByService,
        _getOrderDetails = getOrderDetails,
        super(OrderDetailsState(response: args.response)) {
    on<OrderDetailsEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<GetProvidersEvent>(_getProvidersHandler);
    on<ShowActionsEvent>(_getshowActionsHandler);
    on<RefreshPageHandlerEvent>(_refreshPageHandler);
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
              orderId: e.orderId,
              pageType: PageTypes.orderDetails,
              callBack: () {
                add(RefreshPageHandlerEvent());
              }));
    });
  }

  Future<void> _getshowActionsHandler(
      ShowActionsEvent e, Emitter emitter) async {
    if (e.params.allowedActions != null &&
        e.params.allowedActions!.isNotEmpty) {
      BottomSheetDialog.showDraggableSheet(
          NavigationService.navigatorKey.currentContext!,
          isFullHeight: false,
          // headerText: trans('order_more_dialog_header'),
          child: BottomSheetWithActions(
            title: 'الاجراءات',
            body: MoreDialog(
              actions: e.params.allowedActions!,
              orderId: e.params.orderId!,
              //   refresh: refresh,
              onSelect: (OrderAction action) {
                NavigationService.navigatorKey.currentState?.pop();
                if (action == OrderAction.rate) {
                  NavigationService.pushNamed(
                      routeName: EtmamRoutesNames.evaluateOrderRoute,
                      args: RatingPageParams(
                          //logoUrl: "",
                          orderId: e.params.orderId!,
                          refresh: () async {
                            add(RefreshPageHandlerEvent());
                          }
                          // providerName: ""
                          ));
                }

                if (action == OrderAction.update) {
                  add(GetProvidersEvent(
                    orderId: e.params.orderId!,
                    params: ServiceParams(
                        cityId: args.response?.cityId ?? "",
                        pageIndex: "1",
                        subServiceId: e.params.subServiceId ?? "",
                        subServiceName: e.params.subServiceName ?? ""),
                  ));
                }
                if (action == OrderAction.cancel) {
                  showDialogWidget(
                      NavigationService.navigatorKey.currentContext!,
                      headerText: trans('etmam_cancel_order'),
                      haveBottomLine: true,
                      isFullHeight: true,
                      dialogBody: CancelOrderDialog(
                        refresh: () {
                          add(RefreshPageHandlerEvent());
                        },
                        params: CancelOrderParams(orderId: e.params.orderId!),
                      ));
                }
              },
            ),
          ));
    }
  }

  Future<void> _refreshPageHandler(
      RefreshPageHandlerEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess =
        await _getOrderDetails(OrderDetailsParams(orderId: state.response?.id));

    failureOrSuccess.fold((f) {}, (r) {
      emitter(
          state.copyWith(status: BlocStatus.success, response: r.data?.result));
    });

    args.myOrdersBloc
        .add(GetMyOrdersEvent(params: GetOrdersParams(pageIndex: "1")));
  }
}
