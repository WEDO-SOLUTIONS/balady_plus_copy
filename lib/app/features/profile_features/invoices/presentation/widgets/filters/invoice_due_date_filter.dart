import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/utils/enums/date_form.dart';
import '../../../../../_shared_feature_/shared_feature_exports.dart'
    show FilterDatePicker;
import '../../../invoices_exports.dart'
    show InvoiceDueDateSelectedEvent, InvoicesBloc, InvoicesState;

class InvoicesDueDateFilter extends StatelessWidget {
  const InvoicesDueDateFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InvoicesBloc, InvoicesState>(
      buildWhen: (previous, current) =>
          previous.selectedInvoiceDueDate != current.selectedInvoiceDueDate,
      builder: (context, state) {
        return FilterDatePicker(
          title: "invoice_due_date".tr(),
          initialDate: state.selectedInvoiceDueDate,
          initialDateForm: state.dateFormForDueDate ?? DateForm.gregorian,
          onChange: (selectedDate, dateForm) {
            BlocProvider.of<InvoicesBloc>(context).add(
              InvoiceDueDateSelectedEvent(
                  date: selectedDate, formDate: dateForm),
            );
          },
        );
      },
    );
  }
}
