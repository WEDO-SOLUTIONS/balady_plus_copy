import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/utils/utils_exports.dart' show BlocRequestStatus;
import '../../../../../_shared_feature_/shared_feature_exports.dart'
    show
        BottomSheetDialog,
        BottomSheetList,
        DraggableSheetComponent,
        DropDownWithTitle;
import '../../../licenses_exports.dart'
    show LicenseStatusSelectedEvent, LicensesBloc, LicensesState;

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
          loading: state.licenseStatusesStatus ==
              BlocRequestStatus.submissionGetLoading,
          onTap: () {
            final List<String> items =
                state.licenseStatuses.map((e) => e.name).toList();
            BottomSheetDialog.showDraggableSheet(
              context,
              child: DraggableSheetComponent(
                title: "product".tr(),
                height: 0.8,
                body: BottomSheetList(
                  items: items,
                  selectedValue: state.selectedLicenseStatus?.name,
                  onTap: (item) {
                    final licenseStatus = state.licenseStatuses
                        .where((e) => e.name == item)
                        .first;
                    context.read<LicensesBloc>().add(
                          LicenseStatusSelectedEvent(
                            licenseStatus: licenseStatus,
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
