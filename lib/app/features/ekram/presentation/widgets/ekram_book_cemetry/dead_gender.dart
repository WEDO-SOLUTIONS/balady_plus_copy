import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/radio_buttons/custom_radio_button_widget copy.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../blocs/ekram_book_cemetry/ekram_book_cemetry_bloc.dart';

class DeadGenderWidget extends StatelessWidget {
  const DeadGenderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EkramBookCemetryBloc, EkramBookCemetryState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextWidget(
              "${("sex").tr()} *",
              fontColor: AppColor.blackModern700Light,
              fontSize: 17.0,
              textAlign: TextAlign.start,
              fontWeight: AppFontWeight.bold,
            ),
            Row(
              children: [
                Expanded(
                  child: CustomRadioButtonEnd<String>(
                    isDisabled: state.isdeceasedInfoReadOnly,
                    title: ("male").tr(),
                    value: 'MALE',
                    currentSelected: state.gender,
                    onChange: (String item) {
                      context
                          .read<EkramBookCemetryBloc>()
                          .add(ChangeGenderEvent(value: item));
                    },
                    endRadio: false,
                    unSelectedBackgroundColor: Colors.transparent,
                    textSize: 16,
                  ),
                ),
                const CustomVerticalSpace(height: 10),
                Expanded(
                  child: CustomRadioButtonEnd<String>(
                    isDisabled: state.isdeceasedInfoReadOnly,
                    title: ("female").tr(),
                    value: 'FEMALE',
                    currentSelected: state.gender,
                    onChange: (String item) {
                      context
                          .read<EkramBookCemetryBloc>()
                          .add(ChangeGenderEvent(value: item));
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
