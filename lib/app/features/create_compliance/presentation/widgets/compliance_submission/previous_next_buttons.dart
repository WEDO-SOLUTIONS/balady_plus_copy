import 'package:balady_plus/app/core/utils/utils_exports.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../bloc/compliance_bloc.dart';
import '../../bloc/compliance_state.dart';
import '../../bloc/compliance_event.dart';

class PreviousNextButtons extends StatelessWidget {
  const PreviousNextButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ComplianceBloc, ComplianceState>(
      builder: (context, state) {
        bool isButtonDisabled = !state.isNextButtonEnabled() ||
            (state.appointmentsStatus == BlocStatus.failure &&
                state.responseCode == "CIS-401");
        bool isLastPage = context.read<ComplianceBloc>().isLastPage();
        return Container(
          color: Colors.transparent,
          padding: EdgeInsets.only(right: 16, left: 16, top: 5, bottom: 30),
          child: EnhancedCustomElevatedButtonWidget(
            btnColor:
                isButtonDisabled ? AppColor.black200 : AppColor.primary900Light,
            btnTextColor: isButtonDisabled ? AppColor.black400 : AppColor.white,
            btnPressed: isButtonDisabled ||
                    state.status == BlocStatus.loading ||
                    state.detailsStatus == BlocStatus.loading
                ? () {}
                : () {
                    if (!isLastPage) {
                      context.read<ComplianceBloc>().add(GoToNextPageEvent());
                    } else {
                      context.read<ComplianceBloc>().add(GoToNextPageEvent());
                    }
                  },
            btnRadius: 8,
            btnText: isLastPage ? ('submit_order').tr() : ("next").tr(),
            btnTextSize: 16,
            btnTextWeight: AppFontWeight.bold,
            btnHeight: 56,
          ),
        );
      },
    );
  }
}
