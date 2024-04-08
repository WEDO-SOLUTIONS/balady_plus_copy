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

import '../../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';

class PreviousNextButtons extends StatelessWidget {
  const PreviousNextButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateVDBloc, CreateVDState>(
      builder: (context, state) {
        bool isButtonDisabled = !state.isNextButtonEnabled();
        bool isLastPage = context.read<CreateVDBloc>().isLastPage();
        return Container(
          color: Colors.transparent,
          padding: EdgeInsets.only(right: 16, left: 16, top: 5, bottom: 30),
          child: EnhancedCustomElevatedButtonWidget(
            btnColor:
                isButtonDisabled ? AppColor.black200 : AppColor.primary900Light,
            btnTextColor: isButtonDisabled ? AppColor.black400 : AppColor.white,
            btnPressed: isButtonDisabled
                ? () {}
                : () {
                    if (!isLastPage) {
                      context.read<CreateVDBloc>().add(GoToNextPageEvent());
                    } else {
                      context.read<CreateVDBloc>().add(SubmitIncidentEvent());
                    }
                  },
            btnRadius: 8,
            btnText: isLastPage ? ("vd_submit_incident").tr() : ("next").tr(),
            btnTextSize: 16,
            btnTextWeight: AppFontWeight.bold,
            btnHeight: 56,
          ),
        );
      },
    );
  }
}
