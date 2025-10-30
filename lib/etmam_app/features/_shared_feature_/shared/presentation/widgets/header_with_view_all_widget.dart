import 'package:flutter/material.dart';

import '../../../../../core/utils/utils_exports.dart'
    show
        AppColor,
        AppColorsTheme,
        AppFontWeight,
        IconPath,
        StringIconChecker,
        trans;
import '../../shared_feature_exports.dart'
    show
        CustomHorizontalSpace,
        CustomSvgIconWidget,
        CustomTextButtonWithIconWidget,
        CustomTextWidget;

class HeaderWithViewAllWidget extends StatelessWidget {
  final String headerText;
  final String? viewBtnText;
  final VoidCallback? btnPressed;
  final Color? btnColor;
  final Color headerTextColor;
  final bool showAllButton;
  final double headerTextSize;
  final AppFontWeight headerFontWeight;
  final EdgeInsetsGeometry? margin;

  const HeaderWithViewAllWidget(
      {Key? key,
      required this.headerText,
      this.btnPressed,
      this.showAllButton = true,
      this.viewBtnText,
      this.btnColor,
      this.headerTextColor = AppColor.hunterGreen,
      this.headerTextSize = 18,
      this.headerFontWeight = AppFontWeight.w600,
      this.margin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ??
          const EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // reports
          Expanded(
            child: CustomTextWidget(
              headerText,
              fontSize: headerTextSize,
              fontColor: headerTextColor,
              fontWeight: headerFontWeight,
            ),
          ),
          // show all button
          Visibility(
            visible: showAllButton,
            child: CustomTextButtonWithIconWidget(
              btnAlignment: AlignmentDirectional.centerEnd,
              btnPressed: btnPressed ?? () {},
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: AppColor.black,
                size: 16.0,
              ),
              btnText: viewBtnText ?? trans("show_all"),
              spaceBetweenTextAndIcon: 0,
              btnTextColor: btnColor ?? AppColor.black500,
              btnTextSize: 13.0,
              btnTextWeight: AppFontWeight.medium,
            ),
          ),
        ],
      ),
    );
  }
}

class DetailsInfoWithImg extends StatelessWidget {
  final String img;
  final String title;
  final Color textColor;
  final double iconHeight;
  final double iconWidth;

  const DetailsInfoWithImg(
      {Key? key,
      required this.img,
      required this.title,
      this.iconHeight = 16,
      this.iconWidth = 16,
      this.textColor = AppColor.black500})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (img.isSvgIcon)
          Container(
            margin: const EdgeInsets.only(top: 4),
            child: CustomSvgIconWidget(
              img,
              iconHeight: iconHeight,
              iconWidth: iconWidth,
              iconColor: textColor,
            ),
          ),
        if (img.isImgIcon)
          Container(
            margin: const EdgeInsets.only(top: 4),
            child: Image.asset(
              img,
              height: iconHeight,
              width: iconWidth,
              color: textColor,
            ),
          ),
        const CustomHorizontalSpace(width: 5),
        Flexible(
          child: Container(
            margin: const EdgeInsets.only(top: 2.2),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: CustomTextWidget(
                title,
                fontSize: 13.0,
                fontWeight: AppFontWeight.medium,
                fontColor: textColor,
                maxLines: 1,
                textOverflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class HeaderWithDescription extends StatelessWidget {
  final String header;
  final String details;
  final Color headerColor;
  final Color detailsColor;

  const HeaderWithDescription(
      {Key? key,
      required this.header,
      required this.details,
      this.detailsColor = AppColor.black600,
      this.headerColor = AppColor.primary900})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextWidget(
          header,
          fontSize: 10,
          fontWeight: AppFontWeight.bold,
          fontColor: headerColor,
          maxLines: 1,
          textAlign: TextAlign.start,
        ),
        const SizedBox(height: 4),
        CustomTextWidget(
          details,
          fontSize: 12,
          fontWeight: AppFontWeight.bold,
          fontColor: detailsColor,
          maxLines: 3,
          textOverflow: TextOverflow.ellipsis,
          textAlign: TextAlign.start,
        ),
      ],
    );
  }
}
