import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../core/utils/utils_exports.dart';
import '../../_shared_feature_/shared_feature_exports.dart';
import '../../map_page/data/model/rental_details_response.dart';
import '../widgets/details_card.dart';
import '../widgets/download_foras_app.dart';
import '../widgets/header_with_divider.dart';
import '../widgets/requirment_attachments.dart';

class TempRentalPage extends StatelessWidget {
  final RentalDetailsResponse data;
  const TempRentalPage({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //  Image.asset(ImagePath.investmentBg),
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
                      data.data?.details?.siteDescription ?? "",
                      fontSize: 18,
                      fontWeight: AppFontWeight.bold,
                      fontColor: AppColor.blackModern800Light,
                    ),
                    SizedBox(height: 6),
                    CustomTextWidget(
                      data.data?.details?.municipality ?? "",
                      fontSize: 14,
                      fontWeight: AppFontWeight.bold,
                      fontColor: AppColor.blackModern500Light,
                    ),
                    HeaderWithDivider(
                      firstTitle: "نوع الفرصة",
                      firstValue: "إيجار مؤقت",
                      firstIconPath: IconPath.moneyTime,
                      secondTitle: "السعر",
                      secondValue: getDailyCost(),
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
                        value: data.data?.details?.siteDescription ?? ""),
                    DetailsCard(
                        title: 'رقم الفرصة',
                        value: data.data?.details?.opportunityNumber ?? ""),
                    DetailsCard(
                        title: 'الجهة',
                        value: data.data?.details?.entityName ?? ""),
                    DetailsCard(
                        title: 'نوع النشاط',
                        value: data.data?.details?.getActivityName() ?? ""),
                    DetailsCard(
                      title: 'سعر المتر',
                      value: data.data?.details?.getPrice() ?? "",
                      note: "سعر المتر متغير بتغير اليوم",
                    ),
                    SizedBox(height: 18),
                    CustomTextWidget(
                      "تواريخ الفرصة",
                      fontSize: 16,
                      fontWeight: AppFontWeight.bold,
                      fontColor: AppColor.blackModern800Light,
                    ),
                    SizedBox(height: 16),
                    DetailsCard(
                        title: 'آخر موعد لتقديم الطلب',
                        value: data.data?.details?.getEndPeriodDate() ?? ""),
                    SizedBox(height: 18),
                    CustomTextWidget(
                      "تفاصيل الموقع",
                      fontSize: 16,
                      fontWeight: AppFontWeight.bold,
                      fontColor: AppColor.blackModern800Light,
                    ),
                    SizedBox(height: 16),
                    DetailsCard(
                        title: 'مساحة الموقع',
                        value: data.data?.details?.getArea() ?? ""),
                    DetailsCard(
                        title: 'الأمانة',
                        value: data.data?.details?.municipality ?? ""),
                    DetailsCard(
                        title: 'البلدية',
                        value: data.data?.details?.subMunicipality ?? ""),
                    SizedBox(height: 18),
                    CustomTextWidget(
                      "المستندات المطلوبة",
                      fontSize: 16,
                      fontWeight: AppFontWeight.bold,
                      fontColor: AppColor.blackModern800Light,
                    ),
                    SizedBox(height: 16),
                    /*  RequirementAttachments(
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
                    SizedBox(height: 14),*/
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

  String getDailyCost() {
    String cost =
        (data.data?.details?.getPrice() ?? "") + "  " + ("sar_per_meter").tr();

    if (!(data.data?.details?.isSeasonal() ?? false)) {
      cost = ('start_from').tr() + "  " + cost;
    }

    return cost;
  }
}
