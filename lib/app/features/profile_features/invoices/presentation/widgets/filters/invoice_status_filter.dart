import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/utils/constants/dialog_names.dart';
import '../../../../../../core/utils/constants/route_names.dart';
import '../../../../../_shared_feature_/shared_feature_exports.dart'
    show BottomSheetDialog, BottomSheetList, DropDownWithTitle;
import '../../../invoices_exports.dart'
    show
        GetInvoiceStatusesEvent,
        InvoiceStatusSelectedEvent,
        InvoicesBloc,
        InvoicesState;

class InvoicesStatusFilter extends StatelessWidget {
  const InvoicesStatusFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InvoicesBloc, InvoicesState>(
      buildWhen: (previous, current) =>
          previous.invoiceStatusesStatus != current.invoiceStatusesStatus ||
          previous.selectedInvoiceStatus != current.selectedInvoiceStatus,
      builder: (context, state) {
        return DropDownWithTitle(
          title: "invoice_status".tr(),
          selectedValue: state.selectedInvoiceStatus?.name,
          status: state.invoiceStatusesStatus,
          onRetry: () => context.read<InvoicesBloc>().add(
                GetInvoiceStatusesEvent(),
              ),
          onTap: () {
            final List<String> items =
                state.invoiceStatuses.map((e) => e.name).toList();
            BottomSheetDialog.showDraggableSheet(
              context,
              dialogKeyName: DialogName.invoicesStatusFilters,
              currentRouteName: RouteName.invoices,
              child: BottomSheetList(
                title: "invoice_status".tr(),
                items: items,
                selectedValue: state.selectedInvoiceStatus?.name,
                onTap: (item) {
                  final invoiceStatus =
                      state.invoiceStatuses.where((e) => e.name == item).first;
                  context.read<InvoicesBloc>().add(
                        InvoiceStatusSelectedEvent(
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
