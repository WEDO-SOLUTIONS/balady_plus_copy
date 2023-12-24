import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/dependency_injection/dependency_injection_exports.dart'
    show sl;
import '../../../../../core/utils/app_analytics_events.dart';
import '../../../../../core/utils/common_functions.dart';
import '../../../../../core/utils/constants/dialog_names.dart';
import '../../../../../core/utils/constants/route_names.dart';
import '../../../../../core/utils/constants/ux_cam_events.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart'
    show
        BottomSheetDialog,
        BottomSheetWithActions,
        DefaultAppBarWidget,
        FilterIcon;
import '../../invoices_exports.dart'
    show
        GetInvoicesEvent,
        InvoicesBloc,
        InvoicesFilterActions,
        InvoicesFilterBottomSheet,
        InvoicesList,
        InvoicesLoadLookupsEvent,
        InvoicesState,
        ResetInvoicesFiltersEvent;

class InvoicesPage extends StatefulWidget {
  const InvoicesPage({super.key});

  @override
  State<InvoicesPage> createState() => _InvoicesPageState();
}

class _InvoicesPageState extends State<InvoicesPage> {
  @override
  void initState() {
    super.initState();
    CommonFunctions.sendEventToAnalytics(AppEvents.Invoices);

    CommonFunctions.sendUXCamEvent(UXCamEvents.openInvoicesList);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<InvoicesBloc>(
      create: (context) => sl<InvoicesBloc>()..add(GetInvoicesEvent()),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: DefaultAppBarWidget(
              title: 'invoices'.tr(),
              actions: [
                BlocBuilder<InvoicesBloc, InvoicesState>(
                  builder: (context, state) {
                    return FilterIcon(
                      onTap: () async {
                        context
                            .read<InvoicesBloc>()
                            .add(InvoicesLoadLookupsEvent());
                        final sortType = state.sortType;
                        final selectedInvoiceType = state.selectedInvoiceType;
                        final selectedInvoiceSubType =
                            state.selectedInvoiceSubType;

                        final selectedInvoiceStatus =
                            state.selectedInvoiceStatus;
                        final selectedInvoiceDueDate =
                            state.selectedInvoiceDueDate;
                        final selectedInvoiceIssueDate =
                            state.selectedInvoiceIssueDate;
                        final invoiceNumberQuery = state.invoiceNumberQuery;
                        final requestNumberQuery = state.requestNumberQuery;

                        final bool? actionTaked =
                            await BottomSheetDialog.showDraggableSheet(
                          context,
                          dialogKeyName: DialogName.invoicesPageFilters,
                          currentRouteName: RouteName.invoices,
                          child: BottomSheetWithActions(
                            title: "filters".tr(),
                            body: InvoicesFilterBottomSheet(
                              invoicesBloc: context.read<InvoicesBloc>(),
                            ),
                            action: InvoicesFilterActions(
                              invoicesBloc: context.read<InvoicesBloc>(),
                            ),
                          ),
                        );
                        if (actionTaked != true && context.mounted) {
                          context.read<InvoicesBloc>().add(
                                ResetInvoicesFiltersEvent(
                                  selectedSortType: sortType,
                                  selectedInvoiceType: selectedInvoiceType,
                                  selectedInvoiceSubType:
                                      selectedInvoiceSubType,
                                  selectedInvoiceStatus: selectedInvoiceStatus,
                                  selectedInvoiceDueDate:
                                      selectedInvoiceDueDate,
                                  selectedInvoiceIssueDate:
                                      selectedInvoiceIssueDate,
                                  invoiceNumberQuery: invoiceNumberQuery,
                                  requestNumberQuery: requestNumberQuery,
                                ),
                              );
                        }
                        CommonFunctions.sendUXCamEvent(
                            UXCamEvents.openInvoicesFilter);
                      },
                    );
                  },
                ),
              ],
            ),
            body: const Padding(
              padding: EdgeInsets.all(16),
              child: InvoicesList(),
            ),
          );
        },
      ),
    );
  }
}
