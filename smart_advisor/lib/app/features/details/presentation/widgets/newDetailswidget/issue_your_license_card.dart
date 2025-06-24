import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_advisor/app/core/utils/constants/app_colors.dart';
import 'package:smart_advisor/app/core/utils/constants/app_style.dart';
import 'package:smart_advisor/app/core/utils/constants/paths/icon_paths.dart';
import 'package:smart_advisor/app/core/utils/constants/route_names.dart';
import 'package:smart_advisor/app/features/details/presentation/bloc/details_bloc.dart';
import 'package:smart_advisor/app/features/details/presentation/bloc/details_state.dart';
import 'package:balady_plus/app/features/_shared_feature_/balady_features/services/services.dart';

import 'package:smart_advisor/app/features/select_activity/presentation/blocs/main_flow_bloc/main_flow_bloc.dart';
import 'package:smart_advisor/app/features/select_activity/presentation/pages/more_info.dart';

import '../../../../../core/services/local/navigation_services.dart';
import '../../../../fees_calculator/presentation/pages/calculator_page.dart';
import '../../../../select_activity/domain/entities/activity_details_page_params.dart';
//import 'package:easy_stepper/easy_stepper.dart';

class IssueYourLicenseCard extends StatelessWidget {
  final int number;
  ActivityDetailsPageParams? args;
  IssueYourLicenseCard({super.key, required this.number, this.args});

