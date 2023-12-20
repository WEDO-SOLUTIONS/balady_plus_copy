import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../../core/dependency_injection/injection_container.dart';
import '../../../../../core/utils/utils_exports.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../../commercial_license_cancel/presentation/commercial_license_cancel/widgets/widget_title_invoice.dart';
import '../../../../vd/presentation/widgets/summery_widgets/field_data.dart';
import '../../../commercial_license_exports.dart';
import '../bloc/cr_step13_review_cubit.dart';

class CRStep13Review extends StatelessWidget {
  const CRStep13Review({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CrStep13ReviewDataCubit, CrStep13ReviewState>(
        listener: (context, state) {
      if (state.status == BlocStatus.failure) {
        CommonFunctions.showError(state.errorMessage);
      }
    }, builder: (context, state) {
      return Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /*  const CRHeaderDesc(header: "مراجعه الطلب"),
                        const SizedBox(height: 16),
                        CustomExpansionPanelWidget(
                          title: "بيانات النشاط",
                          leading: SvgPicture.asset(
                            IconPath.clipboard,
                            color: AppColor.primary900Light,
                          ),
                          children: const [
                            FieldData(
                              title: "شاط أيزيك",
                              subTitle: "بيع بالتجزئه",
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        CustomExpansionPanelWidget(
                          title: "بيانات الموقع الجغرافي",
                          leading: SvgPicture.asset(
                            IconPath.qrLocationIcon,
                            width: 20,
                            height: 20,
                            color: AppColor.primary900Light,
                          ),
                          children: const [],
                        ),
                        const SizedBox(height: 14),
                        CustomExpansionPanelWidget(
                          title: "بيانات المحل واللوحات",
                          leading: SvgPicture.asset(IconPath.shopData),
                          children: const [],
                        ),
                        const SizedBox(height: 14),
                        CustomExpansionPanelWidget(
                          title: "بيانات المرفقات",
                          leading: SvgPicture.asset(IconPath.vdSummuryDesc),
                          children: const [],
                        ),
                        const SizedBox(height: 14),
                        CustomExpansionPanelWidget(
                          title: "بيانات المنشأة",
                          leading: SvgPicture.asset(IconPath.building),
                          children: const [],
                        ),
                        const SizedBox(height: 14),
                        CustomExpansionPanelWidget(
                          title: "بيانات تواصل المنشأة",
                          leading: SvgPicture.asset(
                            IconPath.qrCallIcon,
                            width: 20,
                            height: 20,
                            color: AppColor.primary900Light,
                          ),
                          children: const [],
                        ),
                        const SizedBox(height: 14),
                        CustomExpansionPanelWidget(
                          title: "بيانات العاملين",
                          leading: SvgPicture.asset(IconPath.vdSummuryUserInfo),
                          children: const [],
                        ),
                        const SizedBox(height: 14),
                        CustomExpansionPanelWidget(
                          title: "مواعيد العمل",
                          leading: SvgPicture.asset(
                            IconPath.qrClockIcon,
                            width: 20,
                            height: 20,
                            color: AppColor.primary900Light,
                          ),
                          children: const [],
                        ),
                        const SizedBox(height: 14),
                        CustomExpansionPanelWidget(
                          title: "البيانات الاضافية والمرفقات",
                          leading: SvgPicture.asset(IconPath.vdSummuryDesc),
                          children: const [],
                        ),
                        const SizedBox(height: 24),
                        UndertakingWidget(
                          desc:
                              "أقر وأتعهد بصحة كافة البيانات والمرفقات التي تم رفعها على التطبيق وأتحمل كامل المسؤولية القانونية حيال البلاغات الكاذبة والكيدية وفقاً للأنظمة والتعليمات في حال تبين خلاف ذلك",
                          text: "أقر وأتعهد على جميع ماتم ذكره اعلاه",
                          onChange: (value) {},
                          initialValue: false,
                        ),*/
                      ],
                    ),
                  ),
                ),
              ),
              CalcualtorWidget()
            ],
          ),
          if (state.status.isSubmissionLoading)
            const CustomCircularLoadingWidget(),
        ],
      );
    });
  }
}

/*
class Step1SummeryWidget extends StatelessWidget {
  const Step1SummeryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CrStep13ReviewDataCubit, CrStep13ReviewState>(
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
              subTitle: state.renewRequestDetails?.statusName,
            ),
            CustomVerticalSpace(height: 8),
          ],
        );
      },
    );
  }
}
*/
class CalcualtorWidget extends StatefulWidget {
  const CalcualtorWidget({super.key});

  @override
  State<CalcualtorWidget> createState() => _CalcualtorWidgetState();
}

class _CalcualtorWidgetState extends State<CalcualtorWidget> {
  bool showCostsInfo = false;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CrStep13ReviewDataCubit, CrStep13ReviewState>(
      listener: (context, state) {
        if (state.status == BlocStatus.failure) {
          CommonFunctions.showError(state.errorMessage);
        }
      },
      builder: (context, state) {
        return Container(
          color: Colors.transparent,
          child: Column(
            children: [
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
                          sl<CommercialLicenseBloc>()
                                  .state
                                  .crCalculateFeesResponse
                                  ?.totalCost
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
                    /////////////////////////////////////////////////////////

                    showCostsInfo
                        ? Column(
                            children: (sl<CommercialLicenseBloc>()
                                        .state
                                        .crCalculateFeesResponse
                                        ?.costsInfo ??
                                    [])
                                .map(
                                  (costsInfo) => Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: WidgetTitleInvoice(
                                      money: '${costsInfo.costItemValue} ر.س',
                                      title:
                                          costsInfo.costItemDescription ?? "",
                                    ),
                                  ),
                                )
                                .toList(),
                          )
                        : const SizedBox()
                  ],
                ),
              ),
              CRPreviousNextButtons(
                isBtnDisabled: false,
                onPressed: () {
                  context.read<CrStep13ReviewDataCubit>().save();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
