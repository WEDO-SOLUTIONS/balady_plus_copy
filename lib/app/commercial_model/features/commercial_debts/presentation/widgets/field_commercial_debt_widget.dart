import 'package:balady_plus/app/commercial_model/features/commercial_debts/presentation/bloc/commercial_debts_cubit.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_debts/presentation/bloc/commercial_debts_state.dart';
import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
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
              // showDialog(
              //   barrierDismissible: false,
              //   useRootNavigator: false,
              //   useSafeArea: false,
              //   context: context,
              //   builder: (context) => AlertDialog(
              //     // title: const Text("title"),
              //     content: Column(
              //       mainAxisSize: MainAxisSize.min,
              //       children: [
              //         Icon(
              //            Icons.warning,
              //           color:  Colors.yellow.shade700,
              //         ),
              //         Text("state.commercialDebt.infoMessage"),
              //       ],
              //     ),
              //     actions: [
              //       ElevatedButton(
              //         onPressed: () {
              //
              //         },
              //         child: const Text("ok"),
              //       )
              //     ],
              //   ),
              // );
              cubit.getDebts(
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
