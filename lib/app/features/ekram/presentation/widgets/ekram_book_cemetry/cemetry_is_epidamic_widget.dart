import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/radio_buttons/custom_radio_button_widget copy.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../blocs/ekram_book_cemetry/ekram_book_cemetry_bloc.dart';

class CemetryIsEpidamicWidget extends StatelessWidget {
  const CemetryIsEpidamicWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EkramBookCemetryBloc, EkramBookCemetryState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextWidget(
              "${("cemetry_deceassed_epidamic").tr()} *",
              fontColor: AppColor.primary900Light,
              fontSize: 13.0,
              textAlign: TextAlign.start,
              fontWeight: AppFontWeight.bold,
            ),
            const CustomVerticalSpace(height: 10),
            CustomRadioButtonEnd<bool>(
              isDisabled: state.deceasedInfoModel?.deceasedDataSource == 'SEHA',
              title: ("yes").tr(),
              value: true,
              currentSelected: state.isPandemicDeath == true,
              onChange: (bool item) {
                context
                    .read<EkramBookCemetryBloc>()
                    .add(ChangeIsEpidamicEvent(value: true));
              },
              endRadio: false,
              unSelectedBackgroundColor: Colors.transparent,
              textSize: 16,
            ),
            const CustomVerticalSpace(height: 10),
            CustomRadioButtonEnd<bool>(
              isDisabled:
                  state.isdeceasedInfoReadOnly && state.deathInfo != null,
              title: ("no").tr(),
              value: true,
              currentSelected: state.isPandemicDeath == false,
              onChange: (bool item) {
                context
                    .read<EkramBookCemetryBloc>()
                    .add(ChangeIsEpidamicEvent(value: false));
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
