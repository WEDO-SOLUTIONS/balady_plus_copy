import 'package:balady_plus/app/features/create_compliance/presentation/widgets/summery_widgets/field_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import '../../../../../../features/_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../../../../features/_shared_feature_/shared_feature_exports.dart';
import '../../../../commercial_license_cancel/presentation/commercial_license_cancel/widgets/widget_title_invoice.dart';
import '../../../commercial_license_exports.dart';
import '../bloc/cr_step13_review_cubit.dart';
import 'attachment_show_widget.dart';

class CRStep13Review extends StatefulWidget {
  const CRStep13Review({Key? key}) : super(key: key);

  @override
  State<CRStep13Review> createState() => _CRStep13ReviewState();
}

class _CRStep13ReviewState extends State<CRStep13Review> {
  @override
  void initState() {
    super.initState();

    context.read<CrStep13ReviewDataCubit>().getConclusion();
  }

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
                        CRHeaderDesc(
                            header: "issue_commercial_conclusion_request_draft"
                                .tr()),
                        const SizedBox(height: 16),
                        CustomExpansionPanelWidget(
                          title: "issue_commercial_conclusion_owner_data".tr(),
                          leading: SvgPicture.asset(
                            IconPath.clipboard,
                            color: AppColor.primary900Light,
                          ),
                          children: [
                            FieldData(
                                title:
                                    "issue_commercial_conclusion_owner_data_name"
                                        .tr(),
                                subTitle: state.conclusion?.owner?.name),
                            FieldData(
                                title:
                                    "issue_commercial_conclusion_owner_data_cr"
                                        .tr(),
                                subTitle: state.conclusion?.owner?.crNumber),
                          ],
                        ),
                        const SizedBox(height: 14),
                        CustomExpansionPanelWidget(
                          title:
                              "issue_commercial_conclusion_applicant_data".tr(),
                          leading: SvgPicture.asset(
                            IconPath.qrLocationIcon,
                            width: 20,
                            height: 20,
                            color: AppColor.primary900Light,
                          ),
                          children: [
                            FieldData(
                                title:
                                    "issue_commercial_conclusion_applicant_data_name"
                                        .tr(),
                                subTitle: state.conclusion?.submitter?.name),
                            FieldData(
                                title:
                                    "issue_commercial_conclusion_applicant_data_id"
                                        .tr(),
                                subTitle: state
                                    .conclusion?.submitter?.identityNumber),
                            FieldData(
                                title:
                                    "issue_commercial_conclusion_applicant_data_type"
                                        .tr(),
                                subTitle: state
                                    .conclusion?.submitter?.submitterType
                                    ?.tr()),
                          ],
                        ),
                        const SizedBox(height: 14),
                        CustomExpansionPanelWidget(
                          title:
                              "issue_commercial_conclusion_activity_data".tr(),
                          leading: SvgPicture.asset(IconPath.shopData),
                          children: [
                            FieldData(
                                title:
                                    "issue_commercial_conclusion_activity_data_isic"
                                        .tr(),
                                subTitle: state.conclusion?.mainActivity
                                    ?.isicActivity?.name),
                            FieldData(
                                title:
                                    "issue_commercial_conclusion_activity_data_detailed"
                                        .tr(),
                                subTitle: state.conclusion?.mainActivity
                                    ?.detailedActivity?.name),
                            FieldData(
                                title:
                                    "issue_commercial_conclusion_activity_data_area"
                                        .tr(),
                                subTitle: state.conclusion?.shopInfo?.area
                                    .toString()),
                            FieldData(
                                title:
                                    "issue_commercial_conclusion_activity_data_main_area"
                                        .tr(),
                                subTitle: state.conclusion?.mainActivity?.area
                                    .toString()),
                            FieldData(
                                title:
                                    "issue_commercial_conclusion_activity_data_marsom"
                                        .tr(),
                                subTitle: state.conclusion?.mainActivity
                                    ?.mainActivity?.name
                                    .toString()),
                            FieldData(
                                title:
                                    "issue_commercial_conclusion_activity_facility"
                                        .tr(),
                                subTitle: state
                                    .conclusion?.mainActivity?.facility?.name
                                    .toString()),
                            FieldData(
                                title:
                                    "issue_commercial_conclusion_activity_worker"
                                        .tr(),
                                subTitle: state
                                    .conclusion?.mainActivity?.workerType?.name
                                    .toString()),
                            if (state.conclusion?.mainActivity
                                    ?.accommodationType !=
                                null)
                              FieldData(
                                  title:
                                      "issue_commercial_conclusion_activity_accomadate_type"
                                          .tr(),
                                  subTitle: state.conclusion?.mainActivity
                                      ?.accommodationType?.name
                                      .toString()),
                            if (state.conclusion?.mainActivity?.unitCount !=
                                null)
                              FieldData(
                                  title:
                                      "issue_commercial_conclusion_activity_accomadate_unit"
                                          .tr(),
                                  subTitle: state
                                      .conclusion?.mainActivity?.unitCount
                                      .toString()),
                          ],
                        ),
                        const SizedBox(height: 14),
                        CustomExpansionPanelWidget(
                          title: "issue_commercial_conclusion_license_location"
                              .tr(),
                          leading: SvgPicture.asset(IconPath.vdSummuryDesc),
                          children: [
                            FieldData(
                                title:
                                    "issue_commercial_conclusion_license_municipality"
                                        .tr(),
                                subTitle: state.conclusion?.location
                                        ?.municipality?.name ??
                                    ""),
                            FieldData(
                                title:
                                    "issue_commercial_conclusion_license_city"
                                        .tr(),
                                subTitle:
                                    state.conclusion?.location?.city?.name ??
                                        ""),
                            FieldData(
                                title:
                                    "issue_commercial_conclusion_license_sub_municipality"
                                        .tr(),
                                subTitle: state.conclusion?.location
                                        ?.subMunicipality?.name ??
                                    ""),
                            FieldData(
                                title:
                                    "issue_commercial_conclusion_license_district"
                                        .tr(),
                                subTitle: state
                                        .conclusion?.location?.district?.name ??
                                    ""),
                            FieldData(
                                title:
                                    "issue_commercial_conclusion_license_street"
                                        .tr(),
                                subTitle:
                                    state.conclusion?.location?.street?.name ??
                                        ""),
                            FieldData(
                                title:
                                    "issue_commercial_conclusion_license_map_no"
                                        .tr(),
                                subTitle:
                                    state.conclusion?.location?.mapNo ?? ""),
                            FieldData(
                                title:
                                    "issue_commercial_conclusion_license_plane_no"
                                        .tr(),
                                subTitle:
                                    state.conclusion?.location?.landNo ?? ""),
                            FieldData(
                                title: "issue_commercial_conclusion_license_x"
                                    .tr(),
                                subTitle: state.conclusion?.location?.x ?? ""),
                            FieldData(
                                title: "issue_commercial_conclusion_license_y"
                                    .tr(),
                                subTitle: state.conclusion?.location?.y ?? ""),
                          ],
                        ),
                        const SizedBox(height: 14),
                        CustomExpansionPanelWidget(
                          title: "issue_commercial_shop_info".tr(),
                          leading: SvgPicture.asset(IconPath.building),
                          children: [
                            FieldData(
                                title: "issue_commercial_shop_info_name".tr(),
                                subTitle:
                                    state.conclusion?.shopInfo?.shopName ?? ""),
                            FieldData(
                                title: "issue_commercial_shop_info_no".tr(),
                                subTitle: state.conclusion?.shopInfo?.shopNumber
                                        ?.toString() ??
                                    ""),
                            FieldData(
                                title: "issue_commercial_shop_block".tr(),
                                subTitle: state
                                        .conclusion?.shopInfo?.buildingNumber
                                        ?.toString() ??
                                    ""),
                            FieldData(
                                title: "issue_commercial_shop_holes".tr(),
                                subTitle: state.conclusion?.shopInfo?.holesCount
                                        ?.toString() ??
                                    ""),
                            FieldData(
                                title: "issue_commercial_shop_floors".tr(),
                                subTitle: state.conclusion?.shopInfo?.floorCount
                                        ?.toString() ??
                                    ""),
                            FieldData(
                                title: "issue_commercial_shop_cameras_no".tr(),
                                subTitle: state
                                        .conclusion?.shopInfo?.camerasNumber
                                        ?.toString() ??
                                    ""),
                            FieldData(
                                title:
                                    "issue_commercial_shop_has_elevator".tr(),
                                subTitle:
                                    state.conclusion?.shopInfo?.hasElevator ==
                                            true
                                        ? "yes".tr()
                                        : "no".tr()),
                            FieldData(
                                title:
                                    "issue_commercial_shop_inside_petrol".tr(),
                                subTitle: state.conclusion?.shopInfo
                                            ?.insidePetrolStation ==
                                        true
                                    ? "yes".tr()
                                    : "no".tr()),
                            FieldData(
                                title: "issue_commercial_shop_inside_mall".tr(),
                                subTitle:
                                    state.conclusion?.shopInfo?.insideMall ==
                                            true
                                        ? "yes".tr()
                                        : "no".tr()),
                            if (state.conclusion?.shopInfo?.insideMall == true)
                              FieldData(
                                  title: "issue_commercial_shop_mall_name".tr(),
                                  subTitle:
                                      state.conclusion?.shopInfo?.mall?.name),
                            if (state.conclusion?.shopInfo?.insideMall == true)
                              FieldData(
                                  title:
                                      "issue_commercial_shop_mall_floor".tr(),
                                  subTitle: state
                                      .conclusion?.shopInfo?.floorCount
                                      .toString()),
                          ],
                        ),
                        const SizedBox(height: 14),
                        CustomExpansionPanelWidget(
                          title:
                              "issue_commercial_conclusion_addetinlal_activity"
                                  .tr(),
                          leading: SvgPicture.asset(
                            IconPath.qrCallIcon,
                            width: 20,
                            height: 20,
                            color: AppColor.primary900Light,
                          ),
                          children: (state.conclusion?.addedActivities ?? [])
                                  .map((e) {
                                return Column(
                                  children: [
                                    FieldData(
                                        title:
                                            "issue_commercial_conclusion_addetinlal_activity_name"
                                                .tr(),
                                        subTitle: e.isicActivity?.name),
                                    FieldData(
                                        title:
                                            "issue_commercial_conclusion_addetinlal_activity_code"
                                                .tr(),
                                        subTitle: e.isicActivity?.id),
                                    FieldData(
                                        title:
                                            "issue_commercial_conclusion_addetinlal_activity_detailed_name"
                                                .tr(),
                                        subTitle: e.detailedActivity?.name),
                                    FieldData(
                                        title:
                                            "issue_commercial_conclusion_addetinlal_activity_detailed_code"
                                                .tr(),
                                        subTitle: e.detailedActivity?.id),
                                    FieldData(
                                        title:
                                            "issue_commercial_conclusion_addetinlal_activity_area"
                                                .tr(),
                                        subTitle: e.area.toString()),
                                  ],
                                );
                              }).toList() ??
                              [],
                        ),
                        const SizedBox(height: 14),
                        CustomExpansionPanelWidget(
                            title: "issue_commercial_clean_data".tr(),
                            leading: SvgPicture.asset(
                              IconPath.qrCallIcon,
                              width: 20,
                              height: 20,
                              color: AppColor.primary900Light,
                            ),
                            children: [
                              FieldData(
                                  title: "",
                                  subTitle: state.conclusion?.cleaningInfo
                                          ?.cleanOptionDesc ??
                                      ""),
                              if (state
                                      .conclusion?.cleaningInfo?.contractNumber !=
                                  null)
                                FieldData(
                                    title:
                                        "issue_commercial_location_type_clean_no"
                                            .tr(),
                                    subTitle: state.conclusion?.cleaningInfo
                                            ?.contractNumber
                                            .toString() ??
                                        ""),
                              if (state.conclusion?.cleaningInfo
                                      ?.cleanContractEndDate !=
                                  null)
                                FieldData(
                                    title:
                                        "issue_commercial_location_type_clean_date"
                                            .tr(),
                                    subTitle: state.conclusion?.cleaningInfo
                                            ?.cleanContractEndDate
                                            .toString() ??
                                        ""),
                            ]),
                        const SizedBox(height: 14),
                        CustomExpansionPanelWidget(
                          title: "issue_commercial_board_data".tr(),
                          leading: SvgPicture.asset(
                            IconPath.qrCallIcon,
                            width: 20,
                            height: 20,
                            color: AppColor.primary900Light,
                          ),
                          children: (state.conclusion?.shopInfo?.boardsInfo ??
                                      [])
                                  .map((e) {
                                return Column(
                                  children: [
                                    FieldData(
                                        title:
                                            "issue_commercial_board_type".tr(),
                                        subTitle: e.type?.name.toString()),
                                    FieldData(
                                        title:
                                            "issue_commercial_board_area".tr(),
                                        subTitle: e.area.toString()),
                                  ],
                                );
                              }).toList() ??
                              [],
                        ),
                        const SizedBox(height: 14),
                        CustomExpansionPanelWidget(
                            title: "issue_commercial_location".tr(),
                            leading: SvgPicture.asset(
                              IconPath.qrCallIcon,
                              width: 20,
                              height: 20,
                              color: AppColor.primary900Light,
                            ),
                            children: [
                              FieldData(
                                  title: "issue_commercial_location_type".tr(),
                                  subTitle: state.conclusion?.contractInfo
                                          ?.contractType?.name ??
                                      ""),
                              if (state.conclusion?.contractInfo?.deedInfo !=
                                  null) ...[
                                FieldData(
                                    title:
                                        "issue_commercial_location_type_deed_name"
                                            .tr(),
                                    subTitle: state.conclusion?.contractInfo
                                            ?.deedInfo?.deedNumber ??
                                        ""),
                                if (state.conclusion?.contractInfo?.deedInfo
                                            ?.deedDate !=
                                        null &&
                                    state.conclusion?.contractInfo?.contractType
                                            ?.id !=
                                        "DEED_SERVICE")
                                  FieldData(
                                      title:
                                          "issue_commercial_location_type_deed_number"
                                              .tr(),
                                      subTitle: state.conclusion?.contractInfo
                                              ?.deedInfo?.deedDate ??
                                          "")
                              ],
                              if (state.conclusion?.contractInfo
                                      ?.investmentContractInfo !=
                                  null) ...[
                                if (state
                                        .conclusion
                                        ?.contractInfo
                                        ?.investmentContractInfo
                                        ?.investmentContractNumber !=
                                    null)
                                  FieldData(
                                      title:
                                          "issue_commercial_location_type_investment_number"
                                              .tr(),
                                      subTitle: state
                                              .conclusion
                                              ?.contractInfo
                                              ?.investmentContractInfo
                                              ?.investmentContractNumber ??
                                          ""),
                                if (state
                                        .conclusion
                                        ?.contractInfo
                                        ?.investmentContractInfo
                                        ?.investContractName !=
                                    null)
                                  FieldData(
                                      title:
                                          "issue_commercial_location_type_investment_name"
                                              .tr(),
                                      subTitle: state
                                              .conclusion
                                              ?.contractInfo
                                              ?.investmentContractInfo
                                              ?.investContractName ??
                                          ""),
                                if (state.conclusion?.contractInfo
                                        ?.investmentContractInfo?.type?.name !=
                                    null)
                                  FieldData(
                                      title:
                                          "issue_commercial_location_type_investment_type"
                                              .tr(),
                                      subTitle: state
                                              .conclusion
                                              ?.contractInfo
                                              ?.investmentContractInfo
                                              ?.type
                                              ?.name ??
                                          "")
                              ],
                              if (state.conclusion?.contractInfo
                                      ?.tenancyContractInfo !=
                                  null) ...[
                                if (state
                                        .conclusion
                                        ?.contractInfo
                                        ?.tenancyContractInfo
                                        ?.tenancyContractNumber !=
                                    null)
                                  FieldData(
                                      title:
                                          "issue_commercial_location_type_tenancy_no"
                                              .tr(),
                                      subTitle: state
                                              .conclusion
                                              ?.contractInfo
                                              ?.tenancyContractInfo
                                              ?.tenancyContractNumber ??
                                          ""),
                                if (state.conclusion?.contractInfo
                                        ?.tenancyContractInfo?.versionNumber !=
                                    null)
                                  FieldData(
                                      title:
                                          "issue_commercial_location_type_tenancy_ve"
                                              .tr(),
                                      subTitle: state
                                              .conclusion
                                              ?.contractInfo
                                              ?.tenancyContractInfo
                                              ?.versionNumber ??
                                          ""),
                                if (state.conclusion?.contractInfo
                                        ?.tenancyContractInfo?.nationalId !=
                                    null)
                                  FieldData(
                                      title:
                                          "issue_commercial_location_type_tenancy_rep"
                                              .tr(),
                                      subTitle: state
                                              .conclusion
                                              ?.contractInfo
                                              ?.tenancyContractInfo
                                              ?.nationalId ??
                                          ""),
                                if (state
                                        .conclusion
                                        ?.contractInfo
                                        ?.tenancyContractInfo
                                        ?.contractEndDate !=
                                    null)
                                  if (state.conclusion?.contractInfo
                                          ?.contractType?.id !=
                                      "EJAR_SERVICE")
                                    FieldData(
                                        title:
                                            "issue_commercial_location_type_tenancy_date"
                                                .tr(),
                                        subTitle: state
                                                .conclusion
                                                ?.contractInfo
                                                ?.tenancyContractInfo
                                                ?.contractEndDate ??
                                            "")
                              ],
                            ]),
                        const SizedBox(height: 14),
                        CustomExpansionPanelWidget(
                          title: "issue_commercial_civil".tr(),
                          leading: SvgPicture.asset(IconPath.vdSummuryUserInfo),
                          children: [
                            if (state.conclusion?.salamaInfo?.documentDesc !=
                                    null &&
                                state.conclusion?.salamaInfo?.workFlow ==
                                    "NORMAL") ...[
                              FieldData(
                                  title: "fire_approval_type".tr(),
                                  subTitle: state.conclusion?.salamaInfo
                                          ?.documentName ??
                                      ""),
                              SizedBox(
                                height: 16,
                              ),
                              FieldData(
                                  title: "",
                                  subTitle: state.conclusion?.salamaInfo
                                          ?.documentDesc ??
                                      ""),
                            ],
                            if (state
                                    .conclusion?.salamaInfo?.salamaBillNumber !=
                                null)
                              FieldData(
                                  title: "issue_commercial_civil_bill".tr(),
                                  subTitle: state
                                      .conclusion?.salamaInfo?.salamaBillNumber
                                      ?.toString()),
                            if (state.conclusion?.salamaInfo
                                    ?.salamaPermitNumber !=
                                null)
                              FieldData(
                                  title: "issue_commercial_civil_permit".tr(),
                                  subTitle: state.conclusion?.salamaInfo
                                      ?.salamaPermitNumber
                                      ?.toString()),
                            if (state.conclusion?.salamaInfo
                                    ?.salamaReportNumber !=
                                null)
                              FieldData(
                                  title: "issue_commercial_civil_report".tr(),
                                  subTitle: state.conclusion?.salamaInfo
                                      ?.salamaReportNumber),
                          ],
                        ),
                        const SizedBox(height: 14),
                        CustomExpansionPanelWidget(
                          title: "issue_commercial_approvals".tr(),
                          leading: SvgPicture.asset(
                            IconPath.qrClockIcon,
                            width: 20,
                            height: 20,
                            color: AppColor.primary900Light,
                          ),
                          children: [
                            if (state.conclusion?.governmentalApprovals
                                    ?.agencies?.isNotEmpty ??
                                false)
                              FieldData(
                                  title: state.conclusion?.governmentalApprovals
                                          ?.description ??
                                      "",
                                  subTitle: state.conclusion
                                      ?.governmentalApprovals?.agencies
                                      ?.join(" , ")),
                          ],
                        ),
                        const SizedBox(height: 14),
                        CustomExpansionPanelWidget(
                          title: "issue_commercial_general_security".tr(),
                          leading: SvgPicture.asset(IconPath.vdSummuryDesc),
                          children: [
                            FieldData(
                                title: state
                                        .conclusion?.sendToGeneralSecurityText
                                        ?.toString() ??
                                    "",
                                subTitle: ""),
                          ],
                        ),
                        const SizedBox(height: 24),
                        CustomExpansionPanelWidget(
                          title: "issue_commercial_attachment".tr(),
                          leading: SvgPicture.asset(IconPath.vdSummuryDesc),
                          children: [
                            ListView.builder(
                              itemCount:
                                  state.conclusion?.attachments?.length ?? 0,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (ctx, index) {
                                return state.conclusion?.attachments?[index]
                                            .attachUrl !=
                                        null
                                    ? AttachmentShowWidget(
                                        fileName: state.conclusion
                                                ?.attachments?[index].name ??
                                            '',
                                        name: state
                                                .conclusion
                                                ?.attachments?[index]
                                                .attachDescription ??
                                            '',
                                        filePath: state
                                                .conclusion
                                                ?.attachments?[index]
                                                .attachUrl ??
                                            "",
                                      )
                                    : const SizedBox();
                              },
                            )
                          ],
                        ),
                        const SizedBox(height: 24),
                        CustomExpansionPanelWidget(
                          title: "issue_commercial_request_flow".tr(),
                          leading: SvgPicture.asset(IconPath.vdSummuryDesc),
                          children:
                              (state.conclusion?.workFlowSteps ?? []).map((e) {
                            return FieldData(
                                title: e.index.toString(),
                                subTitle: e.stepName);
                          }).toList(),
                        ),
                        const SizedBox(height: 24),
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
                          "sar_text".tr(),
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
