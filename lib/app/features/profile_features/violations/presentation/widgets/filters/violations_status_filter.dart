import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../_shared_feature_/shared_feature_exports.dart'
    show BottomSheetDialog, BottomSheetList, DropDownWithTitle;
import '../../../violations_exports.dart'
    show
        GetViolationsStatusesEvent,
        ViolationsStatusSelectedEvent,
        ViolationsBloc,
        ViolationsState;

class RequestsStatusFilter extends StatelessWidget {
  const RequestsStatusFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ViolationsBloc, ViolationsState>(
      buildWhen: (previous, current) =>
          previous.violationsStatusesStatus != current.violationsStatusesStatus ||
          previous.selectedViolationStatus != current.selectedViolationStatus,
      builder: (context, state) {
        return DropDownWithTitle(
          title: "request_status".tr(),
          selectedValue: state.selectedViolationStatus?.name,
          status: state.violationsStatusesStatus,
          onRetry: () => context.read<ViolationsBloc>().add(
                GetViolationsStatusesEvent(),
              ),
          onTap: () {
            final List<String> items =
                state.violationsStatuses.map((e) => e.name).toList();
            BottomSheetDialog.showDraggableSheet(
              context,
              child: BottomSheetList(
                title: "request_status".tr(),
                items: items,
                selectedValue: state.selectedViolationStatus?.name,
                onTap: (item) {
                  final requestStatus =
                      state.violationsStatuses.where((e) => e.name == item).first;
                  context.read<ViolationsBloc>().add(
                        ViolationsStatusSelectedEvent(
                          violationsStatus: requestStatus,
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
