import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../_shared_feature_/shared_feature_exports.dart'
    show ElevatedButtonWidget;
import '../../invoices_exports.dart'
    show ApplyInvoicesFiltersEvent, ClearInvoicesFiltersEvent, InvoicesBloc;

class InvoicesFilterActions extends StatelessWidget {
  final InvoicesBloc invoicesBloc;

  const InvoicesFilterActions({
    super.key,
    required this.invoicesBloc,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: invoicesBloc,
      child: Builder(builder: (context) {
        return Column(
          children: [
            ElevatedButtonWidget.apply(
              onPressed: () {
                context.read<InvoicesBloc>().add(
                      ApplyInvoicesFiltersEvent(),
                    );
                Navigator.pop(context, true);
              },
            ),
            const SizedBox(height: 16),
            ElevatedButtonWidget.deletaAll(
              onPressed: () {
                context.read<InvoicesBloc>().add(
                      ClearInvoicesFiltersEvent(),
                    );
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      }),
    );
  }
}
