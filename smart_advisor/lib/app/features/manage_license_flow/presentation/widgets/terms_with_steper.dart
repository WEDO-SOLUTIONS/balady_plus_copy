import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_advisor/app/core/services/local/navigation_services.dart';
import 'package:smart_advisor/app/core/utils/constants/app_colors.dart';
import 'package:smart_advisor/app/core/utils/constants/app_style.dart';
import 'package:smart_advisor/app/core/utils/constants/paths/icon_paths.dart';
import 'package:smart_advisor/app/core/utils/constants/route_names.dart';
import 'package:smart_advisor/app/features/details/presentation/bloc/details_bloc.dart';
import 'package:smart_advisor/app/features/details/presentation/bloc/details_state.dart';
import 'package:balady_plus/app/features/_shared_feature_/balady_features/services/services.dart';
import 'package:smart_advisor/app/features/fees_calculator/presentation/pages/calculator_page.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsWithSteper extends StatelessWidget {
  final int number;
  final String title;
  final String description;
  final String titleTerms;
  final String renewTitleText;
  final String renewDescriptionText;
  final List<StepData> steps;
  final bool? extraContainer;
  final Function? onPress;

  const TermsWithSteper({
    super.key,
    required this.number,
    required this.title,
    required this.description,
    required this.titleTerms,
    required this.steps,
    required this.renewTitleText,
    required this.renewDescriptionText,
    this.onPress,
    this.extraContainer = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
      decoration: const BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16), topRight: Radius.circular(16)),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: -20,
            top: -35,
            child: Container(
              height: 41,
              width: 41,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColor.backgroundColor,
                borderRadius: const BorderRadius.all(Radius.circular(25)),
              ),
              child: FittedBox(
                child: Container(
                  height: 31,
                  width: 31,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColor.textPrimaryColor,
                    borderRadius: const BorderRadius.all(Radius.circular(25)),
                  ),
                  child: Text(
                    "0$number",
                    textAlign: TextAlign.center,
                    style: AppStyle.footNoteBoldStyle
                        .copyWith(color: AppColor.surfacePrimaryColor),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(
                top: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              title,
                              style: AppStyle.somarSemiBold.copyWith(
                                  color: AppColor.textPrimaryColor,
                                  fontSize: 16),
                            ),
                            SvgPicture.asset(IconPath.webIcon)
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          description,
                          style: AppStyle.textRegularStyle.copyWith(
                              color: AppColor.textSecondaryColor,
                              fontSize: 14,
                              height: 1.7),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          titleTerms,
                          style: AppStyle.footNoteRomanStyle.copyWith(
                              color: AppColor.textPrimaryColor, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  if (steps.isNotEmpty)
                    MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      removeBottom: true,
                      child: Stepper(
                          physics: const NeverScrollableScrollPhysics(),
                          controlsBuilder: (context, details) {
                            return Container();
                          },
                          stepIconBuilder: (stepIndex, stepState) {
                            return SvgPicture.asset(
                              IconPath.stepVerticalIcon,
                              height: 10,
                              width: 10,
                            );
                          },
                          currentStep:
                              steps.isNotEmpty ? (steps.length - 1) : 0,
                          steps: steps
                              .map((e) => Step(
                                    stepStyle: const StepStyle(
                                        connectorColor: Color(0xffCEE3D7),
                                        color: Color(0xffCEE3D7),
                                        connectorThickness: 10),
                                    content: Container(),
                                    title: StepItem(
                                      title: e.title ?? "",
                                      icon: e.icon,
                                      arrow: null,
                                      isCalculator: e.isCalculator ?? false,
                                    ),
                                  ))
                              .toList()),
                    ),
                  extraContainer!
                      ? Container(
                          height: 110,
                          padding: const EdgeInsets.only(
                              top: 14, right: 16, left: 26),
                          margin: const EdgeInsets.only(
                            left: 16,
                            right: 16,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color:
                                    const Color(0xff568F64).withOpacity(0.21)),
                            color: const Color(0xff568F64).withOpacity(0.04),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(renewTitleText,
                                  textAlign: TextAlign.start,
                                  style: AppStyle.textRegularStyle.copyWith(
                                    color: AppColor.textPrimaryColor,
                                    fontSize: 14,
                                    height: 1.6,
                                  )),
                              const SizedBox(
                                height: 12,
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (onPress != null)
                                    onPress!();
                                  else
                                    BaladyServices.navigateToLicense();
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          renewDescriptionText,
                                          style: AppStyle.footNoteRomanStyle
                                              .copyWith(
                                            color: AppColor.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SvgPicture.asset(IconPath.stepArrowIcon)
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StepItem extends StatelessWidget {
  final String title;
  final String icon;
  final String? arrow;
  final bool? isCalculator;

  const StepItem(
      {Key? key,
      required this.title,
      required this.icon,
      this.arrow,
      this.isCalculator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xff568F64).withOpacity(0.21),
        ),
        color: const Color(0xff568F64).withOpacity(0.04),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 28,
            height: 28,
            child: SvgPicture.asset(icon),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: AppStyle.footNoteMediumStyle
                  .copyWith(color: AppColor.textPrimaryColor, fontSize: 14),
            ),
          ),
          if (isCalculator == true)
            GestureDetector(
              onTap: () {
                NavigationService.navigatorKey.currentState!
                    .push(MaterialPageRoute(builder: (ctx) {
                  return FeesCalculatorPage(
                    args: context.read<DetailsBloc>().args,
                  );
                }));
              },
              child: Text(
                "حاسبة الرسوم",
                style: AppStyle.textRegularRomanStyle
                    .copyWith(color: AppColor.statusAccentColor, fontSize: 14),
              ),
            ),
          if (arrow != null)
            Image.asset(
              arrow!,
              height: 16,
              width: 16,
              color: AppColor.textPrimaryColor,
            ),
        ],
      ),
    );
  }
}

class StepData {
  final String title;
  final String icon;
  final String? arrow;
  final bool isCalculator;

  StepData(
      {required this.title,
      required this.icon,
      this.arrow,
      this.isCalculator = false});
}
