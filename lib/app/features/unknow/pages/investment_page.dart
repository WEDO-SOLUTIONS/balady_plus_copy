import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../core/utils/utils_exports.dart';
import '../../_shared_feature_/shared_feature_exports.dart';
import '../../map_page/data/model/investment_details_response.dart';
import '../widgets/details_card.dart';
import '../widgets/download_foras_app.dart';
import '../widgets/header_with_divider.dart';
import '../widgets/pdf_component.dart';
import '../widgets/requirment_attachments.dart';
import 'package:collection/collection.dart';

class InvestmentPage extends StatelessWidget {
  final InvestmentDetailsResponse data;
  const InvestmentPage({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Image.asset(ImagePath.investmentBg),
        Container(
          color: AppColor.primary500Light,
        ),
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsetsDirectional.only(top: 34, start: 24),
                child: Icon(
                  Icons.close,
                  size: 24,
                  color: AppColor.blackModern50Light,
                ),
              ),
              const SizedBox(height: 100),
              Container(
                width: MediaQuery.sizeOf(context).width,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32)),
                  color: AppColor.white2,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextWidget(
                      data.data?.result?.opportunityDescription ?? "",
                      fontSize: 18,
                      fontWeight: AppFontWeight.bold,
                      fontColor: AppColor.blackModern800Light,
                    ),
                    SizedBox(height: 6),
                    CustomTextWidget(
                      data.data?.result?.subMunicipality ?? "",
                      fontSize: 14,
                      fontWeight: AppFontWeight.bold,
                      fontColor: AppColor.blackModern500Light,
                    ),
                    HeaderWithDivider(
                      firstTitle: "invest_type".tr(),
                      firstValue: "invest_status".tr(),
                      firstIconPath: IconPath.dollarCircle,
                      secondTitle: "invest_price".tr(),
                      secondValue:
                          " ${data.data?.result?.documentValue} ريال /  الكراسة",
                    ),
                    CustomTextWidget(
                      "invest_detail".tr(),
                      fontSize: 16,
                      fontWeight: AppFontWeight.bold,
                      fontColor: AppColor.blackModern800Light,
                    ),
                    SizedBox(height: 16),
                    DetailsCard(
                      title: 'invest_title'.tr(),
                      value: data.data?.result?.opportunityDescription ?? "",
                    ),
                    DetailsCard(
                      title: 'invest_number'.tr(),
                      value: data.data?.result?.opportunityNumber ?? "",
                    ),
                    DetailsCard(
                      title: 'invest_section'.tr(),
                      value: data.data?.result?.entityName ?? "",
                    ),
                    DetailsCard(
                        title: 'lbl_service_activity_hint1'.tr(),
                        value: data.data?.result?.mainActivity ?? ""),
                    DetailsCard(
                        title: 'map_price'.tr(),
                        value:
                            data.data?.result?.documentValue.toString() ?? ""),
                    DetailsCard(
                        title: 'invest_price_type'.tr(),
                        value: data.data?.result?.paymentType ?? ""),
                    //DetailsCard(title: 'نوع العطاء', value: data.data?.result?.bid),
                    DetailsCard(
                        title: 'invest_bank'.tr(),
                        value: data.data?.result?.getBankWarrantyType() ?? ""),
                    DetailsCard(
                        title: 'invest_bank_price'.tr(),
                        value: data.data?.result
                                ?.getDeductInitialyWarrantyFirstYear() ??
                            ""),
                    DetailsCard(
                        title: 'investemnt_duration'.tr(),
                        value: data.data?.result
                                ?.getContractDurationYearsAndMonth() ??
                            ""),
                    SizedBox(height: 18),
                    CustomTextWidget(
                      'invest_date'.tr(),
                      fontSize: 16,
                      fontWeight: AppFontWeight.bold,
                      fontColor: AppColor.blackModern800Light,
                    ),
                    SizedBox(height: 16),
                    DetailsCard(
                        title: 'invest_last_submit'.tr(),
                        value:
                            data.data?.result?.getFormattedQueryDateAndTime() ??
                                ""),
                    DetailsCard(
                        title: 'dateChoose'.tr(),
                        value: data.data?.result
                                ?.getFormattedLastBuyRFPAndTime() ??
                            ""),
                    DetailsCard(
                        title: 'lastDateToSubmit'.tr(),
                        value: data.data?.result
                                ?.getFormattedLastBidDateAndTime() ??
                            ""),
                    DetailsCard(
                        title: 'openingDate'.tr(),
                        value: data.data?.result
                                ?.getFormattedEnvelopeOpenDateAndTime() ??
                            ""),
                    SizedBox(height: 18),
                    CustomTextWidget(
                      'qr_locatoin_details'.tr(),
                      fontSize: 16,
                      fontWeight: AppFontWeight.bold,
                      fontColor: AppColor.blackModern800Light,
                    ),
                    SizedBox(height: 16),
                    DetailsCard(
                        title: 'openinglocation'.tr(),
                        value:
                            data.data?.result?.envelopeOpeningLocation ?? ""),
                    DetailsCard(
                        title: 'map_space'.tr(),
                        value: data.data?.result?.getTotalSiteArea() ?? ""),
                    DetailsCard(
                        title: 'municipality'.tr(),
                        value: data.data?.result?.municipality ?? ""),
                    DetailsCard(
                        title: 'sub_municipality'.tr(),
                        value: data.data?.result?.subMunicipality ?? ""),
                    SizedBox(height: 18),
                    CustomTextWidget(
                      'askedenquiry'.tr(),
                      fontSize: 16,
                      fontWeight: AppFontWeight.bold,
                      fontColor: AppColor.blackModern800Light,
                    ),
                    SizedBox(height: 16),
                    RequirementAttachments(
                      title: 'compulsoryEnquiry'.tr(),
                      attachments:
                          data.data?.result?.requiredAttachmentCategoryList
                                  ?.map((e) {
                                    if (e.isMandatory == true) return e.name;
                                  })
                                  .toList()
                                  .whereNotNull()
                                  .toList() ??
                              [],
                    ),
                    SizedBox(height: 10),
                    RequirementAttachments(
                      title: 'testEnquiry'.tr(),
                      attachments:
                          data.data?.result?.requiredAttachmentCategoryList
                                  ?.map((e) {
                                    if (e.isMandatory != true) return e.name;
                                  })
                                  .toList()
                                  .whereNotNull()
                                  .toList() ??
                              [],
                    ),
                    SizedBox(height: 10),
                    CustomTextWidget(
                      'investment_rules'.tr(),
                      fontSize: 16,
                      fontWeight: AppFontWeight.bold,
                      fontColor: AppColor.blackModern800Light,
                    ),
                    SizedBox(height: 16),
                    PDFComponent(
                      pdfs: data.data?.result?.contractTemplateAndTerms,
                    ),
                    SizedBox(height: 14),
                    DownloadForasApp(),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
