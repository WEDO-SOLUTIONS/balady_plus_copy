import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import 'package:balady_plus/app/features/map_page/data/model/excavations.dart';
import 'package:balady_plus/app/features/map_page/presentation/widgets/map_details_header.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/enums/app_font_weights.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../mvvm/point_view_model.dart';
import '../widgets/map_details_field.dart';
import '../widgets/map_details_sub_header.dart';

class MapDetailsPage extends StatelessWidget {
  final Excavations item;

  const MapDetailsPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        MapDetailsHeader(
          name: "",
          address: "",
          type: "",
          image: "",
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
                      "",
                      fontColor: AppColor.blackModern800Light,
                      fontWeight: AppFontWeight.bold,
                      textAlign: TextAlign.start,
                      fontSize: 18,
                    ),
                    CustomVerticalSpace(height: 16),
                    CustomTextWidget(
                      "",
                      fontColor: AppColor.blackModern500Light,
                      fontWeight: AppFontWeight.semiBold,
                      textAlign: TextAlign.start,
                      fontSize: 14,
                    )
                  ],
                ),
              ),
              CustomTextWidget(
                "تفاصيل الموقع",
                fontColor: AppColor.blackModern800Light,
                fontWeight: AppFontWeight.bold,
                textAlign: TextAlign.start,
                fontSize: 18,
              ),
              CustomVerticalSpace(height: 16),
              MapDetailsField(
                title: "العنوان",
                subTitle: "",
              ),
              MapDetailsField(
                title: "الأمانة",
                subTitle: "",
              ),
              MapDetailsField(
                title: "البلدية",
                subTitle: "",
              ),
              MapDetailsField(
                title: "الحي",
                subTitle: "",
              ),
              MapDetailsField(
                title: "الشارع",
                subTitle: "",
              ),
            ]),
          ),
        ),
      ],
    ));
  }
}
