import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart' show Translation;

import '../../../../core/services/services_exports.dart' show NavigationService;
import '../../../../core/utils/utils_exports.dart' show AppColor, AppStyle, ContextConversion, UIHelper;
import '../../shared_feature_exports.dart' show CustomElevatedButtonWidget, CustomTextButtonWidget;

class StepperFooterButtonsComponent extends StatelessWidget {
  final VoidCallback? onFinish;
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;
  final bool isFirstStep;
  final bool isLastStep;
  const StepperFooterButtonsComponent({
    super.key,
    this.onFinish,
    this.onNext,
    this.onPrevious,
    required this.isFirstStep,
    required this.isLastStep,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Close button
          AnimatedCrossFade(
            firstChild: CustomTextButtonWidget(
              onPressed: context.popRoute,
              text: "closeButton".tr(),
              btnWidth: context.screenWidth * 0.20,
              textStyle: AppStyle.textButtonStyle.copyWith(color: AppColor.gray),
            ),
            secondChild: CustomTextButtonWidget(
              onPressed: onPrevious ?? () {},
              text: "previousButton".tr(),
              btnWidth: context.screenWidth * 0.20,
              textStyle: AppStyle.textButtonStyle.copyWith(color: AppColor.gray),
            ),
            crossFadeState: isFirstStep ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            duration: kThemeAnimationDuration,
          ),

          // Send button
          AnimatedSwitcher(
            duration: kThemeAnimationDuration,
            child: isLastStep
                ? CustomElevatedButtonWidget(
                    onPressed: onFinish ?? () {},
                    text: isFirstStep ? "sendButton".tr() : "finishButton".tr(),
                    btnWidth: context.screenWidth * 0.60,
                  )
                : CustomElevatedButtonWidget(
                    onPressed: onNext ?? () {},
                    text: "nextButton".tr(),
                    btnWidth: context.screenWidth * 0.60,
                  ),
          ),
        ],
      ),
    );
  }

  EdgeInsetsGeometry get padding => EdgeInsets.fromLTRB(
        UIHelper.mediumPadding,
        UIHelper.smallPadding,
        UIHelper.mediumPadding,
        context.bottomPadding,
      );
  BuildContext get context => NavigationService.navigatorKey.currentContext!;
}
