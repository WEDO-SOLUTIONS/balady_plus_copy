import 'package:balady_plus/app/commercial_model/features/commercial_debts/data/models/commercial_debts_steps.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_debts/presentation/bloc/commercial_debts_state.dart';
import 'package:flutter/material.dart';

class HaveDebtAlertDialog extends StatelessWidget {
  final SuccessCommercialDebtState state;

  const HaveDebtAlertDialog({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: state.commercialDebt.status == CommercialDebtRenewStates.warning,
      child: AlertDialog(
        // title: const Text("title"),
        content: Column(
          children: [
            Icon(
              state.commercialDebt.status ==
                  CommercialDebtRenewStates.blocked
                  ? Icons.block
                  : Icons.warning,
              color: state.commercialDebt.status ==
                  CommercialDebtRenewStates.blocked
                  ? Colors.red.shade800
                  : Colors.yellow.shade700,
              size: 70,
            ),
            const SizedBox(height: 16),
            Text(state.commercialDebt.infoMessage ?? ""),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (state.commercialDebt.status ==
                  CommercialDebtRenewStates.blocked) {
                Navigator.of(
                  context,
                  rootNavigator: true,
                ).pop();
              } else {
                Navigator.of(context).pop();
              }
            },
            child: const Text("ok"),
          )
        ],
      ),
    );
  }
}
