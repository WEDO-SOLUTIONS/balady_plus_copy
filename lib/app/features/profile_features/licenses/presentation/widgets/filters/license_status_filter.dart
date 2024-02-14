import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/utils/constants/dialog_names.dart';
import '../../../../../../core/utils/constants/route_names.dart';
import '../../../../../_shared_feature_/shared_feature_exports.dart'
    show BottomSheetDialog, BottomSheetList, DropDownWithTitle;
import '../../../licenses_exports.dart'
    show
        GetLicenseStatusesEvent,
        LicenseStatusSelectedEvent,
        LicensesBloc,
        LicensesState;

class LicensesStatusFilter extends StatelessWidget {
  const LicensesStatusFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LicensesBloc, LicensesState>(
      buildWhen: (previous, current) =>
          previous.licenseStatusesStatus != current.licenseStatusesStatus ||
          previous.selectedLicenseStatus != current.selectedLicenseStatus,
      builder: (context, state) {
        return DropDownWithTitle(
          title: "license_status".tr(),
          selectedValue: state.selectedLicenseStatus?.name,
          status: state.licenseStatusesStatus,
          onRetry: () => context.read<LicensesBloc>().add(
                GetLicenseStatusesEvent(),
              ),
          onTap: () {
            final List<String> items =
                state.licenseStatuses.map((e) => e.name).toList();
            BottomSheetDialog.showDraggableSheet(
              context,
              dialogKeyName: DialogName.licensesProductsFilters,
              currentRouteName: RouteName.licenses,
              child: BottomSheetList(
                title: "license_status".tr(),
                items: items,
                selectedValue: state.selectedLicenseStatus?.name,
                onTap: (item) {
                  final licenseStatus =
                      state.licenseStatuses.where((e) => e.name == item).first;
                  context.read<LicensesBloc>().add(
                        LicenseStatusSelectedEvent(
                          licenseStatus: licenseStatus,
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
