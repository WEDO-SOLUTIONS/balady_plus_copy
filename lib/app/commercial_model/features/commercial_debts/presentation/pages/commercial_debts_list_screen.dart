import 'package:balady_plus/app/commercial_model/features/commercial_debts/presentation/widgets/debts_list.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/dependency_injection/dependency_injection_exports.dart'
    show sl;
import '../../../../../core/utils/app_analytics_events.dart';
import '../../../../../core/utils/common_functions.dart';
import '../../../../../core/utils/constants/dialog_names.dart';
import '../../../../../core/utils/constants/route_names.dart';
import '../../../../../core/utils/constants/ux_cam_events.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart'
    show
        BottomSheetDialog,
        BottomSheetWithActions,
        DefaultAppBarWidget,
        FilterIcon;
import 'package:balady_plus/app/features/profile_features/invoices/invoices_exports.dart'
    show InvoicesList;

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
    CommonFunctions.sendEventToAnalytics(AppEvents.Invoices);

    CommonFunctions.sendUXCamEvent(UXCamEvents.openInvoicesList);
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Scaffold(
          appBar: DefaultAppBarWidget(
            title: 'debts'.tr(),
            actions: [
              FilterIcon(
                onTap: () async {
                  final bool? actionTaked =
                      await BottomSheetDialog.showDraggableSheet(context,
                          dialogKeyName: DialogName.invoicesPageFilters,
                          currentRouteName: RouteName.invoices,
                          child: Container());
                  if (actionTaked != true && context.mounted) {}
                  CommonFunctions.sendUXCamEvent(
                      UXCamEvents.openInvoicesFilter);
                },
              )
            ],
          ),
          body: const Padding(
            padding: EdgeInsets.all(16),
            child: DebtsList(),
          ),
        );
      },
    );
  }
}
