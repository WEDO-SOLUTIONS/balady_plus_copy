import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/dependency_injection/dependency_injection_exports.dart'
    show sl;
import '../../../../core/utils/common_functions.dart';
import '../../../../core/utils/constants/dialog_names.dart';
import '../../../../core/utils/constants/route_names.dart';
import '../../../../core/utils/constants/ux_cam_events.dart';
import '../../../_shared_feature_/shared_feature_exports.dart'
    show
        BottomSheetDialog,
        BottomSheetWithActions,
        DefaultAppBarWidget,
        FilterIcon;
import '../../objections_exports.dart'
    show
        AppBarSeachBar,
        GetRequestsEvent,
        ObjectionsBloc,
        RequestsFilterActions,
        RequestsList,
        RequestsLoadLookupsEvent,
        RequestsState,
        ResetRequestsFiltersEvent,
        SearchRequestsEvent;
import '../widgets/requests_filters_bottom_sheet.dart';

class ObjectionsPage extends StatefulWidget {
  const ObjectionsPage({super.key});

  @override
  State<ObjectionsPage> createState() => _ObjectionsPageState();
}

class _ObjectionsPageState extends State<ObjectionsPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    CommonFunctions.sendUXCamEvent(UXCamEvents.openObjectionsList);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ObjectionsBloc>(
      create: (context) => ObjectionsBloc()..add(GetRequestsEvent()),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: DefaultAppBarWidget(
            title: 'objections'.tr(),
            bottom: AppBarSeachBar(
              onChanged: (value) {
                context.read<ObjectionsBloc>().add(
                      SearchRequestsEvent(query: value),
                    );
              },
            ),
            actions: [
              BlocBuilder<ObjectionsBloc, RequestsState>(
                builder: (context, state) {
                  return FilterIcon(
                    onTap: () async {
                      CommonFunctions.sendUXCamEvent(
                          UXCamEvents.openObjectionsFilter);
                      context
                          .read<ObjectionsBloc>()
                          .add(RequestsLoadLookupsEvent());
                      final sortType = state.sortType;
                      final selectedRequestStatus = state.selectedRequestStatus;

                      final selectedRequestType = state.selectedRequestType;
                      final selectedRequestSubType =
                          state.selectedRequestSubType;
                      final selectedRequestDate = state.selectedRequestDate;

                      final bool? actionTaked =
                          await BottomSheetDialog.showDraggableSheet(
                        context,
                        dialogKeyName: DialogName.objectionsPageFilters,
                        currentRouteName: RouteName.objections,
                        child: BottomSheetWithActions(
                          title: "filters".tr(),
                          body: RequestsFilterBottomSheet(
                            requestsBloc: context.read<ObjectionsBloc>(),
                          ),
                          action: RequestsFilterActions(
                            requestsBloc: context.read<ObjectionsBloc>(),
                          ),
                        ),
                      );
                      if (actionTaked != true && context.mounted) {
                        context.read<ObjectionsBloc>().add(
                              ResetRequestsFiltersEvent(
                                  selectedSortType: sortType,
                                  selectedRequestStatus: selectedRequestStatus,
                                  selectedRequestType: selectedRequestType,
                                  selectedRequestSubType:
                                      selectedRequestSubType,
                                  selectedRequestDate: selectedRequestDate,
                                  dateForm: state.dateForm),
                            );
                      }
                    },
                  );
                },
              ),
            ],
          ),
          body: const Padding(
            padding: EdgeInsets.all(16),
            child: RequestsList(),
          ),
        );
      }),
    );
  }
}
