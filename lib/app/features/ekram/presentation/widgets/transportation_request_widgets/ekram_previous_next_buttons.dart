import 'package:balady_plus/app/features/ekram/ekram_exports.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/services/local/helpers.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/constants.dart';
import '../../../../../core/utils/enums/app_font_weights.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';

class EkramPreviousNextButtons extends StatelessWidget {
  const EkramPreviousNextButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EkramRequestTransportationBloc,
        EkramRequestTransportationState>(
      builder: (context, state) {
        bool isButtonDisabled = !state.isNextButtonEnabled();
        bool isLastPage =
            context.read<EkramRequestTransportationBloc>().isLastPage();
        return Container(
          color: Colors.transparent,
          padding: EdgeInsets.only(right: 16, left: 16, top: 5, bottom: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomTextButtonWidget(
                  btnTextSize: 16,
                  btnTextColor: AppColor.primary900Light,
                  onPressed: () {
                    context
                        .read<EkramRequestTransportationBloc>()
                        .add(GoToPreviousPageEvent());
                  },
                  text: Helpers.translatingWord("vd_previous")),
              !isLastPage
                  ? EnhancedCustomElevatedButtonWidget(
                      btnPressed: isButtonDisabled
                          ? () {}
                          : () {
                              context
                                  .read<EkramRequestTransportationBloc>()
                                  .add(GoToNextPageEvent());
                            },
                      btnText: Helpers.translatingWord("vd_next"),
                      btnTextSize: 16,
                      btnTextWeight: AppFontWeight.bold,
                      btnHeight: 56,
                      btnWidth: 105,
                      icon: Image.asset(
                        Constants.imgPath + "arrowLeftSLightCopy@3x.png",
                        height: 16,
                        width: 16,
                        color: isButtonDisabled
                            ? AppColor.black200
                            : AppColor.primary900Light,
                      ),
                      buttonIconPosition: BUTTON_ICON_POSITION.left,
                      btnBorderColor: isButtonDisabled
                          ? AppColor.black200
                          : AppColor.primary900Light,
                      btnColor: Colors.transparent,
                      btnTextColor: isButtonDisabled
                          ? AppColor.black200
                          : AppColor.primary900Light,
                    )
                  : EnhancedCustomElevatedButtonWidget(
                      btnColor: isButtonDisabled
                          ? AppColor.black200
                          : AppColor.primary900Light,
                      btnTextColor:
                          isButtonDisabled ? AppColor.black400 : AppColor.white,
                      btnPressed: isButtonDisabled
                          ? () {}
                          : () {
                              context
                                  .read<EkramRequestTransportationBloc>()
                                  .add(SubmitRequestEvent());
                            },
                      btnText: Helpers.translatingWord("ekramSubmitOrder"),
                      btnTextSize: 16,
                      btnTextWeight: AppFontWeight.bold,
                      btnHeight: 56,
                      btnWidth: 142,
                    )
            ],
          ),
        );
      },
    );
  }
}
