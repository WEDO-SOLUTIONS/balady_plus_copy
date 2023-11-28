import 'package:balady_plus/app/features/ekram/presentation/blocs/ekram_add_deceased/ekram_add_deceased_bloc.dart';
import 'package:balady_plus/etmam_app/core/utils/constants/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/enums/app_font_weights.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/radio_buttons/custom_radio_button_widget copy.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../../new_appointment/presentation/core/models/lookup_list_model.dart';

class SelectGenderWidget extends StatelessWidget {
  const SelectGenderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EkramAddDeceasedBloc, EkramAddDeceasedState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextWidget(
              trans("ekramGender"),
              fontColor: AppColor.primary900Light,
              fontSize: 13.0,
              textAlign: TextAlign.start,
              fontWeight: AppFontWeight.bold,
            ),
            CustomVerticalSpace(height: 10),
            CustomRadioButtonEnd<LookUpItem>(
              title: trans("male"),
              value: LookUpItem(id: 1, name: trans("male")),
              currentSelected: state.data.genderId,
              onChange: (LookUpItem item) {
                context
                    .read<EkramAddDeceasedBloc>()
                    .add(ChangeGenderEvent(item: item));
              },
              endRadio: false,
              unSelectedBackgroundColor: Colors.transparent,
              textSize: 16,
            ),
            CustomVerticalSpace(height: 10),
            CustomRadioButtonEnd<LookUpItem>(
              title: trans("female"),
              value: LookUpItem(id: 2, name: trans("female")),
              currentSelected: state.data.genderId,
              onChange: (LookUpItem item) {
                context
                    .read<EkramAddDeceasedBloc>()
                    .add(ChangeGenderEvent(item: item));
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
