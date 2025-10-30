import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../../features/_shared_feature_/presentation/under_testing/custom_expansion_panel_widget.dart';
import '../../../../../../../features/_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../../../../../features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../../../../features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../../../commercial_license_cancel/presentation/commercial_license_cancel/widgets/widget_title_invoice.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/widgets/map_widgets/compliance_header_desc_widget.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/widgets/summery_widgets/field_data.dart';
import '../../blocs/submit_renew_commercial_bloc/renew_commercial_license_bloc.dart';
import '../previous_next_button.dart';

class CommercialRenewStep3 extends StatefulWidget {
  const CommercialRenewStep3({super.key});

  @override
  State<CommercialRenewStep3> createState() => _CommercialRenewStep3State();
}

class _CommercialRenewStep3State extends State<CommercialRenewStep3> {
  @override
  void initState() {
    super.initState();

    context.read<RenewCommercialLicenseBloc>().getRenewRequestDetails();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RenewCommercialLicenseBloc, RenewCommercialLicenseState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.only(top: 24, left: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      VdHeaderDesc(
                        header: ("lbl_total_price").tr(),
                      ),
                      //  Step1SummeryWidget(),
                      //  CustomVerticalSpace(height: 16),
                      //   Step1SummeryWidget(),
                      //  CustomVerticalSpace(height: 16),
                    ],
                  ),
                ),
              ),
            ),
            /// Warning need Fix
            CalcualtorWidget()
          ],
        );
      },
    );
  }
}

class Step1SummeryWidget extends StatelessWidget {
  const Step1SummeryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RenewCommercialLicenseBloc, RenewCommercialLicenseState>(
      builder: (context, state) {
        return CustomExpansionPanelWidget(
          title: ("submission_document").tr(),
          leading: SvgPicture.asset(IconPath.vdSummuryUserInfo),
          children: [
            FieldData(
              title: ("submission_document").tr(),
              subTitle: "",
            ),
            const CustomVerticalSpace(height: 8),
            FieldData(
              title: ("license_no").tr(),
              subTitle: state.renewRequestDetails?.statusName,
            ),
            const CustomVerticalSpace(height: 8),
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RenewCommercialLicenseBloc, RenewCommercialLicenseState>(
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
                          state.renewRequestDetails?.calculatorResponse
                                  ?.totalCost
                                  .toString() ??
                              "",
                          textStyle: AppStyle.boardingTitle
                              .copyWith(color: AppColor.primary900Light),
                        ),
                        const SizedBox(width: 3),
                        CustomTextWidget(
                          "sar_text".tr(),
                          textStyle: AppStyle.tagTextStyle,
                        ),
                      ],
                    ),
                    /////////////////////////////////////////////////////////

                    showCostsInfo
                        ? Column(
                            children: (state.renewRequestDetails
                                        ?.calculatorResponse?.costsInfo ??
                                    [])
                                .map(
                                  (costsInfo) => Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: WidgetTitleInvoice(
                                      money:
                                          '${costsInfo.costItemValue} ${"sar_text".tr()}',
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
              (state.status.isSubmissionLoading)
                  ? const Center(child: CustomCircularLoadingWidget())
                  : CRPreviousNextButtons(
                      isBtnDisabled: false,
                      onPressed: () {
                        context
                            .read<RenewCommercialLicenseBloc>()
                            .submitRenew();
                      },
                    ),
            ],
          ),
        );
      },
    );
  }
}
