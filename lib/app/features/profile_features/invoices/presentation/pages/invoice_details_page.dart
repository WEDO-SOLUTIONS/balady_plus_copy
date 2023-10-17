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
    InvoiceEntity  invoiceEntity = arguments[0];
    String  crNumber = arguments[1];

    return BlocProvider(
      create: (context) => sl<InvoiceDetailsCubit>(),
      child: InvoiceDetailBody(
        invoiceEntity: invoiceEntity,
        crNumber: crNumber,
      ),
    );
  }
}
