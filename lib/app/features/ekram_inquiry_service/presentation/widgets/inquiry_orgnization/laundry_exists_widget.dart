import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/ekram_inquiry_service/presentation/bloc/inquiry_cemetry_bloc/ekram_inquiry_cemetry_bloc.dart';
import 'package:balady_plus/app/features/ekram_inquiry_service/presentation/bloc/inquiry_cemetry_bloc/ekram_inquiry_cemetry_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/radio_buttons/custom_radio_button_widget copy.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../bloc/inquiry_cemetry_bloc/ekram_inquiry_cemetry_event.dart';

class LaundryExistsWidget extends StatelessWidget {
  const LaundryExistsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EkramInquiryCemetryBloc, EkramInquiryCemetryState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextWidget(
              ("ekram_laundry_exists").tr(),
              fontColor: AppColor.blackModern700Light,
              fontSize: 17.0,
              textAlign: TextAlign.start,
              fontWeight: AppFontWeight.bold,
            ),
            Row(
              children: [
                Expanded(
                  child: CustomRadioButtonEnd<bool>(
                    title: ("yes").tr(),
                    value: true,
                    currentSelected: state.laundryExist == true,
                    onChange: (bool item) {
                      context
                          .read<EkramInquiryCemetryBloc>()
                          .add(ChangeLaundryExistEvent(value: true));
                    },
                    endRadio: false,
                    unSelectedBackgroundColor: Colors.transparent,
                    textSize: 16,
                  ),
                ),
                CustomVerticalSpace(height: 10),
                Expanded(
                  child: CustomRadioButtonEnd<bool>(
                    title: ("no").tr(),
                    value: true,
                    currentSelected: state.laundryExist == false,
                    onChange: (bool item) {
                      context
                          .read<EkramInquiryCemetryBloc>()
                          .add(ChangeLaundryExistEvent(value: false));
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
