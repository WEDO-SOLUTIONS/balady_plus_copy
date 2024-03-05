import 'package:balady_plus/app/features/ekram/presentation/blocs/ekram_add_deceased/ekram_add_deceased_bloc.dart';
import 'package:balady_plus/etmam_app/core/utils/constants/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/enums/app_font_weights.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/radio_buttons/custom_radio_button_widget copy.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';

class DeceasedRequiredTransferWidget extends StatelessWidget {
  const DeceasedRequiredTransferWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EkramAddDeceasedBloc, EkramAddDeceasedState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextWidget(
              trans("is_deaceased_requrie_special_transfer"),
              fontColor: AppColor.blackModern700Light,
              fontSize: 16.0,
              maxLines: 2,
              textAlign: TextAlign.start,
              fontWeight: AppFontWeight.bold,
            ),
            CustomVerticalSpace(height: 10),
            CustomRadioButtonEnd<bool>(
              title: trans("yes"),
              value: true,
              currentSelected: state.data?.specialTransferNeeded == true,
              onChange: (bool item) {
                context
                    .read<EkramAddDeceasedBloc>()
                    .add(ChangeIsNeedSpecialTransferEvent(isNeeded: true));
              },
              endRadio: false,
              unSelectedBackgroundColor: Colors.transparent,
              textSize: 16,
            ),
            CustomVerticalSpace(height: 10),
            CustomRadioButtonEnd<bool>(
              title: trans("no"),
              value: true,
              currentSelected: state.data?.specialTransferNeeded == false,
              onChange: (bool item) {
                context
                    .read<EkramAddDeceasedBloc>()
                    .add(ChangeIsNeedSpecialTransferEvent(isNeeded: false));
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
