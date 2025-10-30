import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/common_functions.dart';
import '../../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../_shared_feature_/presentation/under_testing/custom_expansion_panel_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../bloc/compliance_bloc.dart';
import '../../bloc/compliance_state.dart';
import 'field_data.dart';

class Step3SummeryWidget extends StatelessWidget {
  const Step3SummeryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ComplianceBloc, ComplianceState>(
      builder: (context, state) {
        return CustomExpansionPanelWidget(
          title: ("submission_document").tr(),
          leading: SvgPicture.asset(IconPath.vdSummuryUserInfo),
          children: [
            FieldData(
              title: ("submission_document").tr(),
              subTitle: state.documentTypeSelection == 1
                  ? "document_1".tr()
                  : "document_2".tr(),
            ),
            CustomVerticalSpace(height: 8),
            if (state.documentTypeSelection == 1)
              FieldData(
                title: ("license_no").tr(),
                subTitle:
                    state.selectedLicense?.licenseId?.toInt().toString() ?? "",
              ),
            CustomVerticalSpace(height: 8),
            if (state.documentTypeSelection == 2) ...[
              FieldData(
                  title: ("compliance_ownership_type").tr(),
                  subTitle: state.selectedOwnerShip?.name),
              CustomVerticalSpace(height: 8),
              if (state.selectedOwnerShip?.id == 112) ...[
                // صك
                FieldData(
                    title: ("compliance_deed_number_text").tr(),
                    subTitle: state.ownershipText),
                CustomVerticalSpace(height: 8),
                FieldData(
                    title: ("compliance_deed_number_date").tr(),
                    subTitle: state.ownershipDate),
              ],
              if (state.selectedOwnerShip?.id == 146) ...[
//عقد اسكان
                FieldData(
                    title: ("compliance_land_number").tr(),
                    subTitle: state.ownershipText),
                CustomVerticalSpace(height: 8),
                FieldData(
                    title: ("compliance_land_date").tr(),
                    subTitle: state.ownershipDate),
              ],
              if (state.selectedOwnerShip?.id == 340) ...[
                //ايصال كهرباء او مياه
                FieldData(
                    title: ("compliance_electricity_type").tr(),
                    subTitle: state.selectedReciptType?.name),
                CustomVerticalSpace(height: 8),
                FieldData(
                    title: ("compliance_electricity_number").tr(),
                    subTitle: state.ownershipText),
                CustomVerticalSpace(height: 8),
                FieldData(
                    title: ("compliance_electricity_number_date").tr(),
                    subTitle: state.ownershipDate),
              ],
              if (state.selectedOwnerShip?.id == 664) ...[
                // عقد استثماري - تخصيص حكومي
                FieldData(
                    title: ("compliance_investment_number").tr(),
                    subTitle: state.ownershipText),
                CustomVerticalSpace(height: 8),
                FieldData(
                    title: ("compliance_investment_number_date").tr(),
                    subTitle: state.ownershipDate),
              ],
            ],
          ],
        );
      },
    );
  }
}
