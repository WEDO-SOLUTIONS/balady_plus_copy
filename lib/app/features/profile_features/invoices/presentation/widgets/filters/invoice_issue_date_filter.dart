import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/utils/enums/date_form.dart';
import '../../../../../_shared_feature_/shared_feature_exports.dart'
    show FilterDatePicker;
import '../../../invoices_exports.dart'
    show InvoiceIssueDateSelectedEvent, InvoicesBloc, InvoicesState;

class InvoicesIssueDateFilter extends StatelessWidget {
  const InvoicesIssueDateFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InvoicesBloc, InvoicesState>(
      buildWhen: (previous, current) =>
          previous.selectedInvoiceIssueDate != current.selectedInvoiceIssueDate,
      builder: (context, state) {
        return FilterDatePicker(
          title: "invoice_issue_date".tr(),
          initialDate: state.selectedInvoiceIssueDate,
          initialDateForm: state.dateFormForIssue ?? DateForm.gregorian,
          onChange: (selectedDate, dateForm) {
            BlocProvider.of<InvoicesBloc>(context).add(
              InvoiceIssueDateSelectedEvent(
                  date: selectedDate, formDate: dateForm),
            );
          },
        );
      },
    );
  }
}
