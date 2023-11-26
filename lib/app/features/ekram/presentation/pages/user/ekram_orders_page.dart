import 'package:balady_new_app/app/core/core_exports.dart'
    show CustomAppBar, HeaderWithAllButtonWidget, RoutesNames, EmptyStateWidget;
import 'package:balady_new_app/app/core/dependency_injection/dependency_injection_exports.dart';
import 'package:balady_new_app/app/core/shared_widgets/custom_circular_loading_widget.dart';
import 'package:balady_new_app/app/core/shared_widgets/custom_shimmer_list_widget.dart';
import 'package:balady_new_app/app/core/shared_widgets/custom_spaces_widgets.dart'
    show CustomVerticalSpace;
import 'package:balady_new_app/app/core/shared_widgets/reload_widget.dart';
import 'package:balady_new_app/app/features/ekram/ekram_exports.dart'
    show
        EkramBookingCardWidget,
        EkramTransporationCardWidget,
        EkramRequestsBloc,
        GetDeceasedTransportRequestDetailsEvent,
        GetDeceasedTransportRequestsEvent,
        EkramRequestsState;
import 'package:balady_new_app/shared/core/services/services_exports.dart';
import 'package:balady_new_app/shared/core/utils/enums/bloc_status.dart';
import 'package:balady_new_app/shared/features/_shared_feature_/shared/shared_feature_exports.dart'
    show CustomShimmerHorizontalListWidget;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../etmam_app/core/utils/utils_exports.dart' show trans;

class EkramOrdersPage extends StatefulWidget {
  const EkramOrdersPage({Key? key}) : super(key: key);

  @override
  State<EkramOrdersPage> createState() => _EkramOrdersPageState();
}

class _EkramOrdersPageState extends State<EkramOrdersPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // value: sl<EkramRequestsBloc>(),
      create: (context) => EkramRequestsBloc(
          getDeceasedTransportRequests: sl(),
          getDeceasedTransportRequestDetails: sl(),
          getDeceasedDriverRequestDetails: sl(),
          getLookUp: sl(),
          getLocations: sl(),
          getStatus: sl(),
          isDriver: false),
      child: BlocConsumer<EkramRequestsBloc, EkramRequestsState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: CustomAppBar(
              title: trans('ekramOrders'),
              withCloseImg: true,
              actionImg: "add_ekram_button@3x.png",
              actionOnPress: () {
                NavigationService.navigatorKey.currentState!.pushNamed(
                    RoutesNames.ekramSelectRequestTypeScreen,
                    arguments: context.read<EkramRequestsBloc>());
              },
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  /* HeaderWithAllButtonWidget(
                                header: trans('cemetery_booking_requests'),
                                showAllButton: getDummyEkramBookingList.length > 0,
                                allOnPressed: () {
                                  NavigationService.navigatorKey.currentState!
                                      .pushNamed(RoutesNames.ekramBookingListScreen);
                                },
                              ),
                              CustomVerticalSpace(height: 16),
                              SizedBox(
                                height: 274.0,
                                child: PageView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: getDummyEkramBookingList.length,
                                  itemBuilder: (context, index) => EkramBookingCardWidget(
                                    ekramBookingItem: getDummyEkramBookingList[index],
                                  ),
                                ),
                              ),*/
                  HeaderWithAllButtonWidget(
                    header: trans('requests_transporting_deceased'),
                    showAllButton:
                        (state.deceasedRequestItems?.length ?? 0) > 0,
                    allOnPressed: () {
                      NavigationService.navigatorKey.currentState!
                          .pushNamed(RoutesNames.ekramTransportationListScreen);
                    },
                  ),
                  if (state.status == BlocStatus.success ||
                      state.status == BlocStatus.loading)
                    SizedBox(
                      height: 274.0,
                      child: PageView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: (state.deceasedRequestItems?.length ?? 0) > 3
                            ? 3
                            : (state.deceasedRequestItems?.length ?? 0),
                        itemBuilder: (context, index) =>
                            EkramTransporationCardWidget(
                          ekramTransportationItem:
                              state.deceasedRequestItems![index],
                          OnDetailsPress: () {
                            context.read<EkramRequestsBloc>().add(
                                GetDeceasedTransportRequestDetailsEvent(
                                    isDriver: false,
                                    requestId: state
                                        .deceasedRequestItems![index]
                                        .requestId!));
                          },
                        ),
                      ),
                    ),
                  if (state.status == BlocStatus.loadingShimmer)
                    CustomShimmerHorizontalListWidget(
                      height: 274,
                      width: MediaQuery.of(context).size.width - 32,
                      itemCount: 3,
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    ),
                  if (state.status == BlocStatus.retry)
                    ReloadWidget(
                      onTab: () {
                        context.read<EkramRequestsBloc>().add(
                            GetDeceasedTransportRequestsEvent(isDriver: false));
                      },
                    ),
                  if (state.status == BlocStatus.success &&
                      (state.deceasedRequestItems?.isEmpty ?? false))
                    EmptyStateWidget(
                      title: trans("lbl_no_orders"),
                    ),
                  if (state.status == BlocStatus.loading)
                    CustomCircularLoadingWidget(),
                  CustomVerticalSpace(height: 30)
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
