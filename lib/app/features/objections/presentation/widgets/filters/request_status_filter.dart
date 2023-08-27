import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/constants/dialog_names.dart';
import '../../../../../core/utils/constants/route_names.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart'
    show BottomSheetDialog, BottomSheetList, DropDownWithTitle;
import '../../../objections_exports.dart'
    show
        GetRequestStatusesEvent,
        RequestStatusSelectedEvent,
        ObjectionsBloc,
        RequestsState;

class RequestsStatusFilter extends StatelessWidget {
  const RequestsStatusFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ObjectionsBloc, RequestsState>(
      buildWhen: (previous, current) =>
          previous.requestStatusesStatus != current.requestStatusesStatus ||
          previous.selectedRequestStatus != current.selectedRequestStatus,
      builder: (context, state) {
        return DropDownWithTitle(
          title: "request_status".tr(),
          selectedValue: state.selectedRequestStatus?.name,
          status: state.requestStatusesStatus,
          onRetry: () => context.read<ObjectionsBloc>().add(
                GetRequestStatusesEvent(),
              ),
          onTap: () {
            final List<String> items =
                state.requestStatuses.map((e) => e.name).toList();
            BottomSheetDialog.showDraggableSheet(
              context,
              dialogKeyName: DialogName.objectionsProductPageFilters,
              currentRouteName: RouteName.objections,
              child: BottomSheetList(
                title: "request_status".tr(),
                items: items,
                selectedValue: state.selectedRequestStatus?.name,
                onTap: (item) {
                  final requestStatus =
                      state.requestStatuses.where((e) => e.name == item).first;
                  context.read<ObjectionsBloc>().add(
                        RequestStatusSelectedEvent(
                          requestStatus: requestStatus,
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
