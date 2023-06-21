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
        MessageDialog;
import '../../../licenses_exports.dart'
    show LicenseSubTypeSelectedEvent, LicensesBloc, LicensesState;

class LicensesTypeFilter extends StatelessWidget {
  const LicensesTypeFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LicensesBloc, LicensesState>(
      buildWhen: (previous, current) =>
          previous.licenseSubTypesStatus != current.licenseSubTypesStatus ||
          previous.selectedLicenseSubType != current.selectedLicenseSubType ||
          previous.selectedLicenseType != current.selectedLicenseType,
      builder: (context, state) {
        return DropDownWithTitle(
          title: "license_type".tr(),
          selectedValue: state.selectedLicenseSubType?.name,
          loading: state.licenseSubTypesStatus ==
              BlocRequestStatus.submissionGetLoading,
          onTap: () {
            if (state.selectedLicenseType == null) {
              MessageDialog.showErrorNotification(
                msg: '${"choose".tr()} ${"product".tr()} ${"first".tr()}',
              );
              return;
            }
            final List<String> items =
                state.licenseSubTypes.map((e) => e.name).toList();
            BottomSheetDialog.showDraggableSheet(
              context,
              child: DraggableSheetComponent(
                title: "license_type".tr(),
                height: 0.8,
                body: BottomSheetList(
                  items: items,
                  selectedValue: state.selectedLicenseSubType?.name,
                  onTap: (item) {
                    final licenseSubType = state.licenseSubTypes
                        .where((e) => e.name == item)
                        .first;
                    context.read<LicensesBloc>().add(
                          LicenseSubTypeSelectedEvent(
                            licenseSubtype: licenseSubType,
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
