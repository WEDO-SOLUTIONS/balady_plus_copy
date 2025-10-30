import 'package:balady_plus/etmam_app/core/dependency_injection/injection_container.dart'
    show sl;
import 'package:balady_plus/etmam_app/features/my_orders/presentation/blocs/my_requests/my_requests_bloc.dart';

import 'package:balady_plus/etmam_app/core/services/services_exports.dart'
    show AppEvents;

import 'package:balady_plus/etmam_app/features/my_orders/my_orders_exports.dart'
    show
        CancelOrderDialog,
        CancelOrderParams,
        GetOrdersParams,
        OrderCardWidget,
        OrderDetailsParams,
        OrdersTabsWidget,
        RatingPageParams;
import 'package:balady_plus/etmam_app/features/my_orders/presentation/blocs/my_orders/my_orders_bloc.dart';
import 'package:balady_plus/etmam_app/features/services/services_exports.dart'
    show ServiceParams;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/core/services/local/navigation_services.dart';
import '../../../../../app/core/utils/constants/route_names.dart';
import '../../../../../app/core/utils/enums/auth_status.dart';
import '../../../../../app/core/utils/enums/bloc_status.dart';
import '../../../../../app/features/entry_point/presentation/cubit/auth_cubit.dart';
import '../../../../core/utils/utils_exports.dart'
    show
        AppColorsTheme,
        CommonFunctions,
        CommonProperties,
        IconPath,
        OrderAction,
        trans;
import '../../../_shared_feature_/shared/shared_feature_exports.dart'
    show
        CustomAppBar,
        CustomLoadingWidget,
        CustomShimmerListWidget,
        EmptyStateWidget,
        NeedLoginWidget,
        ReloadWidget,
        showDialogWidget;

class RequestsPage extends StatefulWidget {
  const RequestsPage({Key? key}) : super(key: key);

  @override
  State<RequestsPage> createState() => _RequestsPage();
}

