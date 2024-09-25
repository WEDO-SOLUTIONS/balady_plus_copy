import 'package:balady_plus/app/commercial_model/features/commercial_debts/data/models/commercial_debts_steps.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_debts/presentation/bloc/check_debts/commercial_check_debts_cubit.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_debts/presentation/bloc/check_debts/commercial_check_debts_state.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_debts/presentation/widgets/check_debts/field_commercial_debt_widget.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_debts/presentation/widgets/check_debts/have_debt_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommercialDebtsScreen extends StatelessWidget {
  /// Transaction get from [TransactionType]
  final TransactionType transactionType;

  /// List of steps get from [RenewSteps]
  final List<String> steps;

  // this is requestId of request or invoiceId of invoice
  final int? transactionId;

  final Widget child;
  final CommercialLicenseServiceId serviceId;

  const CommercialDebtsScreen({
    super.key,
    required this.child,
    required this.transactionType,
    required this.transactionId,
    required this.steps,
    required this.serviceId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CommercialDebtsCubit>(
      create: (context) => CommercialDebtsCubit(
        transactionType: transactionType,
        transactionId: transactionId,
        steps: steps,
        serviceId: serviceId,
      ),
      child: BlocConsumer<CommercialDebtsCubit, CommercialDebtsState>(
        listener: (BuildContext contextCuit, state) {
          // when get debt show dialog
          if (state is SuccessCommercialDebtState) {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) => HaveDebtAlertDialog(state: state),
            );
          }
        },
        // Build new UI in two state loading and field
        builder: (BuildContext contextCuit, state) {
          if (state is LoadingCommercialDebtState) {
            return const Center(child: CircularProgressIndicator());
          }

          // show Widget to try again
          if (state is FieldCommercialDebtState) {
            return FieldCommercialDebtWidget(state: state);
          }
          // show
          return child;
        },
      ),
    );
  }
}
