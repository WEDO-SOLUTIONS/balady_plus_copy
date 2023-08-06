import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import 'package:balady_plus/app/features/map_page/data/model/excavations.dart';
import 'package:balady_plus/app/features/map_page/presentation/widgets/map_details_header.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/enums/app_font_weights.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../widgets/map_details_field.dart';
import '../widgets/map_details_sub_header.dart';

class StationDetailsPage extends StatelessWidget {
  final (DirectoryObjectMessage item, String icon, Color color) item;

  const StationDetailsPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        MapDetailsHeader(
          name: "",
          address: "",
          type: "",
          color: item.$3,
          image: item.$2,
        ),
        Container(
          margin: const EdgeInsets.only(top: 190),
          padding: EdgeInsets.symmetric(horizontal: 16),
          decoration: ShapeDecoration(
            color: AppColor.primary50Light,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),

            // image: DecorationImage(image: AssetImage())
          ),
          child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                margin: EdgeInsets.only(
                  top: 32,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextWidget(
                      item.$1.title,
                      fontColor: AppColor.blackModern800Light,
                      fontWeight: AppFontWeight.bold,
                      textAlign: TextAlign.start,
                      fontSize: 18,
                    ),
                    CustomVerticalSpace(height: 16),
                    CustomTextWidget(
                      item.$1.subtitle,
                      fontColor: AppColor.blackModern500Light,
                      fontWeight: AppFontWeight.semiBold,
                      textAlign: TextAlign.start,
                      fontSize: 14,
                    )
                  ],
                ),
              ),
              MapDetailsSubHeader(
                firstTitle: "step2_label3".tr(),
                firstSubTitle: "station".tr(),
                secondTitle: "          ",
                secondSubTitle: "    ",
              ),
              CustomVerticalSpace(height: 24),
              /* CustomTextWidget(
                "تفاصيل العمل",
                fontColor: AppColor.blackModern800Light,
                fontWeight: AppFontWeight.bold,
                textAlign: TextAlign.start,
                fontSize: 18,
              ),
              CustomVerticalSpace(height: 16),*/
              CustomVerticalSpace(height: 16),
              CustomTextWidget(
                "qr_locatoin_details".tr(),
                fontColor: AppColor.blackModern800Light,
                fontWeight: AppFontWeight.bold,
                textAlign: TextAlign.start,
                fontSize: 18,
              ),
              CustomVerticalSpace(height: 16),
              MapDetailsField(
                title: "address".tr(),
                subTitle: item.$1.address?.addressComment ?? "",
              ),
              MapDetailsField(
                title: "bookNewAppointmentMunicipalityDropDownTitleWord".tr(),
                subTitle: "",
              ),
              MapDetailsField(
                title: "daem_sub_municiplaity".tr(),
                subTitle: "",
              ),
              MapDetailsField(
                title: "sub_street".tr(),
                subTitle: "",
              ),
              MapDetailsField(
                title: "street".tr(),
                subTitle: item.$1.address?.components.firstOrNull?.streetAddress
                        ?.street ??
                    "",
              ),
            ]),
          ),
        ),
      ],
    ));
  }
}
