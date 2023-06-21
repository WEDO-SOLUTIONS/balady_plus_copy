import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/utils/utils_exports.dart' show BlocRequestStatus;
import '../../../../../_shared_feature_/shared_feature_exports.dart'
    show
        BottomSheetDialog,
        BottomSheetList,
        DraggableSheetComponent,
        DropDownWithTitle,
        RetryWidget;
import '../../../invoices_exports.dart'
    show MunicipalitySelectedEvent, InvoicesBloc, InvoicesState;

class InvoicesMunicipalityFilter extends StatelessWidget {
  const InvoicesMunicipalityFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InvoicesBloc, InvoicesState>(
      buildWhen: (previous, current) =>
          previous.municipalitiesStatus != current.municipalitiesStatus ||
          previous.selectedMunicipality != current.selectedMunicipality,
      builder: (context, state) {
        final loading = state.municipalitiesStatus ==
            BlocRequestStatus.submissionGetLoading;
        final failed = state.municipalitiesStatus ==
            BlocRequestStatus.submissionGetFailure;
        return DropDownWithTitle(
          title: "municipality".tr(),
          selectedValue: state.selectedMunicipality?.name,
          loading: loading,
          retryWidget: failed ? RetryWidget(onRetry: () {}) : null,
          onTap: () {
            final List<String> items =
                state.municipalities.map((e) => e.name).toList();
            BottomSheetDialog.showDraggableSheet(
              context,
              child: DraggableSheetComponent(
                title: "municipality".tr(),
                height: 0.6,
                body: BottomSheetList(
                  items: items,
                  selectedValue: state.selectedMunicipality?.name,
                  onTap: (item) {
                    final selectedItem =
                        state.municipalities.where((e) => e.name == item).first;
                    context.read<InvoicesBloc>().add(
                          MunicipalitySelectedEvent(
                            municipality: selectedItem,
                          ),
                        );
                    Navigator.pop(context);
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
