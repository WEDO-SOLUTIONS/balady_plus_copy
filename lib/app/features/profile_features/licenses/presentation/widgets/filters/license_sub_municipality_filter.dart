import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/utils/utils_exports.dart' show BlocRequestStatus;
import '../../../../../_shared_feature_/shared_feature_exports.dart'
    show
        BottomSheetDialog,
        BottomSheetList,
        DropDownWithTitle,
        MessageDialog,
        RetryWidget;
import '../../../licenses_exports.dart'
    show
        GetSubMunicipalitiesEvent,
        LicensesBloc,
        LicensesState,
        SubMunicipalitySelectedEvent;

class LicensesSubMunicipalityFilter extends StatelessWidget {
  const LicensesSubMunicipalityFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LicensesBloc, LicensesState>(
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
                      context.read<LicensesBloc>().add(
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
              child: BottomSheetList(
                title: "sub_municipality".tr(),
                items: items,
                selectedValue: state.selectedSubMunicipality?.name,
                onTap: (item) {
                  final selectedItem = state.subMunicipalities
                      .where((e) => e.name == item)
                      .first;
                  context.read<LicensesBloc>().add(
                        SubMunicipalitySelectedEvent(
                          subMunicipality: selectedItem,
                        ),
                      );
                  Navigator.pop(context);
                },
              ),
            );
          },
        );
      },
    );
  }
}
