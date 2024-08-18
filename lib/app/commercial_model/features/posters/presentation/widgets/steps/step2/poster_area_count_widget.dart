import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class PosterAreaCountWidget extends StatelessWidget {
  final String? area;
  final String? count;
  const PosterAreaCountWidget({super.key, this.area, this.count});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextWidget(
          "posters_count".tr().replaceAll(
                "{}",
                ("  " + (count ?? "")),
              ),
          fontSize: 13,
          maxLines: 10,
          fontWeight: AppFontWeight.bold,
          fontColor: const Color(0xff595959),
        ),
        const SizedBox(
          height: 16,
        ),
        CustomAutoSizeTextWidget(
          "posters_area_total".tr().replaceAll(
                "{}",
                ("  " + (area ?? "")),
              ),
          maxFontSize: 13,
          minFontSize: 12,
          height: 1.4,
          maxLines: 2,
          fontWeight: AppFontWeight.bold,
          fontColor: const Color(0xff595959),
        )
      ],
    );
  }
}
