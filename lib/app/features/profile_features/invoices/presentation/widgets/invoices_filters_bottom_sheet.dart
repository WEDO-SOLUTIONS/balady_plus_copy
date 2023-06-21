import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../_shared_feature_/shared_feature_exports.dart'
    show ElevatedButtonWidget;
import '../../invoices_exports.dart'
    show
        ApplyInvoicesFiltersEvent,
        ClearInvoicesFiltersEvent,
        InvoicesBloc,
        InvoicesDateFilter,
        InvoicesMunicipalityFilter,
        InvoicesProductFilter,
        InvoicesStatusFilter,
        InvoicesSubMunicipalityFilter,
        InvoicesTypeFilter;

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
          return Column(
            children: [
              const InvoicesProductFilter(),
              const InvoicesTypeFilter(),
              const InvoicesDateFilter(),
              const InvoicesStatusFilter(),
              const InvoicesMunicipalityFilter(),
              const InvoicesSubMunicipalityFilter(),
              const SizedBox(height: 16),
              ElevatedButtonWidget.apply(onPressed: () {
                context.read<InvoicesBloc>().add(
                      ApplyInvoicesFiltersEvent(),
                    );
                Navigator.pop(context);
              }),
              const SizedBox(height: 16),
              ElevatedButtonWidget.deletaAll(onPressed: () {
                context.read<InvoicesBloc>().add(
                      ClearInvoicesFiltersEvent(),
                    );
                Navigator.pop(context);
              }),
            ],
          );
        }),
      ),
    );
  }
}
