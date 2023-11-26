import 'package:balady_new_app/app/core/shared_local_services/app_colors.dart';
import 'package:balady_new_app/app/core/shared_local_services/enums.dart';
import 'package:balady_new_app/app/core/shared_widgets/custom_radio_button_widget.dart';
import 'package:balady_new_app/app/core/shared_widgets/custom_spaces_widgets.dart';
import 'package:balady_new_app/app/core/shared_widgets/custom_text_widget.dart';
import 'package:balady_new_app/app/features/ekram/presentation/blocs/ekram_add_deceased/ekram_add_deceased_bloc.dart';
import 'package:balady_new_app/etmam_app/core/utils/constants/app_config.dart';
import 'package:balady_new_app/shared/core/data/entities/lookup_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
              fontColor: AppColors.baladyDarkGreen2,
              fontSize: 13.0,
              textAlign: TextAlign.start,
              fontWeight: FONT_WEIGHT.bold,
            ),
            CustomVerticalSpace(height: 10),
            CustomRadioButtonEnd<bool>(
              title: trans("muslim"),
              value: true,
              currentSelected: state.data.muslimReligion == true,
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
              currentSelected: state.data.muslimReligion != null &&
                  state.data.muslimReligion == false,
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
