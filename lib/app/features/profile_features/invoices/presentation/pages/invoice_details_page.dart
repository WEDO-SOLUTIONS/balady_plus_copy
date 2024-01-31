import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/dependency_injection/dependency_injection_exports.dart'
    show sl;
import '../../invoices_exports.dart'
    show InvoiceDetailBody, InvoiceDetailsCubit;

class InvoiceDetailsPage extends StatelessWidget {
  const InvoiceDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    (
      String payUrl,
      String? crNumber,
      String? crType,
      String? xSourceApp,
    ) arguments = ModalRoute.of(context)!.settings.arguments as (
      String payUrl,
      String? crNumber,
      String? crType,
      String? xSourceApp,
    );

    return BlocProvider(
      create: (context) => sl<InvoiceDetailsCubit>(),
      child: InvoiceDetailBody(
        invoiceId: arguments.$1,
        crNumber: arguments.$2,
        crType: arguments.$3,
        xSourceApp: arguments.$4,
      ),
    );
  }
}
