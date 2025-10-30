import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../bloc/violation_bloc.dart';
import '../../bloc/violation_state.dart';

class ViolationActionWidget extends StatelessWidget {
  const ViolationActionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ViolationBloc, ViolationState>(
        builder: (context, state) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.circular(16)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextWidget(
                      "double_fine".tr(),
                      textStyle: AppStyle.approvedViolationLabelStyle,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextWidget(
                      state.details?.isDoubledOnRepeating == true
                          ? "yes".tr()
                          : "no".tr(),
                      textStyle: AppStyle.approvedViolationSubtitle,
                    ),
                  ]),
            ),
          ),
          SizedBox(
            width: 16,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.circular(16)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextWidget(
                      'duration_fix'.tr(),
                      textStyle: AppStyle.approvedViolationLabelStyle,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextWidget(
                      "${state.details?.correctionPeriod.toString()} ${"lbl_day".tr()}",
                      textStyle: AppStyle.approvedViolationSubtitle,
                    ),
                  ]),
            ),
          ),
        ],
      );
    });
  }
}
