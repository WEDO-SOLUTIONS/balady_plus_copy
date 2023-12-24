import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../../core/utils/app_analytics_events.dart';
import '../../../../../core/utils/constants/dialog_names.dart';
import '../../../../../core/utils/constants/ux_cam_events.dart';
import '../../../../../core/utils/utils_exports.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart'
    show
        BottomSheetDialog,
        BottomSheetWithActions,
        DefaultAppBarWidget,
        FilterIcon;
import '../../violations_exports.dart'
    show
        GetViolationsEvent,
        ViolationsBloc,
        ViolationsFilterActions,
        ViolationList,
        ViolationsLoadLookupsEvent,
        ViolationsState,
        ResetViolationsFiltersEvent,
        SearchViolationsEvent;
import '../widgets/violations_filters_bottom_sheet.dart';

class ViolationsPage extends StatefulWidget {
  const ViolationsPage({super.key});

  @override
  State<ViolationsPage> createState() => _ViolationsPageState();
}

class _ViolationsPageState extends State<ViolationsPage> {
  @override
  void initState() {
    super.initState();
    CommonFunctions.sendEventToAnalytics(AppEvents.profile);

    CommonFunctions.sendUXCamEvent(UXCamEvents.openViolationsList);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ViolationsBloc>(
      create: (context) => ViolationsBloc()..add(GetViolationsEvent()),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: DefaultAppBarWidget(
            title: 'violations'.tr(),
            actions: [
              BlocBuilder<ViolationsBloc, ViolationsState>(
                builder: (context, state) {
                  return FilterIcon(
                    onTap: () async {
                      CommonFunctions.sendUXCamEvent(
                          UXCamEvents.openViolationsFilter);

                      context
                          .read<ViolationsBloc>()
                          .add(ViolationsLoadLookupsEvent());
                      final sortType = state.sortType;
                      final selectedRequestStatus =
                          state.selectedViolationStatus;

                      final selectedRequestType = state.selectedInvoiceStatus;

                      final bool? actionTaked =
                          await BottomSheetDialog.showDraggableSheet(
                        context,
                        dialogKeyName: DialogName.violationsFilterDialog,
                        currentRouteName: RouteName.violationsPage,
                        child: BottomSheetWithActions(
                          title: "filters".tr(),
                          body: ViolationsFilterBottomSheet(
                            requestsBloc: context.read<ViolationsBloc>(),
                          ),
                          action: ViolationsFilterActions(
                            requestsBloc: context.read<ViolationsBloc>(),
                          ),
                        ),
                      );
                      if (actionTaked != true && context.mounted) {
                        context.read<ViolationsBloc>().add(
                              ResetViolationsFiltersEvent(
                                  selectedSortType: sortType,
                                  selectedRequestStatus: selectedRequestStatus,
                                  selectedRequestType: selectedRequestType,
                                  dateForm: state.lastDateForm),
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
            child: ViolationList(),
          ),
        );
      }),
    );
  }
}