class _RequestsPage extends State<RequestsPage> {
  final ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    CommonFunctions.sendEventToAnalytics(AppEvents.MyOrders);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: trans('orders_app_bar'),
        ),
        body: BlocProvider<MyRequestsBloc>(
          create: (context) {
            return MyRequestsBloc(
                getMyOrders: sl(),
                getOrderDetails: sl(),
                getRequestDetails: sl(),
                getServicesProvidersByService: sl(),
                scrollController: _scrollController);
          },
          child: BlocConsumer<MyRequestsBloc, MyRequestsState>(
            listener: (context, state) {
              if (state.status == BlocStatus.failure ||
                  state.status == BlocStatus.retry) {
                CommonFunctions.showError(state.errorMessage ?? "");
              }
            },
            builder: (context, state) {
              return !CommonProperties.isUserLogged
                  ? NeedLoginWidget(
                      onSuccessLogin: (bool? isSuccess) {
                        context.read<MyRequestsBloc>().add(GetMyRequestsEvent(
                            params: GetOrdersParams(pageIndex: "1")));
                      },
                    )
                  : Stack(
                      children: [
                        Column(
                          children: [
                            Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: const Center(child: OrdersTabsWidget())),
                            if (state.status == BlocStatus.success ||
                                state.status == BlocStatus.loadMore ||
                                state.status == BlocStatus.loading ||
                                state.status == BlocStatus.failure)
                              Expanded(
                                child: (state.items?.length ?? 0) <= 0
                                    ? EmptyStateWidget(
                                        img: IconPath.emptyOrdersLogo,
                                        title: trans('empty_orders_title'),
                                        desc: state.closed == null
                                            ? trans('empty_orders_desc')
                                            : state.closed == true
                                                ? trans(
                                                    'empty_completed_orders_desc')
                                                : trans(
                                                    "empty_inProgress_orders_desc"))
                                    : RefreshIndicator(
                                        color: AppColorsTheme.primary700,
                                        onRefresh: () async {
                                          context.read<MyRequestsBloc>().add(
                                              GetMyRequestsEvent(
                                                  params: GetOrdersParams(
                                                      pageIndex: "1",
                                                      closed: state.closed)));
                                        },
                                        child: ListView.builder(
                                            controller: _scrollController,
                                            padding: const EdgeInsets.only(
                                                right: 16,
                                                left: 16,
                                                bottom: 24),
                                            itemCount:
                                                (state.items?.length ?? 0) + 1,
                                            itemBuilder: (ctx, index) {
                                              if (index >=
                                                  (state.items?.length ?? 0)) {
                                                if (state.status ==
                                                    BlocStatus.loadMore) {
                                                  return const SizedBox(
                                                    height: 50,
                                                    child: Center(
                                                        child:
                                                            CustomLoadingWidget()),
                                                  );
                                                } else {
                                                  return Container(height: 50);
                                                }
                                              }
                                              return OrderCardWidget(
                                                tag: state.items?[index]
                                                    .getPendingRequsetTag(),
                                                orderId: state.items?[index]
                                                        .requestId ??
                                                    "",
                                                orderNo: state.items?[index]
                                                    .requestNumber,
                                                statusText: state
                                                    .items?[index].statusName,
                                                orderType: state.items?[index]
                                                    .mainServiceName,
                                                orderServices: state
                                                        .items?[index]
                                                        .subServiceName ??
                                                    "",
                                                date: state.items?[index]
                                                    .getCreatedDate(),
                                                actions: [],
                                                /* orderStatus: CommonFunctions
                                                    .getOrderStatus(state
                                                        .items?[index]
                                                        .status
                                                        ?.id
                                                        ),*/
                                                onPress: () {
                                                  context
                                                      .read<MyRequestsBloc>()
                                                      .add(GetRequestDetailsEvent(
                                                          params: OrderDetailsParams(
                                                              type: state
                                                                  .items?[index]
                                                                  .requestTypeId,
                                                              orderId: state
                                                                  .items?[index]
                                                                  .internalId),
                                                          requestTypeName: state
                                                              .items?[index]
                                                              .requestTypeName));
                                                },
                                                onSelectMore:
                                                    (OrderAction action) {
                                                  if (action ==
                                                      OrderAction.rate) {
                                                    NavigationService.pushNamed(
                                                      routeName: EtmamRoutesNames
                                                          .evaluateOrderRoute,
                                                      args: RatingPageParams(
                                                        //logoUrl: "",
                                                        refresh: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                          context
                                                              .read<
                                                                  MyRequestsBloc>()
                                                              .add(GetMyRequestsEvent(
                                                                  params: GetOrdersParams(
                                                                      pageIndex:
                                                                          "1",
                                                                      closed: state
                                                                          .closed)));
                                                        },
                                                        orderId: state
                                                            .items?[index]
                                                            .requestNumber,
                                                      ),
                                                    );
                                                  }
                                                },
                                              );
                                            }),
                                      ),
                              ),
                            if (state.status == BlocStatus.retry)
                              ReloadWidget(
                                  widgetHeight: 225,
                                  onTab: () {
                                    context.read<MyRequestsBloc>().add(
                                        GetMyRequestsEvent(
                                            params: GetOrdersParams(
                                                pageIndex: "1",
                                                closed: state.closed)));
                                  }),
                            if (state.status == BlocStatus.loadingShimmer)
                              const Expanded(
                                child: CustomShimmerListWidget(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  height: 225,
                                  itemCount: 10,
                                ),
                              ),
                          ],
                        ),
                        BlocBuilder<EntryPointCubit, EntryPointState>(
                            bloc: sl(),
                            builder: (context, authState) {
                              return (state.status == BlocStatus.loading ||
                                      authState.status == AuthStatus.loading)
                                  ? const CustomLoadingWidget()
                                  : Container();
                            })
                      ],
                    );
            },
          ),
        ));
  }
}
