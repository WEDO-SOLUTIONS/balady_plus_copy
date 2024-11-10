import 'package:balady_plus/app/core/dependency_injection/dependency_injection_exports.dart';
import 'package:balady_plus/app/core/utils/constants/route_names.dart';

import 'package:balady_plus/app/features/ekram/ekram_exports.dart'
    show
        EkramBookingCardWidget,
        EkramTransporationCardWidget,
        TransportRequestsBloc,
        GetDeceasedTransportRequestDetailsEvent,
        GetDeceasedTransportRequestsEvent,
        EkramRequestsState;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../etmam_app/core/utils/utils_exports.dart' show trans;
import '../../../../../../etmam_app/features/_shared_feature_/shared/presentation/widgets/custom_app_bar_widget.dart';
import '../../../../../../etmam_app/features/_shared_feature_/shared/presentation/widgets/custom_shimmer_widget.dart';
import '../../../../../../etmam_app/features/_shared_feature_/shared/presentation/widgets/header_with_all_button_widget.dart';
import '../../../../../core/services/local/navigation_services.dart';
import '../../../../../core/utils/enums/bloc_status.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/empty_state_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/reload_widget.dart';

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
      create: (context) => TransportRequestsBloc(
          getDeceasedTransportRequests: sl(),
          isDriver: false),
      child: BlocConsumer<TransportRequestsBloc, EkramRequestsState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: CustomAppBar(
              title: trans('ekramOrders'),
              withCloseImg: true,
              actionImg: "add_ekram_button@3x.png",
              actionOnPress: () {
                NavigationService.navigatorKey.currentState!.pushNamed(
                    RouteName.ekramSelectRequestTypeScreen,
                    arguments: context.read<TransportRequestsBloc>());
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
                          .pushNamed(RouteName.ekramTransportationListScreen);
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
                            context.read<TransportRequestsBloc>().add(
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
                        context.read<TransportRequestsBloc>().add(
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
