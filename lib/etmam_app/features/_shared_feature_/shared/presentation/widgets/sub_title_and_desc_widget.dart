import 'package:flutter/material.dart';

import '../../../../../core/utils/utils_exports.dart'
    show AppColor, AppFontWeight, IconPath;
import '../../shared_feature_exports.dart'
    show
        CustomHorizontalSpace,
        CustomSvgIconWidget,
        CustomTextWidget,
        CustomVerticalSpace;

class SubTitleAndDescWidget extends StatelessWidget {
  final String subTitle;
  final String? desc;
  final double verticalSpace;
  final VoidCallback? descPressedAction;
  final String? subTitleIcon;

  const SubTitleAndDescWidget(
      {Key? key,
      required this.subTitle,
      this.desc,
      this.verticalSpace = 24,
      this.descPressedAction,
      this.subTitleIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // CustomTextWidget(
        //   subTitle,
        //   fontColor: AppColor.baladyDarkGreen2,
        //   fontWeight: AppFontWeight.bold,
        //   fontSize: 13,
        //   textAlign: TextAlign.start,
        // ),
        subTitleWidget(
          subTitle: subTitle,
          icon: subTitleIcon,
        ),
        if (desc != null) ...[
          const CustomVerticalSpace(height: 8),
          Container(
            margin: EdgeInsetsDirectional.only(start: 16),
            child: InkWell(
              onTap: descPressedAction ?? () {},
              child: CustomTextWidget(
                desc ?? "",
                fontColor: AppColor.black500,
                fontWeight: AppFontWeight.regular,
                fontSize: 16,
                textAlign: TextAlign.start,
              ),
            ),
          ),
        ],
        CustomVerticalSpace(height: verticalSpace)
      ],
    );
  }
}

class SubTitleAndWidget extends StatelessWidget {
  final String subTitle;
  final Widget? widget;
  final double verticalSpace;
  final String? subTitleIcon;

  const SubTitleAndWidget(
      {Key? key,
      required this.subTitle,
      this.widget,
      this.verticalSpace = 24,
      this.subTitleIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // CustomTextWidget(
        //   subTitle,
        //   fontColor: AppColor.baladyDarkGreen2,
        //   fontWeight: AppFontWeight.bold,
        //   fontSize: 13,
        //   textAlign: TextAlign.start,
        // ),
        subTitleWidget(
          subTitle: subTitle,
          icon: subTitleIcon,
        ),
        if (widget != null) ...[
          const CustomVerticalSpace(height: 8),
          Container(
              margin: EdgeInsetsDirectional.only(start: 16),
              child: widget ?? const Center())
        ],
        CustomVerticalSpace(height: verticalSpace)
      ],
    );
  }
}

class subTitleWidget extends StatelessWidget {
  final String subTitle;
  final String? icon;

  const subTitleWidget({Key? key, required this.subTitle, this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomSvgIconWidget(
          icon ?? IconPath.aboutOfficeIcon,
          iconSize: 14,
        ),
        CustomHorizontalSpace(width: 4),
        Expanded(
          child: CustomTextWidget(
            subTitle,
            fontColor: AppColor.baladyDarkGreen2,
            fontWeight: AppFontWeight.bold,
            fontSize: 13,
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }
}
