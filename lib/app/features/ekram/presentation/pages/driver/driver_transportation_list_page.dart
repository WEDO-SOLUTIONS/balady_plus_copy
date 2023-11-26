import 'package:balady_new_app/app/core/core_exports.dart'
    show CustomAppBar, SearchTextFieldWidget, EmptyStateWidget;
import 'package:balady_new_app/app/core/dependency_injection/dependency_injection_exports.dart';
import 'package:balady_new_app/app/core/shared_local_services/helpers.dart';
import 'package:balady_new_app/app/core/shared_widgets/custom_circular_loading_widget.dart';
import 'package:balady_new_app/app/core/shared_widgets/custom_shimmer_list_widget.dart';
import 'package:balady_new_app/app/core/shared_widgets/custom_spaces_widgets.dart'
    show CustomVerticalSpace;
import 'package:balady_new_app/app/core/shared_widgets/reload_widget.dart';
import 'package:balady_new_app/app/features/ekram/ekram_exports.dart'
    show
        EkramTransporationCardWidget,
        EkramRequestsBloc,
        ShowFilterEvent,
        GetDeceasedTransportRequestsEvent,
        GetMoreDeceasedTransportRequestsEvent,
        EkramRequestsState,
        GetDeceasedTransportRequestDetailsEvent;
import 'package:balady_new_app/app/features/ekram/presentation/widgets/ekram_driver_request_card_widget.dart';
import 'package:balady_new_app/etmam_app/core/utils/Debouncer.dart';
import 'package:balady_new_app/etmam_app/core/utils/common_functions.dart';
import 'package:balady_new_app/etmam_app/features/_shared_feature_/shared/presentation/widgets/custom_loading_widget.dart';
import 'package:balady_new_app/shared/core/utils/enums/bloc_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../etmam_app/core/utils/utils_exports.dart' show trans;

class DriverEkramTransportationListPage extends StatefulWidget {
  const DriverEkramTransportationListPage({Key? key}) : super(key: key);

  @override
  State<DriverEkramTransportationListPage> createState() =>
      _DriverEkramTransportationListPageState();
}

class _DriverEkramTransportationListPageState
    extends State<DriverEkramTransportationListPage> {
  final ScrollController _scrollContrller = ScrollController();
  final _debouncer = Debouncer(milliseconds: 500);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Helpers.checkLocationSettings(context);
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
          isDriver: true),
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
            appBar: CustomAppBar(
              title: trans('requests_transporting_deceased'),
              withBackImg: true,
              // actionImg: "filter2@3x.png",
              /* actionOnPress: () async {
                context.read<EkramRequestsBloc>().add(ShowFilterEvent());
              },*/
            ),
            body: Stack(
              children: [
                Column(
                  children: [
                    const CustomVerticalSpace(height: 15),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: SearchTextFieldWidget(
                        hintText: trans('search_for_order'),
                        onTextChanged: (String v) {
                          _debouncer.run(() {
                            context.read<EkramRequestsBloc>().add(
                                GetDeceasedTransportRequestsEvent(
                                    isDriver: true, text: v));
                          });
                        },
                        onSubmitSearch: (String text) {
                          context.read<EkramRequestsBloc>().add(
                              GetDeceasedTransportRequestsEvent(
                                  isDriver: true, text: text));
                        },
                        containerHeight: 52,
                      ),
                    ),
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
                                EkramDriverRequestCardWidget(
                                  ekramTransportationItem:
                                      state.deceasedRequestItems![index],
                                  OnDetailsPress: () {
                                    context.read<EkramRequestsBloc>().add(
                                        GetDeceasedTransportRequestDetailsEvent(
                                            isDriver: true,
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
                          GetDeceasedTransportRequestsEvent(isDriver: true));
                    },
                  ),
                if (state.status == BlocStatus.success &&
                    (state.deceasedRequestItems?.isEmpty ?? false))
                  EmptyStateWidget(
                    title: trans("lbl_no_orders"),
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
