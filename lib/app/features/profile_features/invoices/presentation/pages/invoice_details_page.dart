import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/dependency_injection/dependency_injection_exports.dart'
    show sl;
import '../../invoices_exports.dart'
    show InvoiceDetailBody, InvoiceDetailsCubit, InvoiceEntity;

class InvoiceDetailsPage extends StatelessWidget {
  InvoiceDetailsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List  arguments = ModalRoute.of(context)!.settings.arguments as List;
    String  invoiceId = arguments[0];
    String  crNumber = arguments[1];
    String  crType = arguments[2];

    return BlocProvider(
      create: (context) => sl<InvoiceDetailsCubit>(),
      child: InvoiceDetailBody(
        invoiceId: invoiceId,
        crNumber: crNumber,
        crType: crType,
      ),
    );
  }
}
