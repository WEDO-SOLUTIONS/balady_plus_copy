import 'package:balady_plus/app/commercial_model/features/commercial_debts/presentation/bloc/check_debts/commercial_check_debts_cubit.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_debts/presentation/bloc/check_debts/commercial_check_debts_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class FieldCommercialDebtWidget extends StatelessWidget {
  final FieldCommercialDebtState state;

  const FieldCommercialDebtWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    CommercialDebtsCubit cubit = context.watch<CommercialDebtsCubit>();
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error,
            size: 50,
          ),
          const SizedBox(height: 16),
          Text(state.errorMessage),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              cubit.checkDebts(
                state.stepNumber,
                state.transactionId,
              );
            },
            child: Text("reload".tr()),
          ),
        ],
      ),
    );
  }
}
