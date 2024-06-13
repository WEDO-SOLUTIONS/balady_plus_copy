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
    Map data = ModalRoute.of(context)!.settings.arguments as Map;

    return BlocProvider(
      create: (context) => sl<InvoiceDetailsCubit>(),
      child: InvoiceDetailBody(
        invoiceId: data['invoiceId'],
        crNumber: data['crNumber'],
        crType: data['crType'],
        xSourceApp: data['xSourceApp'],
      ),
    );
  }
}