  final List<Map<String, String?>> steps = [
    {
      'title': 'تقديم الطلب',
      'icon':
          'packages/smart_advisor/smart_advisor_assets/icons/svg/request.svg',
      'arrow': null
    },
    {
      'title': 'إعتماد الطلب',
      'icon':
          'packages/smart_advisor/smart_advisor_assets/icons/svg/approval.svg',
      'arrow': null
    },
    {
      'title': 'بوابة الموافقات الحكومية الالكترونية',
      'icon':
          'packages/smart_advisor/smart_advisor_assets/icons/svg/gov_portal.svg',
      'arrow':
          'packages/smart_advisor/smart_advisor_assets/icons/svg/arrow_left.svg'
    },
    {
      'title': 'منصة سلامة - الدفاع المدني للأنشطة الغير الفورية',
      'icon':
          'packages/smart_advisor/smart_advisor_assets/icons/svg/civil_defense.svg',
      'arrow':
          'packages/smart_advisor/smart_advisor_assets/icons/svg/arrow_left.svg'
    },
    {
      'title': 'إصدار الفاتورة',
      'icon':
          'packages/smart_advisor/smart_advisor_assets/icons/svg/invoice.svg',
      'arrow': null
    },
    {
      'title': 'دفع رسوم الخدمة',
      'icon':
          'packages/smart_advisor/smart_advisor_assets/icons/svg/payment.svg',
      'arrow': null
    },
    {
      'title': 'طباعة الرخصة',
      'icon': 'packages/smart_advisor/smart_advisor_assets/icons/svg/print.svg',
      'arrow': null
    },
    {
      'title': 'الرقابة اللاحقة',
      'icon':
          'packages/smart_advisor/smart_advisor_assets/icons/svg/monitoricon.svg',
      'arrow': null
    },
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailsBloc, DetailsState>(
      builder: (context, state) {
        return context.read<DetailsBloc>().args.workFlow != null
            ? Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.all(Radius.circular(16)),
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
                          borderRadius:
                              const BorderRadius.all(Radius.circular(25)),
                        ),
                        child: FittedBox(
                          child: Container(
                            height: 31,
                            width: 31,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColor.textPrimaryColor,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(25)),
                            ),
                            child: Text(
                              "0" + number.toString(),
                              textAlign: TextAlign.center,
                              style: AppStyle.footNoteBoldStyle.copyWith(
                                  color: AppColor.surfacePrimaryColor),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 24, bottom: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "إصدار رخصتك التجارية",
                                        style: AppStyle.somarSemiBold.copyWith(
                                            color: AppColor.textPrimaryColor,
                                            fontSize: 16),
                                      ),
                                      SvgPicture.asset(IconPath.doubleCard)
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "الآن يمكنك البدء في التقديم على الرخصة التجارية الخاصة بك! يمكنك التقديم من خلال التطبيق أو بوابة بلدي.",
                                    style: AppStyle.textRegularStyle.copyWith(
                                        color: AppColor.textSecondaryColor,
                                        fontSize: 14,
                                        height: 1.7),
                                  ),
                                  Text(
                                    "يتضمن إصدار الرخصة عدة بيانات يجب عليك تعبئتها، قد لايكون لديك بعض البيانات المطلوبة لكن ستتمكن من حفظ طلبك كمسودة وإكماله لاحقاً.",
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
                                    "تمر خطوة إصدار الرخصة بعدة مراحل:",
                                    style: AppStyle.footNoteRomanStyle.copyWith(
                                        color: AppColor.textPrimaryColor,
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                            if (context
                                    .read<DetailsBloc>()
                                    .args
                                    .workFlow
                                    ?.length !=
                                0)
                              MediaQuery.removePadding(
                                context: context,
                                removeTop: true,
                                removeBottom: true,
                                child: Stepper(
                                  margin: EdgeInsets.zero,
                                  physics: NeverScrollableScrollPhysics(),
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
                                  currentStep: context
                                              .read<DetailsBloc>()
                                              .args
                                              .workFlow
                                              ?.length !=
                                          null
                                      ? (context
                                                  .read<DetailsBloc>()
                                                  .args
                                                  .workFlow
                                                  ?.length ??
                                              0) -
                                          1
                                      : 0,
                                  steps: context
                                          .read<DetailsBloc>()
                                          .args
                                          .workFlow
                                          ?.map((e) => Step(
                                                stepStyle: StepStyle(
                                                    connectorColor:
                                                        Color(0xffCEE3D7),
                                                    color: Color(0xffCEE3D7),
                                                    connectorThickness: 10),
                                                content: Container(),
                                                title: StepItem(
                                                  title: e.stepName ?? "",
                                                  icon: e.getIcon(),
                                                  arrow: null,
                                                  isCalculator: e.stepId ==
                                                      "commercial-issuing-license",
                                                ),
                                              ))
                                          .toList() ??
                                      [],
                                ),
                              ),
                            Container(
                              height: 110,
                              padding: const EdgeInsets.only(
                                  top: 14, right: 16, left: 26),
                              margin: EdgeInsets.only(left: 16, right: 16),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: const Color(0xff568F64)
                                        .withOpacity(0.21)),
                                color:
                                    const Color(0xff568F64).withOpacity(0.04),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      "حققت أول خطوتين؟  ابدأ باصدار رخصتك التجارية الآن",
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
                                      if (BaladyServices.isLoggedIn()) {
                                        args?.mainFlowBloc
                                            ?.add(GetDelegatorsEvent());
                                        NavigationService
                                            .navigatorKey.currentState!
                                            .push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                BlocProvider.value(
                                              value: args!.mainFlowBloc!,
                                              child: MoreInfoPage(),
                                            ),
                                          ),
                                        );
                                      } else {
                                        BaladyServices.openIssueLicense();
                                      }
                                      return;
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "الذهاب الى الخدمة",
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
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Container();
      },
    );
  }
}

class StepItem extends StatelessWidget {
  final String title;
  final String icon;
  final String? arrow;
  final bool? isCalculator;

  StepItem(
      {Key? key,
      required this.title,
      required this.icon,
      this.arrow,
      this.isCalculator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xff568F64).withOpacity(0.21),
        ),
        color: const Color(0xff568F64).withOpacity(0.04),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Row(
        children: [
          Image.asset(
            icon,
            height: 28,
            width: 28,
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
