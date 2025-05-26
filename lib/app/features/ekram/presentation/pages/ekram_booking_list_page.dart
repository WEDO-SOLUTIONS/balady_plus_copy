import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/app/features/ekram/ekram_exports.dart'
    show
        EkramBookingCardWidget,
        TransportRequestsBloc,
        EkramRequestsState,
        GetCemetryRequestDetailsEvent,
        GetCemetryRequestsEvent,
        GetMoreCemetryRequestsEvent,
        getDummyEkramBookingList;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../etmam_app/core/utils/utils_exports.dart' show trans;
import '../../../../core/dependency_injection/injection_container.dart';
import '../../../../core/services/local/navigation_services.dart';
import '../../../../core/utils/common_functions.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../core/utils/constants/ux_cam_events.dart';
import '../../../../core/utils/debouncer.dart';
import '../../../../core/utils/enums/bloc_status.dart';
import '../../../_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../_shared_feature_/presentation/widgets/custom_shimmer_list_widget.dart';
import '../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/default_appbar_widget.dart';
import '../../../_shared_feature_/presentation/widgets/empty_state_widget.dart';
import '../../../_shared_feature_/presentation/widgets/need_login_widget.dart';
import '../../../_shared_feature_/presentation/widgets/reload_widget.dart';
import '../../../_shared_feature_/presentation/widgets/search_text_field_widget.dart';
import '../../../home_page/presentation/widgets/home_app_bar/circle_icon.dart';

class EkramBookingListPage extends StatefulWidget {
  const EkramBookingListPage({Key? key}) : super(key: key);

  @override
  State<EkramBookingListPage> createState() => _EkramBookingListPageState();
}

class _EkramBookingListPageState extends State<EkramBookingListPage> {
  final ScrollController _scrollContrller = ScrollController();
  final _debouncer = Debouncer(milliseconds: 500);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CommonFunctions.sendUXCamEvent(UXCamEvents.selectAndReserveACemeteryList);

    CommonFunctions.sendUXCamEvent(
        UXCamEvents.SelectAndReserveCemetery_List_Enter_Page_Event);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TransportRequestsBloc(
          getDeceasedTransportRequests: sl(),
          isDriver: false)
        ..add(GetCemetryRequestsEvent()),
      child: BlocConsumer<TransportRequestsBloc, EkramRequestsState>(
        listener: (context, state) {
          if (state.cemetryListStatus == BlocStatus.failure ||
              state.status == BlocStatus.failure) {
            CommonFunctions.showError(state.errorMessage ?? "");
          }

          if (state.cemetryListStatus == BlocStatus.initial) {
            _scrollContrller.addListener(() {
              if (_scrollContrller.position.maxScrollExtent ==
                  _scrollContrller.offset) {
                context
                    .read<TransportRequestsBloc>()
                    .add(GetMoreCemetryRequestsEvent());
              }
            });
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: DefaultAppBarWidget(
              title: trans('cemetery_booking_requests'),
              actions: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: InkWell(
                    onTap: () {
                      NavigationService.navigatorKey.currentState!.pushNamed(
                          RouteName.EkramBookCemetryStartService,
                          arguments: context.read<TransportRequestsBloc>());
                    },
                    child: CircleIcon(
                      backgroundColor: AppColor.primary50Light,
                      icon: IconPath.add,
                      circleSize: 48.0,
                      iconSize: 30.0,
                    ),
                  ),
                )
              ],
            ),
            body: Stack(
              children: [
                Column(
                  children: [
                    const CustomVerticalSpace(height: 15),
                    Expanded(
                      child: ListView.builder(
                          itemCount:
                              (state.cemetryRequestItems?.length ?? 0) + 1,
                          controller: _scrollContrller,
                          itemBuilder: (ctx, index) {
                            if (index >=
                                (state.cemetryRequestItems?.length ?? 0)) {
                              if (state.cemetryListStatus ==
                                  BlocStatus.loadMore) {
                                return const SizedBox(
                                  height: 50,
                                  child: Center(
                                      child: CustomCircularLoadingWidget()),
                                );
                              } else {
                                return Container(height: 50);
                              }
                            }

                            return Column(
                              children: [
                                EkramBookingCardWidget(
                                  item: state.cemetryRequestItems![index],
                                  OnDetailsPress: () {
                                    context.read<TransportRequestsBloc>().add(
                                        GetCemetryRequestDetailsEvent(
                                            requestId: state
                                                .cemetryRequestItems![index]
                                                .requestUniqueKey!));
                                  },
                                ),
                                CustomVerticalSpace(
                                    height: index ==
                                            (state.cemetryRequestItems!.length -
                                                1)
                                        ? 30
                                        : 12)
                              ],
                            );
                          }),
                    ),
                    //  CustomVerticalSpace(height: 30)
                  ],
                ),
                if (state.cemetryListStatus == BlocStatus.loadingShimmer)
                  CustomShimmerListWidget(
                    height: 274,
                    itemCount: 3,
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  ),
                if (state.cemetryListStatus == BlocStatus.retry)
                  ReloadWidget(
                    onTab: () {
                      context
                          .read<TransportRequestsBloc>()
                          .add(GetCemetryRequestsEvent());
                    },
                  ),
                if (state.cemetryListStatus == BlocStatus.success &&
                    (state.cemetryRequestItems?.isEmpty ?? false))
                  EmptyListWidget(
                    title: trans("lbl_no_orders"),
                  ),
                if (state.cemetryListStatus == BlocStatus.loading ||
                    state.status == BlocStatus.loading)
                  CustomCircularLoadingWidget(),
              ],
            ),
          );
        },
      ),
    );
  }
}
