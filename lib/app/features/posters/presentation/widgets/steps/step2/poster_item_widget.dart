import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/features/posters/presentation/widgets/steps/step2/field_data.dart';
import 'package:balady_plus/app/features/vd/presentation/widgets/summery_widgets/field_data.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../domain/entities/poster_item.dart';

class PosterItemWidget extends StatelessWidget {
  final PosterItem? item;
  final int index;
  const PosterItemWidget({super.key, this.item, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(children: [
            CustomTextWidget(
              "poster_index".tr().replaceAll("{}", index.toString()),
              fontColor: AppColor.blackModern600Light,
              fontSize: 18,
              fontWeight: AppFontWeight.bold,
            ),
            Row(
              children: [],
            )
          ]),
          FieldData(
              title: "poster_type".tr(),
              subTitle: item?.posterType?.name ?? ""),
          const CustomVerticalSpace(height: 4),
          FieldData(title: "poster_name".tr(), subTitle: item?.name ?? ""),
          const CustomVerticalSpace(height: 4),
          FieldDataCustomData(title: "poster_dim".tr(), sub: [
            Row(
              children: [
                PosterText(
                  text: "",
                )
              ],
            )
          ])
        ],
      ),
    );
  }
}

class PosterText extends StatelessWidget {
  final String text;
  const PosterText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return CustomTextWidget(
      text,
      fontSize: 16,
      fontWeight: AppFontWeight.bold,
      fontColor: AppColor.blackModern600Light,
    );
  }
}
