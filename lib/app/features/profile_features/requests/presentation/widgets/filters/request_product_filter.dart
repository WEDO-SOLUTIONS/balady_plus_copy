import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/utils/constants/dialog_names.dart';
import '../../../../../../core/utils/constants/route_names.dart';
import '../../../../../_shared_feature_/shared_feature_exports.dart'
    show BottomSheetDialog, BottomSheetList, DropDownWithTitle;
import '../../../requests_exports.dart'
    show
        GetRequestTypesEvent,
        RequestTypeSelectedEvent,
        RequestsBloc,
        RequestsState;

class RequestsProductFilter extends StatelessWidget {
  const RequestsProductFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RequestsBloc, RequestsState>(
      buildWhen: (previous, current) =>
          previous.requestTypesStatus != current.requestTypesStatus ||
          previous.selectedRequestType != current.selectedRequestType,
      builder: (context, state) {
        return DropDownWithTitle(
          title: "product".tr(),
          selectedValue: state.selectedRequestType?.name,
          status: state.requestTypesStatus,
          onRetry: () => context.read<RequestsBloc>().add(
                GetRequestTypesEvent(),
              ),
          onTap: () {
            final List<String> items =
                state.requestTypes.map((e) => e.name).toList();
            BottomSheetDialog.showDraggableSheet(
              context,
              dialogKeyName: DialogName.requestsProductsFilterDialog,
              currentRouteName: RouteName.requests,
              child: BottomSheetList(
                title: "product".tr(),
                items: items,
                selectedValue: state.selectedRequestType?.name,
                onTap: (item) {
                  final requestType =
                      state.requestTypes.where((e) => e.name == item).first;
                  context.read<RequestsBloc>().add(
                        RequestTypeSelectedEvent(
                          requestType: requestType,
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
