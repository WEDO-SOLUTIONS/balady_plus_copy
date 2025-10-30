/*import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/features/vd/presentation/widgets/summery_widgets/field_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/services/local/helpers.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/constants.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../core/services/view_models/health_request_details_view_model.dart';
import 'license_bill_body_section.dart';

class OrderBodySectionWidget extends StatelessWidget {
  final bool isLicense;
  const OrderBodySectionWidget({Key? key, this.isLicense = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<HealthRequestDetailsViewModel>(
        builder: (context, model, child) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // certificate data
          const _CertificateDataWidget(),
          // com license info data
          // medical examination data
          if (model.showExamanationData())
            const _MedicalExaminationDataWidget(),
          // attachments
          if (model.showAttachments()) const _AttachmentsWidget(),
          // notes
          if (model.showNotes()) const _NotesWidget(),
          if (model.showBillsInfo())
            _BillInfoDataWidget(
              isLicense: isLicense,
            ),
          Constants.verticalSpaceLarge,
        ],
      );
    });
  }
}

class _CertificateDataWidget extends StatelessWidget {
  const _CertificateDataWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HealthRequestDetailsViewModel model =
        Provider.of<HealthRequestDetailsViewModel>(context);
    return CustomExpansionPanelWidget(
      title: Helpers.translatingWord("health_info"),
      underline: false,
      children: [
        FieldData(
          title: Helpers.translatingWord("health_fullname"),
          subTitle: model.requestDetails?.getFullName() ?? "",
        ),
        FieldData(
          title: Helpers.translatingWord("health_mobile"),
          subTitle: model.requestDetails?.getMobileNumber() ?? "",
        ),
        FieldData(
          title: Helpers.translatingWord("health_municipality"),
          subTitle: model.requestDetails?.getMunicipalityName() ?? "",
        ),
        FieldData(
          title: Helpers.translatingWord("health_sub_municipality"),
          subTitle: model.requestDetails?.getSubMunicipalityName() ?? "",
        ),
        const _ComLicenseInfoDataWidget(),
        Constants.verticalSpaceMedium,
        const _CertificateDataHintWidget(),
      ],
    );
  }
}

class _CertificateDataHintWidget extends StatelessWidget {
  const _CertificateDataHintWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HealthRequestDetailsViewModel model =
        Provider.of<HealthRequestDetailsViewModel>(context);

    return Visibility(
      visible: model.requestDetails?.getRequestStatus() ==
          LICENSE_MANAGEMENT_STATUS.WAITING_EMPLOYEE_VISIT,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Constants.semiSmallPadding,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // icon
            const Icon(Icons.info, color: AppColor.orange800, size: 18.0),
            Constants.horizontalSpaceSmall,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextWidget(
                    Helpers.translatingWord("health_visit_center"),
                    fontColor: AppColor.orange800,
                    fontWeight: AppFontWeight.medium,
                  ),
                  const CustomVerticalSpace(height: 5.0),
                  /* CustomTextButtonWidget(
                    btnPressed: () => NavigationService.navigatorKey.currentState!
                        .pushNamed(RoutesNames.nearestCentersRote),
                    btnText: Helpers.tran("health_cert_show_centeres"),
                    btnTextSize: 16.0,
                    btnTextWeight: FONT_WEIGHT.medium,
                    btnTextColor: AppColor.primary900Light,
                    haveUnderline: true,
                  ),*/
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MedicalExaminationDataWidget extends StatelessWidget {
  const _MedicalExaminationDataWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HealthRequestDetailsViewModel model =
        Provider.of<HealthRequestDetailsViewModel>(context);
    return CustomEnhancedExpansionPanelWidget(
      title: Helpers.translatingWord("health_medical_info"),
      underline: false,
      children: [
        FieldData(
          title: Helpers.translatingWord("health_medical_code"),
          subTitle: model.requestDetails?.getMedicalExamCode() ?? "",
        ),
        FieldData(
          title: Helpers.translatingWord("health_medical_date"),
          subTitle: model.requestDetails?.getMedicalExamDate() ?? "",
        ),
        FieldData(
          title: Helpers.translatingWord("health_medical_hospital_name"),
          subTitle: model.requestDetails?.getMedicalExamHospitalName() ?? "",
        ),
      ],
    );
  }
}

