import 'package:balady_plus/app/commercial_model/features/commercial_debts/presentation/bloc/commercial_list_debts/commercial_list_debts_cubit.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_debts/presentation/widgets/debts_list/debts_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart'
    show DefaultAppBarWidget;

class CommercialDebtsListScreen extends StatefulWidget {
  const CommercialDebtsListScreen({super.key});

  @override
  State<CommercialDebtsListScreen> createState() =>
      _CommercialDebtsListScreenState();
}

class _CommercialDebtsListScreenState extends State<CommercialDebtsListScreen> {
  @override
  void initState() {
    super.initState();
    // CommonFunctions.sendEventToAnalytics(AppEvents.Invoices);
    // CommonFunctions.sendUXCamEvent(UXCamEvents.openInvoicesList);
  }

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context)!.settings.arguments as Map;
    return BlocProvider(
      create: (context) => CommercialListDebtsCubit(
        referenceId: data['referenceId'],
        transactionType: data['transactionType'],
        transactionId: data['transactionId'],
      ),
      child: Scaffold(
        appBar: DefaultAppBarWidget(title: 'debts_list'.tr()),
        body: const Padding(
          padding: EdgeInsets.all(16),
          child: DebtsList(),
        ),
      ),
    );
  }
}
