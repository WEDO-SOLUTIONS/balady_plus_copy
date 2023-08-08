import 'package:flutter/material.dart';

import '../../../../../core/utils/utils_exports.dart'
    show AppColor, AppColorsTheme, AppFontWeight, PrimaryIcons;
import '../../shared_feature_exports.dart'
    show
        CustomHorizontalSpace,
        CustomVerticalSpace,
        CustomSvgIconWidget,
        CustomTextWidget;

/*class SectionTitleWidget extends StatelessWidget {
  final String title;
  final PrimaryIcons? primaryIcon;
  final String? desc;
  final double bottomVerticalSpace;

  const SectionTitleWidget(
      {Key? key,
      required this.title,
      this.primaryIcon,
      this.desc,
      this.bottomVerticalSpace = 20})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SectionIconWidget(
              primaryIcons: primaryIcon ?? PrimaryIcons.none,
            ),
            const CustomHorizontalSpace(width: 8),
            Expanded(
              child: CustomTextWidget(
                title,
                fontColor: AppColor.hunterGreen,
                fontWeight: AppFontWeight.w600,
                fontSize: 16,
                textAlign: TextAlign.start,
              ),
            )
          ],
        ),
        if (desc != null) ...[
          const CustomVerticalSpace(height: 8),
          Container(
            margin: const EdgeInsetsDirectional.only(start: 40),
            child: CustomTextWidget(
              desc ?? "",
              fontColor: AppColor.bottomNavigationShadow,
              fontWeight: AppFontWeight.regular,
              fontSize: 12,
              textAlign: TextAlign.start,
            ),
          ),
        ],
        CustomVerticalSpace(height: bottomVerticalSpace)
      ],
    );
  }
}*/

class SectionIconWidget extends StatelessWidget {
  final PrimaryIcons primaryIcons;

  const SectionIconWidget({Key? key, required this.primaryIcons})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 32,
        width: 32,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            color: AppColorsTheme.primary100),
        child: Center(
          child: CustomSvgIconWidget(
            primaryIcons.icon,
            iconHeight: primaryIcons.iconHeight,
            iconWidth: primaryIcons.iconWidth,
            iconColor: AppColorsTheme.primary700,
          ),
        ));
  }
}

class SectionTitleWidget extends StatelessWidget {
  final String title;
  final PrimaryIcons? primaryIcon;
  final String? desc;
  final double bottomVerticalSpace;

  const SectionTitleWidget(
      {Key? key,
      required this.title,
      this.primaryIcon,
      this.desc,
      this.bottomVerticalSpace = 20})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // CustomSvgIconWidget(
            //   primaryIcon?.icon ?? PrimaryIcons.none.icon,
            //   iconHeight: 25,
            //   iconWidth: 24,
            // ),
            // const CustomHorizontalSpace(width: 10),
            Expanded(
              child: CustomTextWidget(
                title,
                fontColor: AppColor.black700,
                fontWeight: AppFontWeight.bold,
                fontSize: 20,
                textAlign: TextAlign.start,
              ),
            )
          ],
        ),
        if (desc != null) ...[
          const CustomVerticalSpace(height: 8),
          Container(
            margin: const EdgeInsetsDirectional.only(start: 40),
            child: CustomTextWidget(
              desc ?? "",
              fontColor: AppColor.black500,
              fontWeight: AppFontWeight.bold,
              fontSize: 14,
              textAlign: TextAlign.start,
            ),
          ),
        ],
        CustomVerticalSpace(height: bottomVerticalSpace)
      ],
    );
  }
}
