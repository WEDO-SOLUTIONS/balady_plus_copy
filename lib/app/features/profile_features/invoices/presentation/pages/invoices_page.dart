import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/dependency_injection/dependency_injection_exports.dart'
    show sl;
import '../../../../_shared_feature_/shared_feature_exports.dart'
    show
        BottomSheetDialog,
        DefaultAppBarWidget,
        DraggableSheetComponent,
        FilterIcon;
import '../../../requests/requests_exports.dart' show AppBarSeachBar;
import '../../invoices_exports.dart'
    show
        GetInvoicesEvent,
        InvoicesBloc,
        InvoicesFilterBottomSheet,
        InvoicesList,
        InvoicesLoadLookupsEvent,
        SearchInvoicesEvent;

class InvoicesPage extends StatelessWidget {
  const InvoicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<InvoicesBloc>(
      create: (context) => sl<InvoicesBloc>()..add(GetInvoicesEvent()),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: DefaultAppBarWidget(
              title: 'invoices'.tr(),
              bottom: AppBarSeachBar(
                onChanged: (value) {
                  context.read<InvoicesBloc>().add(
                        SearchInvoicesEvent(
                          query: value,
                        ),
                      );
                },
              ),
              actions: [
                FilterIcon(
                  onTap: () {
                    context
                        .read<InvoicesBloc>()
                        .add(InvoicesLoadLookupsEvent());
                    BottomSheetDialog.showDraggableSheet(
                      context,
                      child: DraggableSheetComponent(
                        title: "filters".tr(),
                        height: 0.9,
                        body: InvoicesFilterBottomSheet(
                          invoicesBloc: context.read<InvoicesBloc>(),
                        ),
                      ),
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
