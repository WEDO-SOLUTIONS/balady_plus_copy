import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/utils/constants/dialog_names.dart';
import '../../../../../../core/utils/constants/route_names.dart';
import '../../../../../_shared_feature_/shared_feature_exports.dart'
    show BottomSheetDialog, BottomSheetList, DropDownWithTitle;
import '../../../licenses_exports.dart'
    show
        GetLicenseTypesEvent,
        LicenseTypeSelectedEvent,
        LicensesBloc,
        LicensesState;

class LicensesTypeFilter extends StatelessWidget {
  const LicensesTypeFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LicensesBloc, LicensesState>(
      buildWhen: (previous, current) =>
          previous.licenseTypesStatus != current.licenseTypesStatus ||
          previous.selectedLicenseType != current.selectedLicenseType,
      builder: (context, state) {
        return DropDownWithTitle(
          title: "license_type".tr(),
          selectedValue: state.selectedLicenseType?.name,
          status: state.licenseTypesStatus,
          onRetry: () =>
              context.read<LicensesBloc>().add(GetLicenseTypesEvent()),
          onTap: () {
            final List<String> items =
                state.licenseTypes.map((e) => e.name).toList();
            BottomSheetDialog.showDraggableSheet(
              context,
              dialogKeyName: DialogName.licensesTypesFilters,
              currentRouteName: RouteName.licenses,
              child: BottomSheetList(
                title: "license_type".tr(),
                items: items,
                selectedValue: state.selectedLicenseType?.name,
                onTap: (item) {
                  final licenseType =
                      state.licenseTypes.where((e) => e.name == item).first;
                  context.read<LicensesBloc>().add(
                        LicenseTypeSelectedEvent(
                          licenseType: licenseType,
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
