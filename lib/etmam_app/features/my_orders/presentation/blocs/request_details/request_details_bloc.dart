import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/entities/form_data_response.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/use_cases/cancel_request.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/use_cases/get_form_view.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/use_cases/submit_order.dart';
import 'package:balady_plus/etmam_app/features/my_orders/domain/entities/order_details/request_details_page_params.dart';
import 'package:balady_plus/etmam_app/features/my_orders/domain/entities/order_details/request_details_response.dart';
import 'package:balady_plus/etmam_app/features/my_orders/domain/use_cases/get_request_details.dart';
import 'package:balady_plus/etmam_app/features/my_orders/presentation/blocs/my_requests/my_requests_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:balady_plus/etmam_app/core/errors/errors_exports.dart'
    show ServerFailure;

import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show OrderAction, PageTypes, RouteName, trans;

import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show ServicePageParams, showDialogWidget;

import 'package:balady_plus/etmam_app/features/my_orders/my_orders_exports.dart'
    show
        ActionParams,
        CancelOrderDialog,
        CancelOrderParams,
        GetOrdersParams,
        MoreDialog,
        OrderDetailsParams,
        RatingPageParams;

import 'package:balady_plus/etmam_app/features/services/services_exports.dart'
    show GetServicesProvidersByService, ServiceParams;

import '../../../../../../app/core/services/local/navigation_services.dart';
import '../../../../../../app/core/utils/constants/route_names.dart';
import '../../../../../../app/core/utils/enums/bloc_status.dart';

part 'request_details_event.dart';

part 'request_details_state.dart';

class RequestDetailsBloc
    extends Bloc<RequestDetailsEvent, RequestDetailsState> {
  final RequestDetailsPageParams args;
  final GetRequestDetails _getOrderDetails;
  final GetFormView _getFormView;
  final SubmitOrder _submitOrder;
  final CancelRequest _cancelRequest;
  RequestDetailsBloc({
    required this.args,
    required GetRequestDetails getOrderDetails,
    required GetFormView getFormView,
    required SubmitOrder submitOrder,
    required CancelRequest cancelRequest,
  })  : _getOrderDetails = getOrderDetails,
        _getFormView = getFormView,
        _submitOrder = submitOrder,
        _cancelRequest = cancelRequest,
        super(RequestDetailsState(response: args.response)) {
    on<RequestDetailsEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<ShowActionsEvent>(_getshowActionsHandler);
    on<RefreshPageHandlerEvent>(_refreshPageHandler);
    on<GetFormViewEvent>(_getFormViewHandler);
    on<SubmitOrderEvent>(_submitOrderHandler);

    on<CancelRequestEvent>(_cancelOrderHandler);
    add(GetFormViewEvent());
  }

  Future<void> _getshowActionsHandler(
      ShowActionsEvent e, Emitter emitter) async {
    if (e.params.allowedActions != null &&
        e.params.allowedActions!.isNotEmpty) {
      showDialogWidget(NavigationService.navigatorKey.currentContext!,
          headerText: trans('order_more_dialog_header'),
          haveBottomLine: true,
          isFullHeight: true,
          dialogBody: MoreDialog(
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
                showDialogWidget(NavigationService.navigatorKey.currentContext!,
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
          ));
    }
  }

  Future<void> _refreshPageHandler(
      RefreshPageHandlerEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _getOrderDetails(
        OrderDetailsParams(orderId: state.response?.requestId));

    failureOrSuccess.fold((f) {}, (r) {
      emitter(state.copyWith(
          status: BlocStatus.success,
          response: r.data?.result,
          errorMessage: ""));
    });
    add(GetFormViewEvent());
    args.myOrdersBloc
        .add(GetMyRequestsEvent(params: GetOrdersParams(pageIndex: "1")));
  }

  Future<void> _getFormViewHandler(GetFormViewEvent e, Emitter emitter) async {
    emitter(state.copyWith(formStatus: BlocStatus.loading));

    final failureOrSuccess = await _getFormView(state.response?.formId ?? "");

    failureOrSuccess.fold((failure) {
      emitter(state.copyWith(
        formStatus: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (r) {
      emitter(state.copyWith(
          formStatus: BlocStatus.success,
          formData: r.data?.result,
          errorMessage: ""));
    });
  }

  Future<void> _submitOrderHandler(SubmitOrderEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));
    final failureOrSuccess = await _submitOrder(state.response!.requestId!);
    failureOrSuccess.fold((failure) {
      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (r) {
      emitter(state.copyWith(status: BlocStatus.success, errorMessage: ""));

      if (r.data?.responseMessage != null) {
        CommonFunctions.showSuccess(r.data!.responseMessage!);
      }
      add(RefreshPageHandlerEvent());
    });
  }

  Future<void> _cancelOrderHandler(
      CancelRequestEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));
    final failureOrSuccess = await _cancelRequest(state.response!.requestId!);
    failureOrSuccess.fold((failure) {
      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (r) {
      emitter(state.copyWith(status: BlocStatus.success, errorMessage: ""));

      if (r.data?.responseMessage != null) {
        CommonFunctions.showSuccess(r.data!.responseMessage!);
      }
      add(RefreshPageHandlerEvent());
    });
  }
}
