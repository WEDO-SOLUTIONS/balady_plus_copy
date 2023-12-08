import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/utils/constants/dialog_names.dart';
import '../../../../../../core/utils/constants/route_names.dart';
import '../../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../municipal_advisor_exports.dart';

class LicenseYearsSelector extends StatelessWidget {
  const LicenseYearsSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        BlocBuilder<MunicipalAdvisorBloc, MunicipalAdvisorState>(
          buildWhen: (previous, current) =>
              previous.selectedLicenseYear != current.selectedLicenseYear,
          builder: (context, state) {
            return DropDownWithTitle(
              title: "LicenseYears".tr(),
              selectedValue: state.selectedLicenseYear.toString(),
              onTap: () {
                final List<String> items =
                    state.licenseYears.map((e) => e.toString()).toList();
                BottomSheetDialog.showDraggableSheet(
                  context,
                  dialogKeyName: DialogName.municipalAdvisorLicenseYears,
                  currentRouteName: RouteName.municipalAdvisor,
                  child: BottomSheetList(
                    title: "LicenseYears".tr(),
                    items: items,
                    selectedValue: state.selectedLicenseYear.toString(),
                    onTap: (item) {
                      BlocProvider.of<MunicipalAdvisorBloc>(context).add(
                        MunicipalAdvisorSelectLiceseYearEvent(
                          year: int.parse(item),
                        ),
                      );
                      Navigator.pop(context);
                    },
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
