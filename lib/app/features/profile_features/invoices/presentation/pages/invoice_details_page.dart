import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/dependency_injection/dependency_injection_exports.dart'
    show sl;
import '../../invoices_exports.dart'
    show InvoiceDetailBody, InvoiceDetailsCubit, InvoiceEntity;

class InvoiceDetailsPage extends StatelessWidget {
  final InvoiceEntity invoiceEntity;
  const InvoiceDetailsPage({
    super.key,
    required this.invoiceEntity,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<InvoiceDetailsCubit>(),
      child: InvoiceDetailBody(
        invoiceEntity: invoiceEntity,
      ),
    );
  }
}
