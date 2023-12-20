import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../bloc/violation_bloc.dart';
import '../../bloc/violation_state.dart';

class ViolationAddedActionWidget extends StatelessWidget {
  const ViolationAddedActionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ViolationBloc, ViolationState>(
        builder: (context, state) {
      return Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextWidget(
                "correct_violation".tr(),
                textStyle: AppStyle.approvedViolationLabelStyle,
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTextWidget(
                state.details?.isCorrectionNeeded == true
                    ? "yes".tr()
                    : "no".tr(),
                textStyle: AppStyle.approvedViolationSubtitle,
              ),
            ]),
      );
    });
  }
}
