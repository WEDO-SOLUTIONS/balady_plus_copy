import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../core/utils/utils_exports.dart';
import '../../_shared_feature_/shared_feature_exports.dart';
import '../../map_page/data/model/rental_details_response.dart';
import '../widgets/details_card.dart';
import '../widgets/download_foras_app.dart';
import '../widgets/header_with_divider.dart';
import '../widgets/requirment_attachments.dart';

class TempRentalPage extends StatefulWidget {
  const TempRentalPage({
    Key? key,
  }) : super(key: key);

  @override
  State<TempRentalPage> createState() => _TempRentalPageState();
}

class _TempRentalPageState extends State<TempRentalPage> {
  late RentalDetailsResponse data;
  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context)!.settings.arguments as RentalDetailsResponse;

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
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Padding(
                  padding: EdgeInsetsDirectional.only(top: 34, start: 24),
                  child: Icon(
                    Icons.close,
                    size: 24,
                    color: AppColor.blackModern50Light,
                  ),
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
                      firstTitle: "invest_type".tr(),
                      firstValue: "temo_rental".tr(),
                      firstIconPath: IconPath.moneyTime,
                      secondTitle: "invest_price".tr(),
                      secondValue: getDailyCost(),
                    ),
                    CustomTextWidget(
                      "invest_detail".tr(),
                      fontSize: 16,
                      fontWeight: AppFontWeight.bold,
                      fontColor: AppColor.blackModern800Light,
                    ),
                    SizedBox(height: 16),
                    DetailsCard(
                        title: "invest_title".tr(),
                        value: data.data?.details?.siteDescription ?? ""),
                    DetailsCard(
                        title: "location_number".tr(),
                        value: data.data?.details?.id ?? ""),
                    DetailsCard(
                        title: 'orgniztion_furas'.tr(),
                        value:
                            data.data?.details?.getEntityORMinstryName() ?? ""),
                    DetailsCard(
                        title: 'lbl_service_activity_hint1'.tr(),
                        value: data.data?.details?.getActivityName() ?? ""),
                    DetailsCard(
                      title: "meter_price".tr(),
                      value: data.data?.details?.getPrice() ?? "",
                      note: "details_note".tr(),
                    ),
                    SizedBox(height: 18),
                    CustomTextWidget(
                      "location_details".tr(),
                      fontSize: 16,
                      fontWeight: AppFontWeight.bold,
                      fontColor: AppColor.blackModern800Light,
                    ),
                    SizedBox(height: 16),
                    DetailsCard(
                        title: "map_space".tr(),
                        value: data.data?.details?.getArea() ?? ""),
                    DetailsCard(
                        title: 'municipality'.tr(),
                        value: data.data?.details?.municipality ?? ""),
                    DetailsCard(
                        title: 'sub_municipality'.tr(),
                        value: data.data?.details?.subMunicipality ?? ""),
                    SizedBox(height: 18),
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
