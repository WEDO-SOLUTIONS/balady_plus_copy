import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/features/vd/presentation/widgets/summery_widgets/field_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/services/local/helpers.dart';
import '../../../../core/services/local/navigation_services.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/constants.dart';
import '../../../../core/utils/enums/health_certificate.dart';
import '../../../_shared_feature_/presentation/dialogs/dialog_header.dart';
import '../../../_shared_feature_/presentation/widgets/custom_popups_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../core/models/health_request_details.dart';
import '../core/services/view_models/health_request_details_view_model.dart';
import 'bill_details_card_widget.dart';
import 'license_details_header_section copy.dart';
import 'license_status_widget.dart';

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
          const _CertificateOwnerDataWidget(),

          const _CertificateSubmitterDataWidget(),
          const _CertificateDataDataWidget(),
          // com license info data
          // medical examination data
          if (model.showExamanationData())
            const _MedicalExaminationDataWidget(),
          if (model.requestDetails?.data?.result?.medicalExamInfo != null)
            _TathqeefSehyDataWidget(),
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
      title: Helpers.translatingWord("health_bill_order"),
      underline: false,
      children: [
        FieldData(
          title: Helpers.translatingWord("health_data"),
          subTitle: model.requestDetails?.data?.result?.requestSubmitDate,
        ),
        CustomVerticalSpace(height: 8),
        FieldData(
          title: Helpers.translatingWord("health_data_no"),
          subTitle: model.requestDetails?.getRequestId() ?? "",
        ),
        CustomVerticalSpace(height: 8),
        FieldData(
          title: Helpers.translatingWord("health_data_status"),
          subTitle: model.requestDetails?.getRequestStatusName() ?? "",
        ),
      ],
    );
  }
}

class _CertificateOwnerDataWidget extends StatelessWidget {
  const _CertificateOwnerDataWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HealthRequestDetailsViewModel model =
        Provider.of<HealthRequestDetailsViewModel>(context);
    return CustomExpansionPanelWidget(
      title: Helpers.translatingWord("health_owner_data"),
      underline: false,
      children: [
        FieldData(
            title: Helpers.translatingWord("health_owner_data_field1"),
            subTitle: model
                    .requestDetails?.data?.result?.ownerInfo?.identityNumber
                    .toString() ??
                ""),
        CustomVerticalSpace(height: 8),
        FieldData(
          title: Helpers.translatingWord("health_owner_data_field2"),
          subTitle: model.requestDetails?.data?.result?.ownerInfo?.fullName,
        ),
      ],
    );
  }
}

class _CertificateSubmitterDataWidget extends StatelessWidget {
  const _CertificateSubmitterDataWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HealthRequestDetailsViewModel model =
        Provider.of<HealthRequestDetailsViewModel>(context);
    return CustomExpansionPanelWidget(
      title: Helpers.translatingWord("health_submitter_data"),
      underline: false,
      children: [
        FieldData(
          title: Helpers.translatingWord("health_submitter_id"),
          subTitle: model
                  .requestDetails?.data?.result?.submitterInfo?.identityNumber
                  .toString() ??
              "",
        ),
        CustomVerticalSpace(height: 8),
        FieldData(
          title: Helpers.translatingWord("health_submitter_name"),
          subTitle: model.requestDetails?.data?.result?.submitterInfo?.fullName,
        ),
        CustomVerticalSpace(height: 8),
        FieldData(
          title: Helpers.translatingWord("health_submitter_mobile"),
          subTitle: model.requestDetails?.data?.result?.submitterInfo?.mobile,
        ),
        CustomVerticalSpace(height: 8),
        FieldData(
          title: Helpers.translatingWord("health_submitter_mail"),
          subTitle: model.requestDetails?.data?.result?.submitterInfo?.email,
        ),
      ],
    );
  }
}

