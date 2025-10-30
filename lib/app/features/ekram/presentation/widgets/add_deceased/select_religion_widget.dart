import 'package:balady_plus/app/features/ekram/presentation/blocs/ekram_add_deceased/ekram_add_deceased_bloc.dart';
import 'package:balady_plus/etmam_app/core/utils/constants/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/enums/app_font_weights.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/radio_buttons/custom_radio_button_widget copy.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';

class SelectReligionWidget extends StatelessWidget {
  const SelectReligionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EkramAddDeceasedBloc, EkramAddDeceasedState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextWidget(
              trans("ekramReligion"),
              fontColor: AppColor.blackModern700Light,
              fontSize: 16.0,
              textAlign: TextAlign.start,
              fontWeight: AppFontWeight.bold,
            ),
            CustomVerticalSpace(height: 10),
            CustomRadioButtonEnd<bool>(
              title: trans("muslim"),
              value: true,
              currentSelected: state.data?.isMuslim == true,
              onChange: (bool item) {
                print(item);
                context
                    .read<EkramAddDeceasedBloc>()
                    .add(ChangeReligionEvent(item: true));
              },
              endRadio: false,
              unSelectedBackgroundColor: Colors.transparent,
              textSize: 16,
            ),
            CustomVerticalSpace(height: 10),
            CustomRadioButtonEnd<bool>(
              title: trans("non_muslim"),
              value: true,
              currentSelected:
                  state.data?.isMuslim != null && state.data?.isMuslim == false,
              onChange: (bool item) {
                context
                    .read<EkramAddDeceasedBloc>()
                    .add(ChangeReligionEvent(item: false));
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
