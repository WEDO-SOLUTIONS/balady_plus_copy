import 'package:balady_plus/app/core/utils/constants/paths/image_paths.dart';
import 'package:balady_plus/app/core/utils/enums/date_form.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import 'package:balady_plus/app/features/map_page/data/model/excavations.dart';
import 'package:balady_plus/app/features/map_page/presentation/widgets/map_details_header.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/enums/app_font_weights.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../mvvm/point_view_model.dart';
import '../widgets/map_details_field.dart';
import '../widgets/map_details_sub_header.dart';

class DiggingMapDetailsPage extends StatelessWidget {
  final Excavations item;

  const DiggingMapDetailsPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        MapDetailsHeader(
          name: "",
          address: "",
          type: "",
          image: ImagePath.diggingMapCard,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomTextWidget(
                          item.siteName ?? "",
                          fontColor: AppColor.blackModern800Light,
                          fontWeight: AppFontWeight.bold,
                          textAlign: TextAlign.start,
                          fontSize: 18,
                        ),
                        CustomTextWidget(
                          item.streetCloseType ?? "",
                          fontColor: Color(0xFFF51C1C),
                          fontWeight: AppFontWeight.bold,
                          textAlign: TextAlign.start,
                          fontSize: 12,
                        ),
                      ],
                    ),
                    CustomVerticalSpace(height: 16),
                    CustomTextWidget(
                      item.nameAr ?? "",
                      fontColor: AppColor.blackModern500Light,
                      fontWeight: AppFontWeight.semiBold,
                      textAlign: TextAlign.start,
                      fontSize: 14,
                    )
                  ],
                ),
              ),
              MapDetailsSubHeader(
                firstTitle: "digging_start_date".tr(),
                firstSubTitle: item.worksStartDate != null
                    ? DateFormat.yMd().format(item.worksStartDate!)
                    : "",
                secondTitle: "digging_end_date".tr(),
                secondSubTitle: item.worksEndDate != null
                    ? DateFormat.yMd().format(item.worksEndDate!)
                    : "",
              ),
              CustomVerticalSpace(height: 16),
              CustomTextWidget(
                "map_overview".tr(),
                fontColor: AppColor.blackModern800Light,
                fontWeight: AppFontWeight.bold,
                textAlign: TextAlign.start,
                fontSize: 18,
              ),
              CustomVerticalSpace(height: 16),
              MapDetailsField(
                title: "map_address".tr(),
                subTitle: item.getAddress(),
              ),
              MapDetailsField(
                title: "map_digging_status".tr(),
                subTitle: item.status ?? "",
                showMargin: false,
                showBottomRadius: false,
              ),
              MapDetailsField(
                title: "map_digging_path_length".tr(),
                subTitle: item.pathLength.toString(),
                showMargin: false,
                showTopRadius: false,
              ),
              MapDetailsField(
                title: "map_digging_works_nature".tr(),
                subTitle: item.workNature ?? "",
              ),
              MapDetailsField(
                title: "map_digging_project_name".tr(),
                subTitle: item.projectName ?? "",
                showMargin: false,
                showBottomRadius: false,
              ),
              MapDetailsField(
                title: "map_digging_contractor_name".tr(),
                subTitle: item.contractorName ?? "",
                showMargin: false,
                //showBottomRadius: false,
                showTopRadius: false,
              ),
              /* MapDetailsField(
                title: "map_digging_permit_number".tr(),
                subTitle: item.pe,
                showMargin: false,
                showBottomRadius: false,
                showTopRadius: false,
              ),
              MapDetailsField(
                title: "map_permit_start_end_date".tr(),
                subTitle: "",
                showMargin: false,
                showTopRadius: false,
              ),*/
            ]),
          ),
        ),
      ],
    ));
  }
}