class _CertificateDataDataWidget extends StatelessWidget {
  const _CertificateDataDataWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HealthRequestDetailsViewModel model =
        Provider.of<HealthRequestDetailsViewModel>(context);
    return CustomExpansionPanelWidget(
      title: Helpers.translatingWord("health_cert_data"),
      underline: false,
      children: [
        FieldData(
          title: Helpers.translatingWord("health_cert_no"),
          subTitle: model.requestDetails?.data?.result?.healthCertificateInfo
                  ?.certificateId
                  .toString() ??
              "",
        ),
        CustomVerticalSpace(height: 8),
        FieldData(
          title: Helpers.translatingWord("health_cert_h_date"),
          subTitle: model
              .requestDetails?.data?.result?.healthCertificateInfo?.issueDate,
        ),
        CustomVerticalSpace(height: 8),
        FieldData(
          title: Helpers.translatingWord("health_cert_h_end"),
          subTitle: model
              .requestDetails?.data?.result?.healthCertificateInfo?.expiryDate,
        ),
        CustomVerticalSpace(height: 8),
        FieldData(
          title: Helpers.translatingWord("health_cert_g_date"),
          subTitle: model
              .requestDetails?.data?.result?.healthCertificateInfo?.issueDateG,
        ),
        CustomVerticalSpace(height: 8),
        FieldData(
          title: Helpers.translatingWord("health_cert_g_end"),
          subTitle: model
              .requestDetails?.data?.result?.healthCertificateInfo?.expiryDateG,
        ),
        CustomVerticalSpace(height: 8),
        FieldData(
          title: Helpers.translatingWord("health_cert_lice_statue"),
          subTitle: model
              .requestDetails?.data?.result?.healthCertificateInfo?.statusName,
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
    return CustomExpansionPanelWidget(
      title: Helpers.translatingWord("health_medical_info"),
      underline: false,
      children: [
        FieldData(
          title: Helpers.translatingWord("health_medical_code"),
          subTitle: model.requestDetails?.getMedicalExamCode() ?? "",
        ),
        CustomVerticalSpace(height: 8),
        FieldData(
          title: Helpers.translatingWord("health_medical_date"),
          subTitle: model.requestDetails?.getMedicalExamDate() ?? "",
        ),
        CustomVerticalSpace(height: 8),
        FieldData(
          title: Helpers.translatingWord("health_medical_hospital_name"),
          subTitle: model.requestDetails?.getMedicalExamHospitalName() ?? "",
        ),
      ],
    );
  }
}

class _TathqeefSehyDataWidget extends StatelessWidget {
  const _TathqeefSehyDataWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HealthRequestDetailsViewModel model =
        Provider.of<HealthRequestDetailsViewModel>(context);
    return CustomExpansionPanelWidget(
      title: Helpers.translatingWord("medical_examination_data"),
      underline: false,
      children: [
        FieldData(
            title: Helpers.translatingWord("health_trining_id"),
            subTitle: model
                    .requestDetails?.data?.result?.medicalTrainingInfo?.id
                    .toString() ??
                ""),
        CustomVerticalSpace(height: 8),
        FieldData(
            title: Helpers.translatingWord("health_trining_startDate"),
            subTitle: model.requestDetails?.data?.result?.medicalTrainingInfo
                    ?.startDate ??
                ""),
        CustomVerticalSpace(height: 8),
        FieldData(
          title: Helpers.translatingWord("health_trining_expiryDate"),
          subTitle: model.requestDetails?.data?.result?.medicalTrainingInfo
                  ?.expiryDate ??
              "",
        ),
        CustomVerticalSpace(height: 8),
        FieldData(
          title: Helpers.translatingWord("health_trining_trainingCenter"),
          subTitle: model.requestDetails?.data?.result?.medicalTrainingInfo
                  ?.trainingCenter ??
              "",
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

    return CustomExpansionPanelWidget(
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
                      .map<LabelIconSubtitleComponent>((e) {
                    return LabelIconSubtitleComponent(
                      text: e.name ?? "",
                      subWidget: _CustomAttachmentInfoWidget(
                        id: e.attachUrl?.split("/").last ?? "",
                        title: e.name ?? "",
                      ),
                    );
                  }).toList()
                ],
              )
            : Container()
      ],
    );
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
            height: 56,
            width: double.infinity,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(0x80E6EFEF),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8), topRight: Radius.circular(8)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomHorizontalSpace(width: 8),
                Flexible(
                  child: CustomTextWidget(
                    title,
                    fontColor: AppColor.blackModern700Light,
                    fontSize: 12,
                    maxLines: 1,
                    fontWeight: AppFontWeight.semiBold,
                  ),
                ),
              ],
            )));
  }
}

class _NotesWidget extends StatelessWidget {
  const _NotesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HealthRequestDetailsViewModel model =
        Provider.of<HealthRequestDetailsViewModel>(context);

