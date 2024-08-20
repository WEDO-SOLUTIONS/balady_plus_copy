import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../../../features/_shared_feature_/presentation/cards/expandable_card.dart';
import '../../../../../../features/_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../../../../features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../../../features/_shared_feature_/presentation/widgets/undertaking_widget.dart';
import '../../../../commercial_license_cancel/presentation/commercial_license_cancel/widgets/widget_title_invoice.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/widgets/summery_widgets/field_data.dart';
import '../../../data/models/permit_request_details_model.dart';
import '../../widgets/license_widgets/license_item_widget.dart';
import '../../widgets/previous_next_button.dart';
import 'package:collection/collection.dart';

import '../../../../../../features/_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../../../../features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../../commercial_license/presentation/step3/widgets/map_widgets/cr_header_desc_widget.dart';
import '../../blocs/permit_tobacco_bloc.dart';

class PermitStep2Page extends StatefulWidget {
  const PermitStep2Page({super.key});

  @override
  State<PermitStep2Page> createState() => _PermitStep2PageState();
}

class _PermitStep2PageState extends State<PermitStep2Page> {
  @override
  void initState() {
    super.initState();
    context.read<PermitTobaccoLicenseBloc>().add(CalculatePermitCostEvent());
  }

  bool isAgreement = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PermitTobaccoLicenseBloc, PermitTobaccoLicenseState>(
      builder: (context, state) {
        return Stack(
          children: [
            Container(
              margin: EdgeInsets.only(top: 24, left: 16, right: 16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    VdHeaderDesc(
                      header: ("review_request").tr(),
                    ),
                    //const Step1SummeryWidget(),
                    const CustomVerticalSpace(height: 16),
                    const Step2SummeryWidget(),
                    const CustomVerticalSpace(height: 16),
                    UndertakingWidget(
                      text: "posters_agreement_title".tr(),
                      desc: "posters_agreement_desc".tr(),
                      onChange: (value) {
                        context
                            .read<PermitTobaccoLicenseBloc>()
                            .add(ToggleAgreementEvent(agreement: value));
                      },
                      initialValue: state.agreement ?? false,
                    ),
                    const CustomVerticalSpace(height: 250),
                  ],
                ),
              ),
            ),
            const Align(
                alignment: Alignment.bottomCenter, child: CalcualtorWidget()),
            if (state.status.isSubmissionLoading)
              const CustomCircularLoadingWidget(),
          ],
        );
      },
    );
  }
}

class Step2SummeryWidget extends StatelessWidget {
  const Step2SummeryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PermitTobaccoLicenseBloc, PermitTobaccoLicenseState>(
      builder: (context, state) {
        return ExpandableCard(
          title: ("userLicensesGoToLicenseDetailsWord").tr(),
          icon: IconPath.vdSummuryDesc,
          children: [
            const CustomVerticalSpace(
              height: 16,
            ),
            if (state.commercialLicenceDetails != null) ...[
              FieldData(
                title: "license_no".tr(),
                subTitle: state.commercialLicenceDetails?.licenseInfo?.licenseId
                        .toString() ??
                    "",
              ),
              const CustomVerticalSpace(
                height: 16,
              ),
              FieldData(
                title: "license_status".tr(),
                subTitle: state
                        .commercialLicenceDetails?.licenseInfo?.statusDesc
                        .toString() ??
                    "",
              ),
              const CustomVerticalSpace(
                height: 16,
              ),
              FieldData(
                title: "license_end_date".tr(),
                subTitle: state
                        .commercialLicenceDetails?.licenseInfo?.licenseEndDate
                        .toString() ??
                    "",
              ),
              const CustomVerticalSpace(
                height: 16,
              ),
              FieldData(
                title: "municipality".tr(),
                subTitle: state.commercialLicenceDetails?.locationInfo
                        ?.municipalityName
                        .toString() ??
                    "",
              ),
              const CustomVerticalSpace(
                height: 16,
              ),
              FieldData(
                title: "sub_municipality".tr(),
                subTitle: state.commercialLicenceDetails?.locationInfo
                        ?.subMunicipalityName
                        .toString() ??
                    "",
              ),
              /*const CustomVerticalSpace(
              height: 16,
            ),
            FieldData(
              title: "license_health_end_date".tr(),
              subTitle: state
                      .commercialLicenceDetails?.licenseInfo?.licenseEndDate
                      .toString() ??
                  "",
            ),*/
              const CustomVerticalSpace(
                height: 16,
              ),
              FieldData(
                  title: "permit_need_baladiyah".tr(),
                  subTitle:
                      state.doesNotNeedsCredentials() ? "no".tr() : "yes".tr()),
              const CustomVerticalSpace(
                height: 16,
              ),
              FieldData(
                  title: "permit_needs_fees".tr(),
                  subTitle: state.needsFees() == true ? "yes".tr() : "no".tr()),
            ],
            FieldData(
                title: "licence_inside_hotel".tr(),
                subTitle: state.isInsideHotel == true ? "yes".tr() : "no".tr()),
            const CustomVerticalSpace(
              height: 16,
            ),
            if (state.isInsideHotel == true) ...[
              FieldData(
                  title: "hotel_license_number".tr(),
                  subTitle: state.hotelLicenseNumber),
              const CustomVerticalSpace(
                height: 16,
              ),
              FieldData(
                  title: "hotel_name".tr(),
                  subTitle: state
                      .permitTobaccoValidateHotelLicenseResponse?.hotelName),
              const CustomVerticalSpace(
                height: 16,
              ),
              FieldData(
                  title: "hotel_class".tr(),
                  subTitle: state.permitTobaccoValidateHotelLicenseResponse
                      ?.hotelClass?.name),
            ],
            const CustomVerticalSpace(
              height: 16,
            )
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
    return BlocBuilder<PermitTobaccoLicenseBloc, PermitTobaccoLicenseState>(
      builder: (context, state) {
        return Container(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
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
                          state.calculateCost24PermitResponse?.totalCost
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
                    if (showCostsInfo == true) ...[
                      /////////////////////////////////////////////////////////
                      Column(
                        children: (state
                                    .calculateCost24PermitResponse?.costsInfo ??
                                [])
                            .map(
                              (costsInfo) => Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: WidgetTitleInvoice(
                                  money:
                                      '${costsInfo.costItemValue} ${"sar_text".tr()}',
                                  title: costsInfo.costItemDescription ?? "",
                                ),
                              ),
                            )
                            .toList(),
                      ),

                      const SizedBox(
                        height: 16,
                      ),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: ShapeDecoration(
                          color: AppColor.primary100Light,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: CustomTextWidget(
                          state.ALERT() ?? "",
                          fontColor: Color(0xFF52525B),
                          fontSize: 12,
                          height: 1.4,
                          fontWeight: AppFontWeight.bold,
                          maxLines: 10,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Container(
                color: AppColor.white,
                child: PostersPreviousNextButtons(
                  isBtnDisabled: !(state.agreement ?? false),
                  onPressed: () {
                    context
                        .read<PermitTobaccoLicenseBloc>()
                        .add(const SubmitPermitEvent());
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
