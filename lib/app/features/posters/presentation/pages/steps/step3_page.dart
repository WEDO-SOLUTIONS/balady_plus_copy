import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/notes_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/undertaking_widget.dart';
import '../../../../commercial_license_cancel/presentation/commercial_license_cancel/widgets/widget_title_invoice.dart';
import '../../../../create_compliance/presentation/widgets/summery_widgets/field_data.dart';
import '../../widgets/previous_next_button.dart';

import '../../../../_shared_feature_/presentation/under_testing/custom_expansion_panel_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../../commercial_license/presentation/step3/widgets/map_widgets/cr_header_desc_widget.dart';
import '../../blocs/posters_license_bloc.dart';

class PostersStep3Page extends StatefulWidget {
  const PostersStep3Page({super.key});

  @override
  State<PostersStep3Page> createState() => _PostersStep3PageState();
}

class _PostersStep3PageState extends State<PostersStep3Page> {
  @override
  void initState() {
    super.initState();

    context
        .read<PostersLicenseBloc>()
        .add(const GetPosterRequestDetailsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostersLicenseBloc, PostersLicenseState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 24, left: 16, right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /*    VdHeaderDesc(
                      header: ("review_request").tr(),
                    ),*/
                    //  Step1SummeryWidget(),
                    //  CustomVerticalSpace(height: 16),
                    //   Step1SummeryWidget(),
                    //  CustomVerticalSpace(height: 16),
                  ],
                ),
              ),
              CalcualtorWidget(),
              if (state.status.isSubmissionLoading)
                const CustomCircularLoadingWidget(),
            ],
          ),
        );
      },
    );
  }
}

class Step1SummeryWidget extends StatelessWidget {
  const Step1SummeryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostersLicenseBloc, PostersLicenseState>(
      builder: (context, state) {
        return CustomExpansionPanelWidget(
          title: ("submission_document").tr(),
          leading: SvgPicture.asset(IconPath.vdSummuryUserInfo),
          children: [
            FieldData(
              title: ("submission_document").tr(),
              subTitle: "",
            ),
            CustomVerticalSpace(height: 8),
            FieldData(
              title: ("license_no").tr(),
              subTitle: state.requestDetails?.billNumber,
            ),
            CustomVerticalSpace(height: 8),
          ],
        );
      },
    );
  }
}

class CalcualtorWidget extends StatefulWidget {
  const CalcualtorWidget({super.key});

  @override
  State<CalcualtorWidget> createState() => _CalcualtorWidgetState();
}

class _CalcualtorWidgetState extends State<CalcualtorWidget> {
  bool showCostsInfo = false;
  bool isAgreement = false;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostersLicenseBloc, PostersLicenseState>(
      builder: (context, state) {
        return Container(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              UndertakingWidget(
                text: "أتعهد على جميع ماتم ذكره اعلاه",
                desc:
                    "اقر واتعهد بصحة كافة البيانات التي تم رفعها على موقع بلدي واتحمل كامل المسؤولية القانونية والنظامية في حال تبين خلاف ذلك. كما اتعهد بابلاغ وزارة الشؤون البلدية والقروية في حال طرء اي تغيير على البيانات واتحمل كامل المسؤولية في حال تبين خلاف ذلك.",
                onChange: (value) {
                  setState(() {
                    isAgreement = value ?? false;
                  });
                },
                initialValue: isAgreement,
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.darkSlateBlue6,
                      offset: Offset(0, -4),
                      blurRadius: 32,
                    )
                  ],
                  color: AppColor.blackModern50Light,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          fit: FlexFit.tight,
                          child: CustomTextWidget(
                            "lbl_total_price".tr(),
                            fontColor: AppColor.blackModern900Light,
                            fontSize: 16,
                            fontWeight: AppFontWeight.bold,
                          ),
                        ),
                        CustomTextButtonWidget(
                          text: showCostsInfo
                              ? "hide_info".tr()
                              : "show_details".tr(),
                          btnTextSize: 14,
                          onPressed: () {
                            setState(() {
                              showCostsInfo = !showCostsInfo;
                            });
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        CustomTextWidget(
                          state.requestDetails?.costCalculationInfo?.totalCost
                                  .toString() ??
                              "",
                          textStyle: AppStyle.boardingTitle
                              .copyWith(color: AppColor.primary900Light),
                        ),
                        const SizedBox(width: 3),
                        CustomTextWidget(
                          "ر.س",
                          textStyle: AppStyle.tagTextStyle,
                        ),
                      ],
                    ),
                    if (showCostsInfo == true) ...[
                      /////////////////////////////////////////////////////////
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: WidgetTitleInvoice(
                          money:
                              '${state.requestDetails?.individualRequests?.length ?? 1}',
                          title: "عدد الرخص",
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: WidgetTitleInvoice(
                          money:
                              '${state.requestDetails?.costCalculationInfo?.postersCount}',
                          title:
                              '${state.requestDetails?.costCalculationInfo?.postersCountDescription}',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: WidgetTitleInvoice(
                          money:
                              '${state.requestDetails?.costCalculationInfo?.postersAreaSum} ${"poster_cm2".tr()}',
                          title:
                              '${state.requestDetails?.costCalculationInfo?.postersAreaSumDescription}',
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: WidgetTitleInvoice(
                          money:
                              '${state.requestDetails?.costCalculationInfo?.durationInDays ?? 0}',
                          title:
                              '${state.requestDetails?.costCalculationInfo?.durationInDaysDescription}',
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Container(
                        height: 98,
                        padding: const EdgeInsets.all(16),
                        decoration: ShapeDecoration(
                          color: Color(0xFFE8EFF1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: CustomTextWidget(
                          'يتم احتساب الرسوم عن طريق حاصل ضرب مجموع مساحات جميع الملصقات في مدة العرض في قيمة اليوم بالريال في عدد الرخص المضاف عليها التصريح ',
                          fontColor: Color(0xFF52525B),
                          fontSize: 12,
                          height: 1.4,
                          fontWeight: AppFontWeight.bold,
                          maxLines: 10,
                        ),
                      ),

                      /* Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: WidgetTitleInvoice(
                              money:
                                  '${state.requestDetails?.costCalculationInfo?.durationInDays} ر.س',
                              title: "عدد الرخص",
                            ),
                          )*/
                    ],
                    /* */
                  ],
                ),
              ),
              PostersPreviousNextButtons(
                isBtnDisabled: !isAgreement,
                onPressed: () {
                  context
                      .read<PostersLicenseBloc>()
                      .add(const SubmitPosterEvent());
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
