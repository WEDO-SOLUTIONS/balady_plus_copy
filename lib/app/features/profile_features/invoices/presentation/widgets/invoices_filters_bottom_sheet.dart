import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../_shared_feature_/shared_feature_exports.dart'
    show FilterTextField;
import '../../invoices_exports.dart'
    show
        InvoicesBloc,
        InvoicesDueDateFilter,
        InvoicesIssueDateFilter,
        InvoicesProductFilter,
        InvoicesSortFilter,
        InvoicesState,
        InvoicesStatusFilter,
        InvoicesTypeFilter,
        SearchWithInvoiceNumberEvent,
        SearchWithRequestNumberEvent;

class InvoicesFilterBottomSheet extends StatelessWidget {
  final InvoicesBloc invoicesBloc;

  const InvoicesFilterBottomSheet({
    super.key,
    required this.invoicesBloc,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: invoicesBloc,
      child: SizedBox(
        width: double.infinity,
        child: Builder(builder: (context) {
          return BlocBuilder<InvoicesBloc, InvoicesState>(
            builder: (context, state) {
              return Column(
                children: [
                  FilterTextField(
                    hintText: "invoice_no".tr(),
                    initialValue: state.invoiceNumberQuery,
                    onChanged: (value) {
                      context.read<InvoicesBloc>().add(
                            SearchWithInvoiceNumberEvent(
                              query: value,
                            ),
                          );
                    },
                  ),
                  FilterTextField(
                    hintText: "request_no".tr(),
                    initialValue: state.requestNumberQuery,
                    onChanged: (value) {
                      context.read<InvoicesBloc>().add(
                            SearchWithRequestNumberEvent(
                              query: value,
                            ),
                          );
                    },
                  ),
                  const InvoicesProductFilter(),
                  const InvoicesTypeFilter(),
                  const InvoicesDueDateFilter(),
                  const InvoicesIssueDateFilter(),
                  const InvoicesStatusFilter(),
                  const InvoicesSortFilter(),
                  const SizedBox(height: 16),
                ],
              );
            },
          );
        }),
      ),
    );
  }
}
