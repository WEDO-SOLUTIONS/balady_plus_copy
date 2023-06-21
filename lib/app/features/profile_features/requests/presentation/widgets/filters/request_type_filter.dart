import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/utils/utils_exports.dart' show BlocRequestStatus;
import '../../../../../_shared_feature_/shared_feature_exports.dart'
    show BottomSheetDialog, BottomSheetList, DraggableSheetComponent, DropDownWithTitle, MessageDialog;
import '../../../requests_exports.dart'
    show
        RequestSubTypeSelectedEvent,
        RequestsBloc,
        RequestsState;

class RequestsTypeFilter extends StatelessWidget {
  const RequestsTypeFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RequestsBloc, RequestsState>(
      buildWhen: (previous, current) =>
          previous.requestSubTypesStatus != current.requestSubTypesStatus ||
          previous.selectedRequestSubType != current.selectedRequestSubType ||
          previous.selectedRequestType != current.selectedRequestType,
      builder: (context, state) {
        return DropDownWithTitle(
          title: "request_type".tr(),
          selectedValue: state.selectedRequestSubType?.name,
          loading: state.requestSubTypesStatus ==
              BlocRequestStatus.submissionGetLoading,
          onTap: () {
            if (state.selectedRequestType == null) {
              MessageDialog.showErrorNotification(
                msg: '${"choose".tr()} ${"product".tr()} ${"first".tr()}',
              );
              return;
            }
            final List<String> items =
                state.requestSubTypes.map((e) => e.name).toList();
            BottomSheetDialog.showDraggableSheet(
              context,
              child: DraggableSheetComponent(
                title: "request_type".tr(),
                height: 0.8,
                body: BottomSheetList(
                  items: items,
                  selectedValue: state.selectedRequestSubType?.name,
                  onTap: (item) {
                    final requestSubType = state.requestSubTypes
                        .where((e) => e.name == item)
                        .first;
                    context.read<RequestsBloc>().add(
                          RequestSubTypeSelectedEvent(
                            requestSubtype: requestSubType,
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
