import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/utils/constants/dialog_names.dart';
import '../../../../../../core/utils/constants/route_names.dart';
import '../../../../../_shared_feature_/shared_feature_exports.dart'
    show BottomSheetDialog, BottomSheetList, DropDownWithTitle, MessageDialog;
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
        return DropDownWithTitle(
          title: "sub_municipality".tr(),
          selectedValue: state.selectedSubMunicipality?.name,
          status: state.subMunicipalitiesStatus,
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
              dialogKeyName: DialogName.licensesSubMunicapilityFilters,
              currentRouteName: RouteName.licenses,
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
