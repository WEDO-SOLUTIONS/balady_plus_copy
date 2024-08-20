import 'package:balady_plus/app/features/commercial_debts/data/models/commercial_debts_steps.dart';
import 'package:balady_plus/app/features/commercial_debts/presentation/bloc/commercial_debts_cubit.dart';
import 'package:balady_plus/app/features/commercial_debts/presentation/bloc/commercial_debts_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapness/shared/ui/error_widget/error_widget.dart';

class CommercialDebtsScreen extends StatelessWidget {
  /// Transaction get from [TransactionType]
  final TransactionType transactionType;

  /// List of steps get from [RenewSteps]
  final List<String> steps;

  // this is requestId of request or invoiceId of invoice
  final int transactionId;

  final Widget child;

  const CommercialDebtsScreen({
    super.key,
    required this.child,
    required this.transactionType,
    required this.transactionId,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CommercialDebtsCubit>(
      create: (context) => CommercialDebtsCubit(
        transactionType: transactionType,
        transactionId: transactionId,
        steps: steps,
      ),
      child: BlocConsumer<CommercialDebtsCubit, CommercialDebtsState>(
        listener: (BuildContext context, state) {
          // when get debt show dialog
          if (state is SuccessCommercialDebtState) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("title"),
                content: Text(state.commercialDebt.infoMessage),
                actions: [
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text("ok"),
                  )
                ],
              ),
            );
          }
        },
        // Build new UI in two state loading and field
        builder: (BuildContext context, state) {
          if (state is LoadingCommercialDebtState) {
            return const Center(child: CircularProgressIndicator());
          }
          // show Widget to try again
          if (state is FieldCommercialDebtState) {
            return BaseErrorWidget(
              onRetry: () {
                CommercialDebtsCubit cubit =
                    context.watch<CommercialDebtsCubit>();
                cubit.getBoardsContracts(state.stepNumber);
              },
            );
          }
          // show
          return child;
        },
      ),
    );
  }
}
