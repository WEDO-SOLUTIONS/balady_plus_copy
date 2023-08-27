import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/utils/constants/dialog_names.dart';
import '../../../../../../core/utils/constants/route_names.dart';
import '../../../../../_shared_feature_/shared_feature_exports.dart'
    show BottomSheetDialog, BottomSheetList, DropDownWithTitle, MessageDialog;
import '../../../invoices_exports.dart'
    show
        GetInvoiceSubtypesEvent,
        InvoiceSubTypeSelectedEvent,
        InvoicesBloc,
        InvoicesState;

class InvoicesTypeFilter extends StatelessWidget {
  const InvoicesTypeFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InvoicesBloc, InvoicesState>(
      buildWhen: (previous, current) =>
          previous.invoiceSubTypesStatus != current.invoiceSubTypesStatus ||
          previous.selectedInvoiceSubType != current.selectedInvoiceSubType ||
          previous.selectedInvoiceType != current.selectedInvoiceType,
      builder: (context, state) {
        return DropDownWithTitle(
          title: "invoice_type".tr(),
          selectedValue: state.selectedInvoiceSubType?.name,
          status: state.invoiceSubTypesStatus,
          onRetry: () {
            final selectedInvoiceType = state.selectedInvoiceType;
            if (selectedInvoiceType != null) {
              context.read<InvoicesBloc>().add(
                    GetInvoiceSubtypesEvent(
                      invoiceType: selectedInvoiceType,
                    ),
                  );
            }
          },
          onTap: () {
            if (state.selectedInvoiceType == null) {
              MessageDialog.showErrorNotification(
                msg: '${"choose".tr()} ${"product".tr()} ${"first".tr()}',
              );
              return;
            }
            final List<String> items =
                state.invoiceSubTypes.map((e) => e.name).toList();
            BottomSheetDialog.showDraggableSheet(
              context,
              dialogKeyName: DialogName.invoicesTypeFilters,
              currentRouteName: RouteName.invoices,
              child: BottomSheetList(
                title: "invoice_type".tr(),
                items: items,
                selectedValue: state.selectedInvoiceSubType?.name,
                onTap: (item) {
                  final invoiceSubType =
                      state.invoiceSubTypes.where((e) => e.name == item).first;
                  context.read<InvoicesBloc>().add(
                        InvoiceSubTypeSelectedEvent(
                          invoiceSubtype: invoiceSubType,
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
