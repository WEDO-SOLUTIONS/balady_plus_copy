import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../core/utils/enums/app_font_weights.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../data/model/investment_details_response.dart';
import '../../data/model/rental_details_response.dart';
import '../widgets/investment/details_card.dart';
import '../widgets/investment/download_foras_app.dart';
import '../widgets/investment/header_with_divider.dart';
import '../widgets/investment/pdf_component.dart';
import '../widgets/investment/requirment_attachments.dart';
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
                      firstTitle: "نوع الفرصة",
                      firstValue: "منافسة",
                      firstIconPath: IconPath.dollarCircle,
                      secondTitle: "السعر",
                      secondValue:
                          " ${data.data?.result?.documentValue} ريال /  الكراسة",
                    ),
                    CustomTextWidget(
                      "تفاصيل الفرصة",
                      fontSize: 16,
                      fontWeight: AppFontWeight.bold,
                      fontColor: AppColor.blackModern800Light,
                    ),
                    SizedBox(height: 16),
                    DetailsCard(
                      title: 'اسم الفرصة',
                      value: data.data?.result?.opportunityDescription ?? "",
                    ),
                    DetailsCard(
                      title: 'رقم الفرصة',
                      value: data.data?.result?.opportunityNumber ?? "",
                    ),
                    DetailsCard(
                      title: 'الجهة',
                      value: data.data?.result?.entityName ?? "",
                    ),
                    DetailsCard(
                        title: 'نوع النشاط',
                        value: data.data?.result?.mainActivity ?? ""),
                    DetailsCard(
                        title: 'سعر الكراسة',
                        value:
                            data.data?.result?.documentValue.toString() ?? ""),
                    DetailsCard(
                        title: 'نوع الدفع',
                        value: data.data?.result?.paymentType ?? ""),
                    //DetailsCard(title: 'نوع العطاء', value: data.data?.result?.bid),
                    DetailsCard(
                        title: 'نوع الضمان البنكي',
                        value: data.data?.result?.getBankWarrantyType() ?? ""),
                    DetailsCard(
                        title: 'قيمة الضمان البنكي',
                        value: data.data?.result
                                ?.getDeductInitialyWarrantyFirstYear() ??
                            ""),
                    DetailsCard(
                        title: 'مدة العقد',
                        value: data.data?.result
                                ?.getContractDurationYearsAndMonth() ??
                            ""),
                    SizedBox(height: 18),
                    CustomTextWidget(
                      "تواريخ الفرصة",
                      fontSize: 16,
                      fontWeight: AppFontWeight.bold,
                      fontColor: AppColor.blackModern800Light,
                    ),
                    SizedBox(height: 16),
                    DetailsCard(
                        title: 'آخر موعد لاستلام استفسارات المستثمرين',
                        value:
                            data.data?.result?.getFormattedQueryDateAndTime() ??
                                ""),
                    DetailsCard(
                        title: 'آخر موعد لشراء الكراسة',
                        value: data.data?.result
                                ?.getFormattedLastBuyRFPAndTime() ??
                            ""),
                    DetailsCard(
                        title: 'آخر موعد لتقديم العطاءات',
                        value: data.data?.result
                                ?.getFormattedLastBidDateAndTime() ??
                            ""),
                    DetailsCard(
                        title: 'موعد فتح المظاريف',
                        value: data.data?.result
                                ?.getFormattedEnvelopeOpenDateAndTime() ??
                            ""),
                    SizedBox(height: 18),
                    CustomTextWidget(
                      "تفاصيل الموقع",
                      fontSize: 16,
                      fontWeight: AppFontWeight.bold,
                      fontColor: AppColor.blackModern800Light,
                    ),
                    SizedBox(height: 16),
                    DetailsCard(
                        title: 'موقع فتح المظاريف',
                        value:
                            data.data?.result?.envelopeOpeningLocation ?? ""),
                    DetailsCard(
                        title: 'مساحة الموقع',
                        value: data.data?.result?.getTotalSiteArea() ?? ""),
                    DetailsCard(
                        title: 'الأمانة',
                        value: data.data?.result?.municipality ?? ""),
                    DetailsCard(
                        title: 'البلدية',
                        value: data.data?.result?.subMunicipality ?? ""),
                    SizedBox(height: 18),
                    CustomTextWidget(
                      "المستندات المطلوبة",
                      fontSize: 16,
                      fontWeight: AppFontWeight.bold,
                      fontColor: AppColor.blackModern800Light,
                    ),
                    SizedBox(height: 16),
                    RequirementAttachments(
                      title: "المستندات الاجبارية",
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
                      title: "المستندات الاختيارية",
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
                      "كراسة الشروط والمواصفات",
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
