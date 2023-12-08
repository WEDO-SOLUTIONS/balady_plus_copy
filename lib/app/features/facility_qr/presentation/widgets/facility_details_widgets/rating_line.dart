import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/constants.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart'
    show CustomAutoSizeTextWidget, CustomHorizontalSpace, CustomTextWidget;

class RatingLine extends StatelessWidget {
  final String name;
  final double rating;

  const RatingLine({Key? key, required this.name, required this.rating})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Row(
              children: [
                Expanded(
                  child: CustomAutoSizeTextWidget(
                    name,
                    fontColor: AppColor.blackModern600Light,
                    fontWeight: AppFontWeight.bold,
                    maxFontSize: 14,
                    minFontSize: 12,
                    textAlign: TextAlign.start,
                    maxLines: 1,
                  ),
                )
              ],
            ),
          ),
          Expanded(
            flex: 6,
            child: SizedBox(
              height: 4,
              child: LinearProgressIndicator(
                backgroundColor: AppColor.black200,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColor.baladyDarkGreen2,
                ),
                value: rating / 5,
              ),
            ),
          ),
          const CustomHorizontalSpace(width: 10),
          Expanded(
            flex: 1,
            child: CustomTextWidget(
              rating.toString(),
              fontColor: AppColor.black500,
              fontWeight: AppFontWeight.bold,
              fontSize: 11,
              fontFamily: Constants.lucidaGrandFontType, //MM
              textAlign: TextAlign.start,
            ),
          )
        ],
      ),
    );
  }
}
