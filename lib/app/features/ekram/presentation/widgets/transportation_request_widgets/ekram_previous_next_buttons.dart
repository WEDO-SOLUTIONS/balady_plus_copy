import 'package:balady_new_app/app/core/core_exports.dart';
import 'package:balady_new_app/app/features/ekram/ekram_exports.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                  btnTextColor: AppColors.darkTurquoise,
                  btnPressed: () {
                    context
                        .read<EkramRequestTransportationBloc>()
                        .add(GoToPreviousPageEvent());
                  },
                  btnText: Helpers.translatingWord("vd_previous")),
              !isLastPage
                  ? CustomElevatedButtonWidget(
                      btnPressed: isButtonDisabled
                          ? () {}
                          : () {
                              context
                                  .read<EkramRequestTransportationBloc>()
                                  .add(GoToNextPageEvent());
                            },
                      btnText: Helpers.translatingWord("vd_next"),
                      btnTextSize: 16,
                      btnTextWeight: FONT_WEIGHT.bold,
                      btnHeight: 56,
                      btnWidth: 105,
                      icon: Image.asset(
                        Constants.imgPath + "arrowLeftSLightCopy@3x.png",
                        height: 16,
                        width: 16,
                        color: isButtonDisabled
                            ? AppColors.black200
                            : AppColors.darkTurquoise,
                      ),
                      buttonIconPosition: BUTTON_ICON_POSITION.left,
                      btnBorderColor: isButtonDisabled
                          ? AppColors.black200
                          : AppColors.darkTurquoise,
                      btnColor: Colors.transparent,
                      btnTextColor: isButtonDisabled
                          ? AppColors.black200
                          : AppColors.darkTurquoise,
                    )
                  : CustomElevatedButtonWidget(
                      btnColor: isButtonDisabled
                          ? AppColors.black200
                          : AppColors.darkTurquoise,
                      btnTextColor: isButtonDisabled
                          ? AppColors.black400
                          : AppColors.white,
                      btnPressed: isButtonDisabled
                          ? () {}
                          : () {
                              context
                                  .read<EkramRequestTransportationBloc>()
                                  .add(SubmitRequestEvent());
                            },
                      btnText: Helpers.translatingWord("ekramSubmitOrder"),
                      btnTextSize: 16,
                      btnTextWeight: FONT_WEIGHT.bold,
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
