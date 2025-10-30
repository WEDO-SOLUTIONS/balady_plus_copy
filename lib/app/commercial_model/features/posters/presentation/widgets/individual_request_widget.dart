import 'package:balady_plus/app/commercial_model/commercial_routes/commercial_route_names.dart';
import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/home_page/presentation/widgets/home_tag.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../features/_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import '../../../../../features/_shared_feature_/presentation/widgets/draw_icon_based_type_widget.dart';
import '../../../../../features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../data/models/poster_request_details_model.dart';

class IndividualRequestWidget extends StatelessWidget {
  final IndividualRequest item;

  const IndividualRequestWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 16, top: 16, left: 8, right: 8),
      margin: const EdgeInsets.only(bottom: 8, top: 8),
      decoration: ShapeDecoration(
        color: const Color(0xFFF3F7F7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const DrawIconBasedTypeWidget(
                    icon: IconPath.vdSummuryDesc,
                    iconSize: 20,
                  ),
                  const SizedBox(width: 4),
                  CustomTextWidget(
                    "request".tr(),
                    fontColor: AppColor.blackModern600Light,
                    fontSize: 16,
                    fontWeight: AppFontWeight.bold,
                  ),
                  const SizedBox(width: 8),
                  CustomTextWidget(
                    item.individualRequestId.toString(),
                    fontColor: AppColor.blackModern500Light,
                    fontSize: 12,
                    fontWeight: AppFontWeight.bold,
                  ),
                ],
              ),
              HomeTag(
                title: item.status?.name ?? "",
                backgroundColor: AppColor.secondary100Light,
              )
            ],
          ),
          const SizedBox(
            height: 32,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleSubTitle(
                  title: "license_no".tr(),
                  subTitle: item.licenseId.toString()),
              TitleSubTitle(
                  title: "request_date".tr(),
                  subTitle: item.creationDate.toString())
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleSubTitle(
                  title: "sub_municipality".tr(),
                  subTitle: item.subMunicipality?.name ?? ""),
              TitleSubTitle(
                  title: "invoice_no".tr(), subTitle: item.billNumber ?? "")
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // if (item.permitStartDate != null)
              TitleSubTitle(
                  title: "permit_going_date".tr(),
                  subTitle: item.permitIssuingDate ?? ""),
              if (item.permitEndDate != null)
                TitleSubTitle(
                    title: "posters_permit_end_date".tr(),
                    subTitle: item.permitEndDate ?? "")
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButtonWidget.primaryCustom(
              height: 44,
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  CommercialRouteName.posterReqeuestDetailsPage,
                  arguments: {
                    "requestNumber": item.individualRequestId.toString()
                  },
                );
              },
              text: "posters_go_to_deatails".tr(),
            ),
          )
        ],
      ),
    );
  }
}

class TitleSubTitle extends StatelessWidget {
  final String title;
  final String subTitle;

  const TitleSubTitle({super.key, required this.title, required this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextWidget(
            title,
            fontColor: AppColor.primary900Light,
            fontSize: 12,
            fontWeight: AppFontWeight.bold,
          ),
          const SizedBox(
            height: 8,
          ),
          CustomTextWidget(
            subTitle,
            fontColor: AppColor.blackModern600Light,
            fontSize: 14,
            fontWeight: AppFontWeight.bold,
          ),
        ],
      ),
    );
  }
}
