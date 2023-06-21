import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/utils/utils_exports.dart' show BlocRequestStatus;
import '../../../../../_shared_feature_/shared_feature_exports.dart'
    show
        BottomSheetDialog,
        BottomSheetList,
        DropDownWithTitle;
import '../../../invoices_exports.dart'
    show InvoiceTypeSelectedEvent, InvoicesBloc, InvoicesState;

class InvoicesProductFilter extends StatelessWidget {
  const InvoicesProductFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InvoicesBloc, InvoicesState>(
      buildWhen: (previous, current) =>
          previous.invoiceTypesStatus != current.invoiceTypesStatus ||
          previous.selectedInvoiceType != current.selectedInvoiceType,
      builder: (context, state) {
        return DropDownWithTitle(
          title: "product".tr(),
          selectedValue: state.selectedInvoiceType?.name,
          loading: state.invoiceTypesStatus ==
              BlocRequestStatus.submissionGetLoading,
          onTap: () {
            final List<String> items =
                state.invoiceTypes.map((e) => e.name).toList();
            BottomSheetDialog.showDraggableSheet(
              context,
              child: BottomSheetList(
                title: "product".tr(),
                items: items,
                selectedValue: state.selectedInvoiceType?.name,
                onTap: (item) {
                  final invoiceType =
                      state.invoiceTypes.where((e) => e.name == item).first;
                  context.read<InvoicesBloc>().add(
                        InvoiceTypeSelectedEvent(
                          invoiceType: invoiceType,
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
