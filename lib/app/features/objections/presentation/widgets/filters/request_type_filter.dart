import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/constants/dialog_names.dart';
import '../../../../../core/utils/constants/route_names.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart'
    show BottomSheetDialog, BottomSheetList, DropDownWithTitle, MessageDialog;
import '../../../objections_exports.dart'
    show
        GetRequestSubtypesEvent,
        RequestSubTypeSelectedEvent,
        ObjectionsBloc,
        RequestsState;

class RequestsTypeFilter extends StatelessWidget {
  const RequestsTypeFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ObjectionsBloc, RequestsState>(
      buildWhen: (previous, current) =>
          previous.requestSubTypesStatus != current.requestSubTypesStatus ||
          previous.selectedRequestSubType != current.selectedRequestSubType ||
          previous.selectedRequestType != current.selectedRequestType,
      builder: (context, state) {
        return DropDownWithTitle(
          title: "transaction_type".tr(),
          selectedValue: state.selectedRequestSubType?.name,
          status: state.requestSubTypesStatus,
          onRetry: () {
            final selectedRequestType = state.selectedRequestType;
            if (selectedRequestType != null) {
              context.read<ObjectionsBloc>().add(
                    GetRequestSubtypesEvent(requestType: selectedRequestType),
                  );
            }
          },
          onTap: () {
            if (state.selectedRequestType == null) {
              MessageDialog.showErrorNotification(
                msg: '${"choose".tr()} ${"product".tr()} ${"first".tr()}',
              );
              return;
            }
            final List<String> items =
                state.requestSubTypes.map((e) => e.name ?? "").toList();
            BottomSheetDialog.showDraggableSheet(
              context,
              dialogKeyName: DialogName.objectionsTransactoinsPageFilters,
              currentRouteName: RouteName.objections,
              child: BottomSheetList(
                title: "transaction_type".tr(),
                items: items,
                selectedValue: state.selectedRequestSubType?.name,
                onTap: (item) {
                  final requestSubType =
                      state.requestSubTypes.where((e) => e.name == item).first;
                  context.read<ObjectionsBloc>().add(
                        RequestSubTypeSelectedEvent(
                          requestSubtype: requestSubType,
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
