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
        MessageDialog,
        RetryWidget;
import '../../../invoices_exports.dart'
    show
        GetSubMunicipalitiesEvent,
        InvoicesBloc,
        InvoicesState,
        SubMunicipalitySelectedEvent;

class InvoicesSubMunicipalityFilter extends StatelessWidget {
  const InvoicesSubMunicipalityFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InvoicesBloc, InvoicesState>(
      buildWhen: (previous, current) =>
          previous.subMunicipalitiesStatus != current.subMunicipalitiesStatus ||
          previous.selectedSubMunicipality != current.selectedSubMunicipality ||
          previous.selectedMunicipality != current.selectedMunicipality,
      builder: (context, state) {
        final loading = state.subMunicipalitiesStatus ==
            BlocRequestStatus.submissionGetLoading;
        final failed = state.subMunicipalitiesStatus ==
            BlocRequestStatus.submissionGetFailure;
        return DropDownWithTitle(
          title: "sub_municipality".tr(),
          selectedValue: state.selectedSubMunicipality?.name,
          loading: loading,
          retryWidget: failed
              ? RetryWidget(
                  onRetry: () {
                    final selectedMunicipality = state.selectedMunicipality;
                    if (selectedMunicipality != null) {
                      context.read<InvoicesBloc>().add(
                            GetSubMunicipalitiesEvent(
                              municipality: selectedMunicipality,
                            ),
                          );
                    }
                  },
                )
              : null,
          onTap: () {
            if (state.selectedMunicipality == null) {
              MessageDialog.showErrorNotification(
                msg: '${"choose".tr()} ${"municipality".tr()} ${"first".tr()}',
              );
              return;
            }
            final List<String> items =
                state.subMunicipalities.map((e) => e.name).toList();
            BottomSheetDialog.showDraggableSheet(
              context,
              child: DraggableSheetComponent(
                title: "sub_municipality".tr(),
                height: 0.8,
                body: BottomSheetList(
                  items: items,
                  selectedValue: state.selectedSubMunicipality?.name,
                  onTap: (item) {
                    final selectedItem = state.subMunicipalities
                        .where((e) => e.name == item)
                        .first;
                    context.read<InvoicesBloc>().add(
                          SubMunicipalitySelectedEvent(
                            subMunicipality: selectedItem,
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
