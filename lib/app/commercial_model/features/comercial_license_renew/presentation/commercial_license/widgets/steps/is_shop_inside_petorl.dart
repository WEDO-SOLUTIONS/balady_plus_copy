import 'package:balady_plus/etmam_app/core/utils/constants/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/keys/general_keys.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import '../../../../../../../features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../../../../features/_shared_feature_/presentation/widgets/radio_buttons/custom_radio_button_widget copy.dart';
import '../../../../../../../features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../../../commercial_license/presentation/step4/widgets/yes_no_radio_group_widget.dart';
import '../../blocs/submit_renew_commercial_bloc/renew_commercial_license_bloc.dart';

class IsShopInsidePetroStationWidget extends StatelessWidget {
  const IsShopInsidePetroStationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RenewCommercialLicenseBloc, RenewCommercialLicenseState>(
      builder: (context, state) {
        return YesNoRadioGroupWidget(
          groupName: "is_license_inside_petrol_station".tr(),
          currentValue: state.insidePetrolStation,
          onChanged: (value) {
            if (value != null) {
              context
                  .read<RenewCommercialLicenseBloc>()
                  .add(ChangeInsidePetrolStationEvent(value: value));
            }
          },
        );
        /// Warning need Fix
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextWidget(
              trans("is_license_inside_petrol_station"),
              fontColor: AppColor.blackModern700Light,
              fontSize: 16.0,
              textAlign: TextAlign.start,
              fontWeight: AppFontWeight.bold,
            ),
            const CustomVerticalSpace(height: GeneralKey.smallPadding),
            Row(
              children: [
                CustomRadioButtonEnd<bool>(
                  title: trans("yes"),
                  value: true,
                  currentSelected: state.insidePetrolStation == true,
                  onChange: (bool item) {
                    context
                        .read<RenewCommercialLicenseBloc>()
                        .add(const ChangeInsidePetrolStationEvent(value: true));
                  },
                  endRadio: false,
                  unSelectedBackgroundColor: Colors.transparent,
                  textSize: 16,
                ),
                const CustomVerticalSpace(height: 10),
                CustomRadioButtonEnd<bool>(
                  title: trans("no"),
                  value: true,
                  currentSelected: state.insidePetrolStation == false,
                  onChange: (bool item) {
                    context.read<RenewCommercialLicenseBloc>().add(
                        const ChangeInsidePetrolStationEvent(value: false));
                  },
                  endRadio: false,
                  unSelectedBackgroundColor: Colors.transparent,
                  textSize: 16,
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
