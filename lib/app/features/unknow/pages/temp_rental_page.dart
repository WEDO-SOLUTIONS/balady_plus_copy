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
                      firstTitle: 'invest_type'.tr(),
                      firstValue: "rent".tr(),
                      firstIconPath: IconPath.moneyTime,
                      secondTitle: "السعر",
                      secondValue: getDailyCost(),
                    ),
                    CustomTextWidget(
                      'invest_detail'.tr(),
                      fontSize: 16,
                      fontWeight: AppFontWeight.bold,
                      fontColor: AppColor.blackModern800Light,
                    ),
                    SizedBox(height: 16),
                    DetailsCard(
                        title: 'invest_title'.tr(),
                        value: data.data?.details?.siteDescription ?? ""),
                    DetailsCard(
                        title: 'invest_number'.tr(),
                        value: data.data?.details?.opportunityNumber ?? ""),
                    DetailsCard(
                        title: 'invest_section'.tr(),
                        value: data.data?.details?.entityName ?? ""),
                    DetailsCard(
                        title: 'lbl_service_activity_hint1'.tr(),
                        value: data.data?.details?.getActivityName() ?? ""),
                    DetailsCard(
                        title: 'meter_price',
                        value: data.data?.details?.getPrice() ?? "",
                        note: 'details_note'.tr()),
                    SizedBox(height: 18),
                    CustomTextWidget(
                      "invest_date".tr(),
                      fontSize: 16,
                      fontWeight: AppFontWeight.bold,
                      fontColor: AppColor.blackModern800Light,
                    ),
                    SizedBox(height: 16),
                    DetailsCard(
                        title: 'lastOrderSubmit'.tr(),
                        value: data.data?.details?.getEndPeriodDate() ?? ""),
                    SizedBox(height: 18),
                    CustomTextWidget(
                      "address_details1".tr(),
                      fontSize: 16,
                      fontWeight: AppFontWeight.bold,
                      fontColor: AppColor.blackModern800Light,
                    ),
                    SizedBox(height: 16),
                    DetailsCard(
                        title: 'map_space'.tr(),
                        value: data.data?.details?.getArea() ?? ""),
                    DetailsCard(
                        title: 'municipality'.tr(),
                        value: data.data?.details?.municipality ?? ""),
                    DetailsCard(
                        title: 'sub_municipality'.tr(),
                        value: data.data?.details?.subMunicipality ?? ""),
                    SizedBox(height: 18),
                    CustomTextWidget(
                      'askedenquiry'.tr(),
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
