import 'package:balady_plus/app/core/dependency_injection/dependency_injection_exports.dart';

import 'package:balady_plus/app/features/ekram/ekram_exports.dart'
    show
        EkramTransporationCardWidget,
        TransportRequestsBloc,
        ShowFilterEvent,
        GetDeceasedTransportRequestsEvent,
        GetMoreDeceasedTransportRequestsEvent,
        EkramRequestsState,
        GetDeceasedTransportRequestDetailsEvent;
import 'package:balady_plus/app/features/ekram/presentation/widgets/driver/request_card_widget.dart';
import 'package:balady_plus/etmam_app/core/utils/Debouncer.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/presentation/widgets/custom_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../etmam_app/core/utils/utils_exports.dart' show trans;
import '../../../../../../etmam_app/features/_shared_feature_/shared/presentation/widgets/custom_app_bar_widget.dart';
import '../../../../../core/services/local/helpers.dart';
import '../../../../../core/services/local/location_service.dart';
import '../../../../../core/utils/common_functions.dart';
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
import '../../../../objectable_transactions/presentation/widgets/app_bar_search_bar.dart';

class TransportRequestListPage extends StatefulWidget  {
  const TransportRequestListPage({Key? key}) : super(key: key);

  @override
  State<TransportRequestListPage> createState() =>
      _TransportRequestListPageState();
}

class _TransportRequestListPageState extends State<TransportRequestListPage> with SingleTickerProviderStateMixin {
  final ScrollController _scrollContrller = ScrollController();
  final _debouncer = Debouncer(milliseconds: 500);

  late final TabController _controller = TabController(
    vsync: this,
    length: tabs.length,
    initialIndex: selectedIndex,
  );
  int selectedIndex = 0;
  final List<Tab> tabs = <Tab>[
    const Tab(text: 'LEFT'),
    const Tab(text: 'RIGHT'),
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    CommonFunctions.sendUXCamEvent(UXCamEvents.listServiceFuneralCarDriver);
    CommonFunctions.checkLocationSettings(context);
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // sl<EkramLocationService>().stop();

    _controller.addListener(() {
      setState(() {
        if (selectedIndex != _controller.index) {
          selectedIndex = _controller.index;

        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TransportRequestsBloc(
          getDeceasedTransportRequests: sl(),
          isDriver: true)
        ..add(GetDeceasedTransportRequestsEvent(isDriver: true)),
      child: BlocConsumer<TransportRequestsBloc, EkramRequestsState>(
        listener: (context, state) {
          if (state.status == BlocStatus.failure) {
            CommonFunctions.showError(state.errorMessage ?? "");
          }

          if (state.status == BlocStatus.initial) {
            _scrollContrller.addListener(() {
              if (_scrollContrller.position.maxScrollExtent ==
                  _scrollContrller.offset) {
                context.read<TransportRequestsBloc>().add(GetMoreDeceasedTransportRequestsEvent(isDriver: true));
              }
            });
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: DefaultAppBarWidget(
              title: 'requests_transporting_deceased'.tr(),
              // bottom: AppBarSeachBar(
              //   onChanged: (value) {
              //     _debouncer.run(() {
              //       context.read<TransportRequestsBloc>().add(
              //           GetDeceasedTransportRequestsEvent(
              //               isDriver: true, text: value));
              //     });
              //   },
              // ),

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
                                  child: Center(child: CustomLoadingWidget()),
                                );
                              } else {
                                return Container(height: 50);
                              }
                            }

                            return Column(
                              children: [
                                RequestCardWidget(
                                  requestItemModel:
                                  state.deceasedRequestItems![index],

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
                  CustomCircularLoadingWidget(),

                if (state.status == BlocStatus.retry)
                  ReloadWidget(
                    onTab: () {
                      context.read<TransportRequestsBloc>().add(
                          GetDeceasedTransportRequestsEvent(isDriver: true));
                    },
                  ),
                if (state.status == BlocStatus.success &&
                    (state.deceasedRequestItems?.isEmpty ?? false))
                  EmptyListWidget(
                    title: trans("noTransportRequest"),
                  ),
                if (state.status == BlocStatus.loading)
                  CustomCircularLoadingWidget(),
              ],
            ),
          );
        },
      ),
    );
  }
}