class _AttachmentsWidget extends StatelessWidget {
  const _AttachmentsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HealthRequestDetailsViewModel model =
        Provider.of<HealthRequestDetailsViewModel>(context);

    return CustomEnhancedExpansionPanelWidget(
        title: Helpers.translatingWord("health_attachments"),
        underline: false,
        children: [
          model.requestDetails?.data?.result?.requestAttachments != null &&
                  model.requestDetails!.data!.result!.requestAttachments!
                      .isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...model.requestDetails!.data!.result!.requestAttachments!
                        .map<CustomTitleSubtitleCardWidget>((e) {
                      return CustomTitleSubtitleCardWidget(
                        horizontalPadding: Constants.smallPadding,
                        title: e.name ?? "",
                        subtitleWidget: _CustomAttachmentInfoWidget(
                          id: e.attachUrl?.split("/").last ?? "",
                          title: e.name ?? "",
                        ),
                      );
                    }).toList()
                  ],
                )
              : Container(),
        ]);
  }
}

class _CustomAttachmentInfoWidget extends StatelessWidget {
  String id;
  String title;
  _CustomAttachmentInfoWidget({Key? key, required this.id, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Provider.of<HealthRequestDetailsViewModel>(context, listen: false)
            .downLoadAttachment(id);
      },
      child: Container(
        margin: const EdgeInsets.only(top: Constants.semiSmallPadding),
        padding: const EdgeInsets.all(Constants.smallPadding),
        decoration: BoxDecoration(
          color: AppColor.white3,
          borderRadius: BorderRadius.circular(2.0),
        ),
        child: Row(
          children: [
            // icon
            Image.asset(
              Constants.imgPath + 'attachmentIcon@3x.png',
              height: 35,
              width: 35,
            ),
            Constants.horizontalSpaceSmall,
            // attachment name
            Expanded(
              child: CustomTextWidget(
                title,
                fontColor: AppColor.black,
                textAlign: TextAlign.start,
                fontSize: 13.0,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotesWidget extends StatelessWidget {
  const _NotesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HealthRequestDetailsViewModel model =
        Provider.of<HealthRequestDetailsViewModel>(context);

    return CustomEnhancedExpansionPanelWidget(
      title: Helpers.translatingWord("health_notes"),
      underline: false,
      child: model.requestDetails?.data?.result?.notes != null
          ? Column(
              children: [
                ...model.requestDetails!.data!.result!.notes!.map<Column>((e) {
                  return Column(
                    children: [
                      CustomTitleSubtitleCardWidget(
                        horizontalPadding: Constants.smallPadding,
                        title: Helpers.translatingWord(
                            "health_request_details_note_date"),
                        subtitle: e.date,
                      ),
                      CustomTitleSubtitleCardWidget(
                        horizontalPadding: Constants.smallPadding,
                        title: Helpers.translatingWord(
                            "health_request_details_note_author"),
                        subtitle: e.author,
                      ),
                      CustomTitleSubtitleCardWidget(
                        horizontalPadding: Constants.smallPadding,
                        title: Helpers.translatingWord(
                            "health_request_details_note_note"),
                        subtitle: e.note,
                      ),
                      const CustomVerticalSpace(height: 16),
                      const Divider(
                        height: 1,
                      ),
                      const CustomVerticalSpace(height: 16),
                    ],
                  );
                }).toList()
              ],
            )
          : Container(),
    );
  }
}

class _ComLicenseInfoDataWidget extends StatelessWidget {
  const _ComLicenseInfoDataWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HealthRequestDetailsViewModel model =
        Provider.of<HealthRequestDetailsViewModel>(context);
    ComLicenseInfo? comLicenseInfo =
        model.requestDetails?.data?.result?.comLicenseInfo;
    return Visibility(
      visible: comLicenseInfo != null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTitleSubtitleCardWidget(
            horizontalPadding: Constants.smallPadding,
            title: Helpers.translatingWord(
                'userLicensesLicenseDetailsLicenseNumberWord'),
            subtitle: comLicenseInfo?.licenseNumber.toString() ?? "",
          ),
          CustomTitleSubtitleCardWidget(
            horizontalPadding: Constants.smallPadding,
            title: Helpers.translatingWord("isic_activity"),
            subtitle: comLicenseInfo?.isicName.toString() ?? "",
          ),
        ],
      ),
    );
  }
}

class _BillInfoDataWidget extends StatelessWidget {
  final bool isLicense;
  const _BillInfoDataWidget({Key? key, this.isLicense = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    HealthRequestDetailsViewModel model =
        Provider.of<HealthRequestDetailsViewModel>(context);
    BillInfo? billingInfo = model.requestDetails?.data?.result?.billInfo;
    return CustomEnhancedExpansionPanelWidget(
      title: Helpers.translatingWord("health_bill"),
      underline: false,
      child: billingInfo != null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  _BillStatusCardWidget(
                      billStatusName: billingInfo.billStatus,
                      billStatus: billingInfo.getBillStatus(),
                      requestNumber: billingInfo.billNumber),
                  const CustomVerticalSpace(height: 24),
                  if (billingInfo.billFees != null)
                    ...billingInfo.billFees!.map<BillDetailsCardWidget>((e) {
                      return BillDetailsCardWidget(
                          label: e.costItemDescription ?? "",
                          price: e.costItemValue.toString());
                    }).toList(),
                  const CustomVerticalSpace(height: 18),
                  const DrawLineWidget(),
                  const CustomVerticalSpace(height: 18),
                  BillDetailsCardWidget(
                      label: Helpers.translatingWord("health_bill_fees"),
                      totalPrice: billingInfo.billAmount.toString()),
                  Constants.verticalSpaceMedium,
                  GestureDetector(
                    onTap: () {
                      CustomPopUpsWidgets.showBottomSheet(
                        NavigationService.navigatorKey.currentContext!,
                        child: LicenseBillBodySectionWidget(
                          billInfo:
                              model.requestDetails!.data!.result!.billInfo!,
                          typeName: model
                              .requestDetails!.data!.result!.requestTypeName!,
                          licenseNumber: model.requestDetails
                                  ?.getRequestIdOrLicenseId(isLicense) ??
                              "",
                        ),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Constants.semiMediumPadding,
                      ),
                      child: CustomTextWidget(
                        Helpers.translatingWord("show_bill_info"),
                        fontColor: AppColor.baladyDarkGreen2,
                        fontSize: 16.0,
                        fontWeight: FONT_WEIGHT.medium,
                        textAlign: TextAlign.start,
                        textDecoration: TextDecoration.underline,
                      ),
                    ),
                  )
                ])
          : Container(),
    );
  }
}

class _BillStatusCardWidget extends StatelessWidget {
  String? billStatusName;
  LICENSE_MANAGEMENT_STATUS? billStatus;
  String? requestNumber;

  _BillStatusCardWidget(
      {this.billStatusName, this.requestNumber, this.billStatus});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: Constants.semiMediumPadding,
          vertical: Constants.smallPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomTextWidget(
            requestNumber ?? "",
            fontColor: AppColor.kGray115,
            fontWeight: FONT_WEIGHT.bold,
          ),
          LicenseStatusWidget(
            licenseStatus: billStatus ?? LICENSE_MANAGEMENT_STATUS.DRAFT,
            licenseStatusName: billStatusName ?? "",
          ),
        ],
      ),
    );
  }
}
*/
