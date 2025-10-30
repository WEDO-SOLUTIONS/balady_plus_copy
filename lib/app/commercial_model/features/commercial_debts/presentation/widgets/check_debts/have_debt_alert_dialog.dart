import 'package:balady_plus/app/commercial_model/commercial_routes/commercial_route_names.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_debts/presentation/bloc/check_debts/commercial_check_debts_state.dart';
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
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
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                CommercialRouteName.commercialDebtsListScreen,
                arguments: {
                  "referenceId": state.commercialDebt.referenceId,
                  "transactionType": state.transactionType,
                  "transactionId": state.transactionId,
                },
              );
            },
            child: Text("show_debts".tr()),
          ),
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
