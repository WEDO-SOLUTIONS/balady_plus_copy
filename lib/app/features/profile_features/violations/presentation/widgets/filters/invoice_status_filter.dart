import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/utils/constants/dialog_names.dart';
import '../../../../../../core/utils/constants/route_names.dart';
import '../../../../../_shared_feature_/shared_feature_exports.dart'
    show BottomSheetDialog, BottomSheetList, DropDownWithTitle;
import '../../../violations_exports.dart'
    show
        GetInvoiceStatusesEvent,
        InvoiceStatusesSelectedEvent,
        ViolationsBloc,
        ViolationsState;

class InvoiceStatusFilter extends StatelessWidget {
  const InvoiceStatusFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ViolationsBloc, ViolationsState>(
      buildWhen: (previous, current) =>
          previous.invoiceStatuses != current.invoiceStatuses ||
          previous.selectedInvoiceStatus != current.selectedInvoiceStatus,
      builder: (context, state) {
        return DropDownWithTitle(
          title: "transaction_details_bill_status".tr(),
          selectedValue: state.selectedInvoiceStatus?.name,
          status: state.invoiceStatusesStatus,
          onRetry: () => context.read<ViolationsBloc>().add(
                GetInvoiceStatusesEvent(),
              ),
          onTap: () {
            final List<String> items =
                state.invoiceStatuses.map((e) => e.name).toList();
            BottomSheetDialog.showDraggableSheet(
              context,
              dialogKeyName: DialogName.violationsBillStatusFilterDialog,
              currentRouteName: RouteName.violationsPage,
              child: BottomSheetList(
                title: "transaction_details_bill_status".tr(),
                items: items,
                selectedValue: state.selectedInvoiceStatus?.name,
                onTap: (item) {
                  final invoiceStatus =
                      state.invoiceStatuses.where((e) => e.name == item).first;
                  context.read<ViolationsBloc>().add(
                        InvoiceStatusesSelectedEvent(
                          invoiceStatus: invoiceStatus,
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
