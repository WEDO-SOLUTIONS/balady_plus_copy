import 'package:balady_plus/etmam_app/core/utils/constants/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/utils/constants/app_colors.dart';
import '../../../../../../core/utils/enums/app_font_weights.dart';
import '../../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../../_shared_feature_/presentation/widgets/radio_buttons/custom_radio_button_widget copy.dart';
import '../../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../blocs/submit_renew_commercial_bloc/renew_commercial_license_bloc.dart';

class IsShopInsidePetroStationWidget extends StatelessWidget {
  const IsShopInsidePetroStationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RenewCommercialLicenseBloc, RenewCommercialLicenseState>(
      builder: (context, state) {
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
            CustomVerticalSpace(height: 10),
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
                context
                    .read<RenewCommercialLicenseBloc>()
                    .add(const ChangeInsidePetrolStationEvent(value: false));
              },
              endRadio: false,
              unSelectedBackgroundColor: Colors.transparent,
              textSize: 16,
            ),
          ],
        );
      },
    );
  }
}
