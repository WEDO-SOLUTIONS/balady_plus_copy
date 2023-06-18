import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/vd/vd_exports.dart'
    show
        CreateVDBloc,
        CreateVDState,
        GoToNextPageEvent,
        GoToPreviousPageEvent,
        SubmitIncidentEvent;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/enums/enums.dart';
import '../../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';

class PreviousNextButtons extends StatelessWidget {
  const PreviousNextButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateVDBloc, CreateVDState>(
      builder: (context, state) {
        print(state);
        bool isButtonDisabled = !state.isNextButtonEnabled();
        bool isLastPage = context.read<CreateVDBloc>().isLastPage();
        return Container(
          color: Colors.transparent,
          padding: EdgeInsets.only(right: 16, left: 16, top: 5, bottom: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomTextButtonWidget(
                  btnTextSize: 16,
                  btnTextColor: AppColor.darkTurquoise,
                  onPressed: () {
                    context.read<CreateVDBloc>().add(GoToPreviousPageEvent());
                  },
                  text: ("vd_previous").tr()),
              !isLastPage
                  ? EnhancedCustomElevatedButtonWidget(
                      btnPressed: isButtonDisabled
                          ? () {}
                          : () {
                              context
                                  .read<CreateVDBloc>()
                                  .add(GoToNextPageEvent());
                            },
                      btnText: ("vd_next").tr(),
                      btnTextSize: 16,
                      btnTextWeight: AppFontWeight.bold,
                      btnHeight: 56,
                      btnWidth: 105,
                      icon: Image.asset(
                        IconPath.vdarrowLeftIcon,
                        height: 16,
                        width: 16,
                        color: isButtonDisabled
                            ? AppColor.black200
                            : AppColor.darkTurquoise,
                      ),
                      buttonIconPosition: BUTTON_ICON_POSITION.left,
                      btnBorderColor: isButtonDisabled
                          ? AppColor.black200
                          : AppColor.darkTurquoise,
                      btnColor: Colors.transparent,
                      btnTextColor: isButtonDisabled
                          ? AppColor.black200
                          : AppColor.darkTurquoise,
                    )
                  : EnhancedCustomElevatedButtonWidget(
                      btnColor: isButtonDisabled
                          ? AppColor.black200
                          : AppColor.darkTurquoise,
                      btnTextColor:
                          isButtonDisabled ? AppColor.black400 : AppColor.white,
                      btnPressed: isButtonDisabled
                          ? () {}
                          : () {
                              context
                                  .read<CreateVDBloc>()
                                  .add(SubmitIncidentEvent());
                            },
                      btnText: ("vd_submit_incident").tr(),
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
