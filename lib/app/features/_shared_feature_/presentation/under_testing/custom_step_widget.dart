import 'package:flutter/material.dart';

import '../../../../core/utils/utils_exports.dart'
    show AppColor, AppStyle, StepStatus;
import '../../shared_feature_exports.dart' show CustomTextWidget;

class CustomStepWidget extends StatelessWidget {
  final double? width;
  final double? height;

  final Color activeBackgroundColor;
  final Color inactiveBackgroundColor;
  final Color completedBackgroundColor;

  final Color activeBorderColor;
  final Color inactiveBorderColor;
  final Color completedBorderColor;
  final double borderWidth;
  final double borderRadius;

  /// It can be widget or int
  final dynamic step;
  final TextStyle? stepStyle;
  final Color activeStepColor;
  final Color inactiveStepColor;
  final Color completedStepColor;
  final StepStatus stepStatus;
  const CustomStepWidget({
    super.key,
    this.width,
    this.height,
    this.activeBackgroundColor = AppColor.white,
    this.inactiveBackgroundColor = Colors.transparent,
    this.completedBackgroundColor = Colors.transparent,
    this.activeBorderColor = AppColor.blue,
    this.inactiveBorderColor = Colors.transparent,
    this.completedBorderColor = AppColor.gray,
    this.borderWidth = 1.0,
    this.borderRadius = 37.0,
    this.step,
    this.stepStyle,
    this.activeStepColor = AppColor.blue,
    this.inactiveStepColor = AppColor.gray,
    this.completedStepColor = AppColor.black,
    required this.stepStatus,
  });

  @override
  Widget build(BuildContext context) {
    return /* Animated */ Container(
      // curve: Curves.fastOutSlowIn,
      // duration: kThemeAnimationDuration,
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: borderColor, width: borderWidth),
      ),
      child: isStepWidget
          ? step
          : CustomTextWidget(
              step?.toString() ?? "1",
              textAlign: TextAlign.center,
              textStyle: stepStyle ??
                  AppStyle.mainTextStyle.copyWith(color: stepColor),
            ),
    );
  }

  bool get isStepWidget => step is Widget;
}

extension _StepWidgetConversion on CustomStepWidget {
  Color get backgroundColor {
    switch (stepStatus) {
      case StepStatus.active:
        return activeBackgroundColor;
      case StepStatus.inactive:
        return inactiveBackgroundColor;
      case StepStatus.completed:
        return completedBackgroundColor;
    }
  }

  Color get borderColor {
    switch (stepStatus) {
      case StepStatus.active:
        return activeBorderColor;
      case StepStatus.inactive:
        return inactiveBorderColor;
      case StepStatus.completed:
        return completedBorderColor;
    }
  }

  Color get stepColor {
    switch (stepStatus) {
      case StepStatus.active:
        return activeStepColor;
      case StepStatus.inactive:
        return inactiveStepColor;
      case StepStatus.completed:
        return completedStepColor;
    }
  }
}
