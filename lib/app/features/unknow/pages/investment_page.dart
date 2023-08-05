import 'package:flutter/material.dart';
import '../../../core/utils/utils_exports.dart';
import '../../_shared_feature_/shared_feature_exports.dart';
import '../widgets/details_card.dart';
import '../widgets/download_foras_app.dart';
import '../widgets/header_with_divider.dart';
import '../widgets/pdf_component.dart';
import '../widgets/requirment_attachments.dart';

class InvestmentPage extends StatelessWidget {
  const InvestmentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(ImagePath.investmentBg),
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
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextWidget(
                      "تشغيل وصيانة تشغيل وصيانة مستودع",
                      fontSize: 18,
                      fontWeight: AppFontWeight.bold,
                      fontColor: AppColor.blackModern800Light,
                    ),
                    SizedBox(height: 6),
                    CustomTextWidget(
                      "أمانة المنطقة الشرقية",
                      fontSize: 14,
                      fontWeight: AppFontWeight.bold,
                      fontColor: AppColor.blackModern500Light,
                    ),
                    HeaderWithDivider(
                      firstTitle: "نوع الفرصة",
                      firstValue: "منافسة",
                      firstIconPath: IconPath.dollarCircle,
                      secondTitle: "السعر",
                      secondValue: " 1500 ريال /  الكراسة",
                    ),
                    CustomTextWidget(
                      "تفاصيل الفرصة",
                      fontSize: 16,
                      fontWeight: AppFontWeight.bold,
                      fontColor: AppColor.blackModern800Light,
                    ),
                    SizedBox(height: 16),
                    DetailsCard(title: 'اسم الفرصة', value: ""),
                    DetailsCard(title: 'رقم الفرصة', value: ""),
                    DetailsCard(title: 'الجهة', value: ""),
                    DetailsCard(title: 'نوع النشاط', value: ""),
                    DetailsCard(title: 'سعر الكراسة', value: ""),
                    DetailsCard(title: 'نوع الدفع', value: ""),
                    DetailsCard(title: 'نوع العطاء', value: ""),
                    DetailsCard(title: 'نوع الضمان البنكي', value: ""),
                    DetailsCard(title: 'قيمة الضمان البنكي', value: ""),
                    DetailsCard(title: 'مدة العقد', value: ""),
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
                        value: ""),
                    DetailsCard(title: 'آخر موعد لشراء الكراسة', value: ""),
                    DetailsCard(title: 'آخر موعد لتقديم العطاءات', value: ""),
                    DetailsCard(title: 'موعد فتح المظاريف', value: ""),
                    SizedBox(height: 18),
                    CustomTextWidget(
                      "تفاصيل الموقع",
                      fontSize: 16,
                      fontWeight: AppFontWeight.bold,
                      fontColor: AppColor.blackModern800Light,
                    ),
                    SizedBox(height: 16),
                    DetailsCard(title: 'موقع فتح المظاريف', value: ""),
                    DetailsCard(title: 'مساحة الموقع', value: ""),
                    DetailsCard(title: 'الأمانة', value: ""),
                    DetailsCard(title: 'البلدية', value: ""),
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
                      attachments: [
                        "سجل تجاري ساري المدة",
                        "سجل تجاري ساري المدة"
                      ],
                    ),
                    SizedBox(height: 10),
                    RequirementAttachments(
                      title: "المستندات الاختيارية",
                      attachments: [
                        "سجل تجاري ساري المدة",
                        "سجل تجاري ساري المدة"
                      ],
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
                      pdfs: [
                        "نموذج العقد",
                        "كراسة الشروط",
                      ],
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





