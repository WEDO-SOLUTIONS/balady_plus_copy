import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../../../core/utils/constants/dialog_names.dart';
import '../../../../../../core/utils/constants/route_names.dart';
import '../../../../../_shared_feature_/shared_feature_exports.dart'
    show BottomSheetDialog, BottomSheetList, DropDownWithTitle;
import '../../../violations_exports.dart';

class ViolationsStatusesFilter extends StatelessWidget {
  const ViolationsStatusesFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ViolationsBloc, ViolationsState>(
      buildWhen: (previous, current) =>
          previous.violationsStatuses != current.violationsStatuses ||
          previous.selectedViolationStatus != current.selectedViolationStatus,
      builder: (context, state) {
        return DropDownWithTitle(
          title: "transaction_details_violation_status".tr(),
          selectedValue: state.selectedViolationStatus?.name,
          status: state.violationsStatus,
          onRetry: () => context.read<ViolationsBloc>().add(
                GetViolationsStatusesEvent(),
              ),
          onTap: () {
            final List<String> items =
                state.violationsStatuses.map((e) => e.name).toList();
            BottomSheetDialog.showDraggableSheet(
              context,
              dialogKeyName: DialogName.violationsViolationsStatusFilterDialog,
              currentRouteName: RouteName.violationsPage,
              child: BottomSheetList(
                title: "transaction_details_violation_status".tr(),
                items: items,
                selectedValue: state.selectedViolationStatus?.name,
                onTap: (item) {
                  final violationsStatus = state.violationsStatuses
                      .where((e) => e.name == item)
                      .first;
                  context.read<ViolationsBloc>().add(
                        ViolationsStatusSelectedEvent(
                          violationsStatus: violationsStatus,
                        ),
                      );
                  Navigator.pop(context);
                },
              ),
            );
          },
        );
      },
    );
  }
}
