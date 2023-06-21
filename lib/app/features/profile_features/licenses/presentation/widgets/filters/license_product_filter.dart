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
    show LicenseTypeSelectedEvent, LicensesBloc, LicensesState;

class LicensesProductFilter extends StatelessWidget {
  const LicensesProductFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LicensesBloc, LicensesState>(
      buildWhen: (previous, current) =>
          previous.licenseTypesStatus != current.licenseTypesStatus ||
          previous.selectedLicenseType != current.selectedLicenseType,
      builder: (context, state) {
        return DropDownWithTitle(
          title: "product".tr(),
          selectedValue: state.selectedLicenseType?.name,
          loading: state.licenseTypesStatus ==
              BlocRequestStatus.submissionGetLoading,
          onTap: () {
            final List<String> items =
                state.licenseTypes.map((e) => e.name).toList();
            BottomSheetDialog.showDraggableSheet(
              context,
              child: DraggableSheetComponent(
                title: "product".tr(),
                height: 0.8,
                body: BottomSheetList(
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
              ),
            );
          },
        );
      },
    );
  }
}