    return CustomExpansionPanelWidget(
      title: Helpers.translatingWord("health_notes"),
      underline: false,
      children: [
        model.requestDetails?.data?.result?.notes != null
            ? Column(
                children: [
                  ...model.requestDetails!.data!.result!.notes!
                      .map<Column>((e) {
                    return Column(
                      children: [
                        FieldData(
                          title: Helpers.translatingWord(
                              "health_request_details_note_date"),
                          subTitle: e.date,
                        ),
                        CustomVerticalSpace(height: 8),
                        FieldData(
                          title: Helpers.translatingWord(
                              "health_request_details_note_author"),
                          subTitle: e.author,
                        ),
                        CustomVerticalSpace(height: 8),
                        FieldData(
                          title: Helpers.translatingWord(
                              "health_request_details_note_note"),
                          subTitle: e.note,
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
            : Container()
      ],
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
          FieldData(
            title: Helpers.translatingWord(
                'userLicensesLicenseDetailsLicenseNumberWord'),
            subTitle: comLicenseInfo?.licenseNumber.toString() ?? "",
          ),
          FieldData(
            title: Helpers.translatingWord("isic_activity"),
            subTitle: comLicenseInfo?.isicName.toString() ?? "",
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
    print("billCreated ${billingInfo?.billCreated}");
    return CustomExpansionPanelWidget(
      title: Helpers.translatingWord("health_bill"),
      underline: false,
      children: [
        billingInfo != null && billingInfo.billCreated == true
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: Constants.semiMediumPadding,
                        ),
                        child: CustomTextWidget(
                          Helpers.translatingWord("show_bill_info"),
                          fontColor: AppColor.baladyDarkGreen2,
                          fontSize: 16.0,
                          fontWeight: AppFontWeight.medium,
                          textAlign: TextAlign.start,
                          textDecoration: TextDecoration.underline,
                        ),
                      ),
                    )
                  ])
            : NotesWidget(notes: billingInfo?.warnings ?? [])
      ],
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
            fontWeight: AppFontWeight.bold,
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

class BillDetailsCardWidget extends StatelessWidget {
  final String label;
  final String? price;
  final String? totalPrice;
  const BillDetailsCardWidget({
    Key? key,
    required this.label,
    this.price,
    this.totalPrice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Constants.semiMediumPadding,
      ),
      child: Row(
        children: [
          // icon
          Container(
            width: 4.0,
            height: 4.0,
            decoration: BoxDecoration(
              color: totalPrice == null
                  ? AppColor.baladyDarkGreen2
                  : Colors.transparent,
              shape: BoxShape.circle,
            ),
          ),
          Constants.horizontalSpaceSmall,
          Expanded(
            child: LayoutBuilder(
              builder: (_, constraints) {
                final width = constraints.maxWidth;
                return Row(
                  children: [
                    // label
                    SizedBox(
                      width: width * 0.70,
                      child: CustomTextWidget(
                        label,
                        fontColor: AppColor.black700,
                        fontSize: 13.0,
                        textAlign: TextAlign.start,
                      ),
                    ),
                    // price
                    SizedBox(
                      width: width * 0.30,
                      child: RichText(
                        textScaleFactor: 1,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        textAlign: TextAlign.end,
                        text: TextSpan(
                          text: _getPrice(),
                          style: const TextStyle(
                            color: AppColor.black,
                            fontSize: 16.0,
                            fontFamily: Constants.appFontType,
                            fontWeight: FontWeight.bold,
                          ),
                          children: const [
                            TextSpan(text: '  '),
                            TextSpan(
                              text: 'ريال',
                              style: TextStyle(
                                color: AppColor.black500,
                                fontSize: 13.0,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getPrice() {
    if (price != null && totalPrice == null) {
      return '$price';
    } else if (price == null && totalPrice != null) {
      return '$totalPrice';
    } else {
      return '0';
    }
  }
}

class LicenseBillBodySectionWidget extends StatelessWidget {
  BillInfo billInfo;
  String typeName;
  String licenseNumber;
  LicenseBillBodySectionWidget(
      {Key? key,
      required this.billInfo,
      required this.typeName,
      required this.licenseNumber})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, top: 26, bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // bill info
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 20),
            child: DialogHeader(
              title: Helpers.translatingWord('bill_info'),
            ),
          ),
          const CustomVerticalSpace(height: 20),
          LicenseDetailsHeaderSection(
            licenseManagementStatus: billInfo.getBillStatus(),
            licensetStatusName: billInfo.billStatus ?? "",
            title: typeName,
            licenseId: licenseNumber,
          ),
          const CustomVerticalSpace(height: 24),
          const DrawLineWidget(),
          const CustomVerticalSpace(height: 10),

          _BillInfoWidget(
            createDate: billInfo.billCreationDate ?? "",
            billNumber: billInfo.billNumber ?? "",
            billCreated: billInfo.billCreated,
            warnings: billInfo.warnings,
          ),
          // // bill details
          /*if (billInfo.billFees != null &&
              billInfo.billFees!.isNotEmpty &&
              billInfo.billCreated == true)
            BillDetailsWidget(
                fees: billInfo.billFees!, totalAmount: billInfo.billAmount),*/
          Constants.verticalSpaceLarge,
        ],
      ),
    );
  }
}

class _BillInfoWidget extends StatelessWidget {
  String createDate;
  String billNumber;
  bool? billCreated;
  List<String>? warnings;

  _BillInfoWidget(
      {required this.createDate,
      required this.billNumber,
      this.billCreated,
      this.warnings});

  @override
  Widget build(BuildContext context) {
    return CustomExpansionPanelWidget(
      title: Helpers.translatingWord("health_bill_info"),
      underline: false,
      children: [
        if (billCreated == true)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FieldData(
                title: Helpers.translatingWord("health_bill_date"),
                subTitle: createDate,
              ),
              CustomVerticalSpace(height: 8),
              FieldData(
                title: Helpers.translatingWord("health_bill_number"),
                subTitle: billNumber,
              ),
            ],
          ),
        if (billCreated == false && warnings != null)
          NotesWidget(notes: warnings ?? [])
      ],
    );
  }
}
