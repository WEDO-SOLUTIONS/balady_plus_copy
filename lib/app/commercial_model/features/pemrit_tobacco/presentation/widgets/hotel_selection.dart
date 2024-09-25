import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import '../../../../../features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../../features/_shared_feature_/presentation/widgets/radio_buttons/custom_radio_button_widget copy.dart';
import '../../../../../features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../blocs/permit_tobacco_bloc.dart';

class HotelSelectionWidget extends StatelessWidget {
  const HotelSelectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PermitTobaccoLicenseBloc, PermitTobaccoLicenseState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextWidget(
              ("licence_inside_hotel").tr(),
              fontColor: AppColor.blackModern700Light,
              fontSize: 17.0,
              textAlign: TextAlign.start,
              fontWeight: AppFontWeight.bold,
            ),
            const CustomVerticalSpace(height: 16),
            Row(
              children: [
                Expanded(
                  child: CustomRadioButtonEnd<bool>(
                    title: ("yes").tr(),
                    value: true,
                    currentSelected: state.isInsideHotel,
                    onChange: (bool item) {
                      context
                          .read<PermitTobaccoLicenseBloc>()
                          .add(ChangeIsIndieHotelEvent(value: item));
                    },
                    endRadio: false,
                    unSelectedBackgroundColor: Colors.transparent,
                    textSize: 16,
                  ),
                ),
                const CustomHorizontalSpace(width: 10),
                Expanded(
                  child: CustomRadioButtonEnd<bool>(
                    title: ("no").tr(),
                    value: false,
                    currentSelected: state.isInsideHotel,
                    onChange: (bool item) {
                      context
                          .read<PermitTobaccoLicenseBloc>()
                          .add(ChangeIsIndieHotelEvent(value: item));
                    },
                    endRadio: false,
                    unSelectedBackgroundColor: Colors.transparent,
                    textSize: 16,
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
