import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/etmam_app/core/utils/constants/app_config.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/presentation/widgets/custom_buttons_widgets.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/presentation/blocs/bidding_form/bidding_form_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../app/core/utils/constants/app_colors.dart';
import '../../../../../app/core/utils/constants/constants.dart';
import '../../../../../app/core/utils/enums/enums.dart'
    hide BUTTON_ICON_POSITION;
import '../../../../../app/features/_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../../core/utils/enums/button_icon_position.dart';

class PreviousNextButtons extends StatelessWidget {
  const PreviousNextButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BiddingFormBloc, BiddingFormState>(
      builder: (context, state) {
        print(state);
        bool isButtonDisabled = !state.isNextButtonEnabled();
        bool isLastPage = context.read<BiddingFormBloc>().isLastPage();

        return Align(
          alignment: Alignment.bottomCenter,
          child: SafeArea(
            top: false,
            child: Container(
              child: Container(
                color: Colors.transparent,
                padding:
                    EdgeInsets.only(right: 16, left: 16, top: 5, bottom: 30),
                child: EnhancedCustomElevatedButtonWidget(
                  btnColor: isButtonDisabled
                      ? AppColor.black200
                      : AppColor.primary900Light,
                  btnTextColor:
                      isButtonDisabled ? AppColor.black400 : AppColor.white,
                  btnPressed: isButtonDisabled
                      ? () {}
                      : () {
                          if (!isLastPage) {
                            context
                                .read<BiddingFormBloc>()
                                .add(GoToNextPageEvent());
                          } else {
                            context
                                .read<BiddingFormBloc>()
                                .add(ValidateFormEvent());
                          }
                        },
                  btnRadius: 8,
                  btnText:
                      isLastPage ? ("send_order").tr() : ("nextButton").tr(),
                  btnTextSize: 16,
                  btnTextWeight: AppFontWeight.bold,
                  btnHeight: 56,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
