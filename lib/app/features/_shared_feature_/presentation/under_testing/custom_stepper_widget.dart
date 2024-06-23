import 'package:flutter/material.dart';

import '../../../../core/utils/utils_exports.dart' show AppColor, StepStatus;
import '../../shared_feature_exports.dart' show CustomStepWidget;

class CustomStepperWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final Color backgroundColor;
  final double borderRadius;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final List<CustomStepWidget>? steps;
  final int currentStep;
  final int numberOfSteps;
  const CustomStepperWidget({
    super.key,
    this.width,
    this.height,
    this.backgroundColor = AppColor.white,
    this.borderRadius = 37.0,
    this.margin,
    this.padding,
    this.steps,
    this.currentStep = 1,
    this.numberOfSteps = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height ?? 37.0,
      padding: padding,
      margin: margin,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: LayoutBuilder(
        builder: (_, constraints) {
          final width = constraints.maxWidth;
          return Row(
            children: steps ??
                List.generate(
                  numberOfSteps,
                  (step) => AnimatedCrossFade(
                    firstChild: CustomStepWidget(
                      stepStatus: currentState(step + 1),
                      width: width / numberOfSteps,
                      step: step + 1,
                    ),
                    secondChild: CustomStepWidget(
                      stepStatus: currentState(step + 1),
                      width: width / numberOfSteps,
                      step: step + 1,
                    ),
                    firstCurve: firstCurve,
                    secondCurve: secondCurve,
                    sizeCurve: curve,
                    crossFadeState: step + 1 == currentStep
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    duration: kThemeAnimationDuration,
                  ),
                ),
          );
        },
      ),
    );
  }

  Curve get firstCurve => Interval(0.0, 0.6, curve: curve);
  Curve get secondCurve => Interval(0.4, 1.0, curve: curve);
  Curve get curve => Curves.fastOutSlowIn;
}

extension _StepperWidgetConversion on CustomStepperWidget {
  StepStatus currentState(int stepIndex) {
    if (stepIndex == currentStep) {
      return StepStatus.active;
    } else if (stepIndex > currentStep) {
      return StepStatus.inactive;
    } else {
      return StepStatus.completed;
    }
  }
}

/* 

CustomStepWidget(
                      stepState: currentState(step + 1),
                      width: width / numberOfSteps,
                      step: step + 1,
                    )

 */
