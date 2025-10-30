import 'package:balady_plus/app/core/dependency_injection/dependency_injection_exports.dart';

import 'package:balady_plus/app/features/ekram/ekram_exports.dart'
    show
        EkramTransporationCardWidget,
        EkramRequestsBloc,
        ShowFilterEvent,
        GetMoreDeceasedTransportRequestsEvent,
        GetDeceasedTransportRequestsEvent,
        EkramRequestsState,
        GetDeceasedTransportRequestDetailsEvent;
import 'package:balady_plus/etmam_app/core/utils/Debouncer.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../etmam_app/features/_shared_feature_/shared/presentation/widgets/custom_app_bar_widget.dart';
import '../../../../../core/services/local/navigation_services.dart';
import '../../../../../core/utils/common_functions.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../../core/utils/constants/route_names.dart';
import '../../../../../core/utils/constants/ux_cam_events.dart';
import '../../../../../core/utils/enums/bloc_status.dart';
import '../../../../_shared_feature_/presentation/icons/filter_icon.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_shimmer_list_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/default_appbar_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/empty_state_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/need_login_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/reload_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/search_text_field_widget.dart';
import '../../../../home_page/presentation/widgets/home_app_bar/circle_icon.dart';
import '../../../../objectable_transactions/presentation/widgets/app_bar_search_bar.dart';
import '../../../../objections/presentation/objections_bloc/objections_bloc.dart';

class EkramTransportationListPage extends StatefulWidget {
  const EkramTransportationListPage({Key? key}) : super(key: key);

  @override
  State<EkramTransportationListPage> createState() =>
      _EkramTransportationListPageState();
}

class _EkramTransportationListPageState
    extends State<EkramTransportationListPage> {
  final ScrollController _scrollContrller = ScrollController();
  final _debouncer = Debouncer(milliseconds: 500);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CommonFunctions.checkLocationSettings(context);

    CommonFunctions.sendUXCamEvent(UXCamEvents.listServiceBodyTransportation);
    CommonFunctions.sendUXCamEvent(UXCamEvents
        .RequestsTransportingAndPreparingDeceased_List_Enter_Page_Event);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EkramRequestsBloc(
          getDeceasedTransportRequests: sl(),
          getDeceasedTransportRequestDetails: sl(),
          getDeceasedDriverRequestDetails: sl(),
          getLookUp: sl(),
          getLocations: sl(),
          getStatus: sl(),
          isDriver: false)
        ..add(GetDeceasedTransportRequestsEvent(isDriver: false)),
      child: BlocConsumer<EkramRequestsBloc, EkramRequestsState>(
        listener: (context, state) {
          if (state.status == BlocStatus.failure) {
            CommonFunctions.showError(state.errorMessage ?? "");
          }

          if (state.status == BlocStatus.initial) {
            _scrollContrller.addListener(() {
              if (_scrollContrller.position.maxScrollExtent ==
                  _scrollContrller.offset) {
                context
                    .read<EkramRequestsBloc>()
                    .add(GetMoreDeceasedTransportRequestsEvent(isDriver: true));
              }
            });
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: DefaultAppBarWidget(
              title: 'ekram_benf_transport'.tr(),
              bottom: AppBarSeachBar(
                onChanged: (value) {
                  _debouncer.run(() {
                    context.read<EkramRequestsBloc>().add(
                        GetDeceasedTransportRequestsEvent(
                            isDriver: false, text: value));
                  });
                },
              ),
              actions: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: InkWell(
                    onTap: () => NavigationService.navigatorKey.currentState!
                        .pushNamed(
                            RouteName.EkramRequestTransportationStartService,
                            arguments: context.read<EkramRequestsBloc>()),
                    child: CircleIcon(
                      backgroundColor: AppColor.primary50Light,
                      icon: IconPath.add,
                      circleSize: 48.0,
                      iconSize: 30.0,
                    ),
                  ),
                ),
                FilterIcon(
                  onTap: () async {
                    context.read<EkramRequestsBloc>().add(ShowFilterEvent());
                  },
                ),
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
                              (state.deceasedRequestItems?.length ?? 0) + 1,
                          controller: _scrollContrller,
                          itemBuilder: (ctx, index) {
                            if (index >=
                                (state.deceasedRequestItems?.length ?? 0)) {
                              if (state.status == BlocStatus.loadMore) {
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
                                CustomVerticalSpace(
                                    height: index ==
                                            (state.deceasedRequestItems!
                                                    .length -
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
                if (state.status == BlocStatus.loadingShimmer)
                  CustomShimmerListWidget(
                    height: 274,
                    itemCount: 3,
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                  EmptyListWidget(
                    title: ("lbl_no_orders").tr(),
                  ),
                if (state.status == BlocStatus.loading)
                  const CustomCircularLoadingWidget(),
              ],
            ),
          );
        },
      ),
    );
  }
}
