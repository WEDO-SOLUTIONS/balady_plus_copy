import 'package:balady_plus/etmam_app/core/utils/enums/app_font_weight.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/presentation/widgets/custom_buttons_widgets.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/presentation/blocs/edit_bidding_form/edit_bidding_form_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../app/core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/app_config.dart';

class PreviousNextButtons extends StatelessWidget {
  const PreviousNextButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EdtiBiddingFormBloc, EditBiddingFormState>(
      builder: (context, state) {
        print(state);
        bool isButtonDisabled = !state.isNextButtonEnabled();
        bool isLastPage = context.read<EdtiBiddingFormBloc>().isLastPage();

        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: AppColor.white,
            child: SafeArea(
              top: false,
              child: Container(
                /*  padding: const EdgeInsets.symmetric(
                  horizontal: Constants.semiLargePadding,
                ),*/
                /* margin: const EdgeInsets.symmetric(
                  vertical: Constants.smallPadding,
                ),*/
                child: Container(
                  color: Colors.transparent,
                  padding:
                      EdgeInsets.only(right: 16, left: 16, top: 5, bottom: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomElevatedButtonWidget(
                          btnColor: isButtonDisabled
                              ? AppColor.black200
                              : AppColor.primary900Light,
                          btnTextColor: isButtonDisabled
                              ? AppColor.black400
                              : AppColor.white,
                          btnPressed: isButtonDisabled
                              ? () {}
                              : () {
                                  context
                                      .read<EdtiBiddingFormBloc>()
                                      .add(ValidateFormEvent());
                                },
                          btnText: trans("send_order"),
                          btnTextSize: 16,
                          btnTextWeight: AppFontWeight.bold,
                          btnHeight: 56,
                          btnWidth: 142,
                          horizontalMargin: 1 == 1 ? 16 : 0,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
