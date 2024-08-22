import 'package:balady_plus/app/commercial_model/features/commercial_debts/presentation/bloc/commercial_debts_state.dart';
import 'package:balady_plus/app/core/services/local/helpers.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class HaveDebtAlertDialog extends StatelessWidget {
  final SuccessCommercialDebtState state;

  const HaveDebtAlertDialog({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !state.isBlocked,
      child: AlertDialog(
        // title: const Text("title"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Icon(
                state.isBlocked ? Icons.block : Icons.warning,
                color: state.isBlocked
                    ? Colors.red.shade800
                    : Colors.yellow.shade700,
                size: 80,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              state.commercialDebt.infoMessage ?? "",
              textAlign: TextAlign.center,
            ),
            Text(
              "${"total_debt".tr()} : ${state.commercialDebt.totalAmount}",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (state.isBlocked) {
                Helpers.backNavigationToHomeScreen();
              } else {
                Navigator.of(context).pop();
              }
            },
            child: Text(
              state.isBlocked
                  ? "go_to_home".tr()
                  : "compliance_cancel_request_confirm".tr(),
            ),
          )
        ],
        contentPadding: const EdgeInsets.all(22),
        titlePadding: EdgeInsets.zero,
        actionsPadding: const EdgeInsets.only(
          bottom: 22,
          left: 22,
          right: 22,
        ),
      ),
    );
  }
}
