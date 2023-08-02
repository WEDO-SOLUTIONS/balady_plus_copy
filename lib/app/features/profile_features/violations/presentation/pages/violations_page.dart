import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
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

class ViolationsPage extends StatelessWidget {
  const ViolationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ViolationsBloc>(
      create: (context) => ViolationsBloc()..add(GetViolationsEvent()),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: DefaultAppBarWidget(
            title: 'violations'.tr(),
            actions: [
              BlocBuilder<ViolationsBloc,
                  ViolationsState>(
                builder: (context, state) {
                  return FilterIcon(
                    onTap: () async {
                      context
                          .read<ViolationsBloc>()
                          .add(ViolationsLoadLookupsEvent());
                      final sortType = state.sortType;
                      final selectedRequestStatus = state.selectedViolationStatus;

                      final selectedRequestType = state.selectedInvoiceStatus;

                      final bool? actionTaked =
                          await BottomSheetDialog.showDraggableSheet(
                        context,
                        child: BottomSheetWithActions(
                          title: "filters".tr(),
                          body: ViolationsFilterBottomSheet(
                            requestsBloc:
                                context.read<ViolationsBloc>(),
                          ),
                          action: ViolationsFilterActions(
                            requestsBloc:
                                context.read<ViolationsBloc>(),
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
