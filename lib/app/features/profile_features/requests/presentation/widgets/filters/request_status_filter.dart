import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/utils/utils_exports.dart' show BlocRequestStatus;
import '../../../../../_shared_feature_/shared_feature_exports.dart'
    show BottomSheetDialog, BottomSheetList, DraggableSheetComponent, DropDownWithTitle;
import '../../../requests_exports.dart'
    show
        RequestStatusSelectedEvent,
        RequestsBloc,
        RequestsState;

class RequestsStatusFilter extends StatelessWidget {
  const RequestsStatusFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RequestsBloc, RequestsState>(
      buildWhen: (previous, current) =>
          previous.requestStatusesStatus != current.requestStatusesStatus ||
          previous.selectedRequestStatus != current.selectedRequestStatus,
      builder: (context, state) {
        return DropDownWithTitle(
          title: "request_status".tr(),
          selectedValue: state.selectedRequestStatus?.name,
          loading: state.requestStatusesStatus ==
              BlocRequestStatus.submissionGetLoading,
          onTap: () {
            final List<String> items =
                state.requestStatuses.map((e) => e.name).toList();
            BottomSheetDialog.showDraggableSheet(
              context,
              child: DraggableSheetComponent(
                title: "product".tr(),
                height: 0.8,
                body: BottomSheetList(
                  items: items,
                  selectedValue: state.selectedRequestStatus?.name,
                  onTap: (item) {
                    final requestStatus = state.requestStatuses
                        .where((e) => e.name == item)
                        .first;
                    context.read<RequestsBloc>().add(
                          RequestStatusSelectedEvent(
                            requestStatus: requestStatus,
                          ),
                        );
                    Navigator.pop(context);
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
