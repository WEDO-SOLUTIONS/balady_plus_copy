import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:localize_and_translate/localize_and_translate.dart'
    show Translation;
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/utils/constants/constants.dart';
import '../../../../core/utils/utils_exports.dart'
    show
        AppColor,
        AppFontWeight,
        AppStyle,
        CommonFunctions,
        MessageType,
        UIHelper;
import '../../../home_page/presentation/widgets/home_app_bar/circle_icon.dart';
import '../../shared_feature_exports.dart'
    show CustomTextButtonWidget, CustomTextWidget;

class CustomAlertDialogWidget extends StatelessWidget {
  final Color? backgroundColor;
  final BorderRadiusGeometry? borderRadius;
  final double radius;
  final BorderSide? borderSide;
  final Color borderSideColor;
  final EdgeInsets insetPadding;
  final EdgeInsetsGeometry buttonPadding;
  final EdgeInsetsGeometry actionsPadding;
  final EdgeInsetsGeometry contentPadding;
  final Widget? title;
  final EdgeInsetsGeometry titlePadding;
  final BoxBorder? titleBorder;
  final Color titleBorderColor;
  final double titleBorderWidth;
  final MessageType titleMessageType;
  final String? titleText;
  final Color titleTextColor;
  final double titleTextSize;
  final AppFontWeight titleTextWeight;
  final Widget? content;
  final String? contentText;
  final Color contentTextColor;
  final List<Widget>? actions;
  final VoidCallback? primaryBtnPressed;
  final String? primaryBtnText;
  final VoidCallback? secondaryBtnPressed;
  final String? secondaryBtnText;
  const CustomAlertDialogWidget({
    super.key,
    this.backgroundColor,
    this.borderRadius,
    this.radius = 10.0,
    this.borderSide,
    this.borderSideColor = Colors.transparent,
    this.insetPadding = const EdgeInsets.symmetric(
      horizontal: UIHelper.mediumPadding,
    ),
    this.buttonPadding = EdgeInsets.zero,
    this.actionsPadding = EdgeInsets.zero,
    this.contentPadding = const EdgeInsets.symmetric(
      vertical: UIHelper.middlePadding,
      horizontal: UIHelper.mediumPadding,
    ),
    this.title,
    this.titlePadding = const EdgeInsets.symmetric(
      vertical: UIHelper.smallPadding,
    ),
    this.titleBorder,
    this.titleBorderColor = AppColor.gray,
    this.titleBorderWidth = 1.0,
    this.titleMessageType = MessageType.none,
    this.titleText,
    this.titleTextColor = AppColor.black,
    this.titleTextSize = 18.0,
    this.titleTextWeight = AppFontWeight.bold,
    this.content,
    this.contentText,
    this.contentTextColor = AppColor.black,
    this.actions,
    this.primaryBtnPressed,
    this.primaryBtnText,
    this.secondaryBtnPressed,
    this.secondaryBtnText,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.all(Radius.circular(radius)),
        side: borderSide ?? BorderSide(color: borderSideColor),
      ),
      insetPadding: insetPadding,
      titlePadding: EdgeInsets.zero,
      buttonPadding: buttonPadding,
      actionsPadding: actionsPadding,
      contentPadding: contentPadding,
      title: title ??
          Container(
            padding: titlePadding,
            decoration: BoxDecoration(
              border: titleBorder ??
                  Border(
                    bottom: BorderSide(
                      color: titleBorderColor,
                      width: titleBorderWidth,
                    ),
                  ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Icon(
                //   titleMessageType.icon,
                //   color: titleMessageType.color,
                //   size: 25.0,
                // ),
                if (titleMessageType != MessageType.none) ...[
                  UIHelper.horizontalSmallSpace,
                  CustomTextWidget(
                    titleMessageType.message.tr(),
                    maxLines: 20,
                    textStyle: AppStyle.mainTextStyle.copyWith(
                      color: titleTextColor,
                      fontSize: titleTextSize,
                      fontWeight: titleTextWeight.fontWeight,
                    ),
                  )
                ],
                // if (titleMessageType != MessageType.none)
                //   UIHelper.horizontalSmallSpace,
                // Icon(
                //   titleMessageType.icon,
                //   color: titleMessageType.color,
                //   size: 25.0,
                // ),
              ],
            ),
          ),
      content: content ??
          CustomTextWidget(
            contentText ?? "popUpNoMessage".tr(),
            maxLines: 10,
            textAlign: TextAlign.center,
            textStyle: AppStyle.mainTextSecondaryStyle.copyWith(
              color: contentTextColor,
              height: 1.5,
            ),
          ),
      actions: actions ??
          [
            CustomTextButtonWidget(
              onPressed:
                  primaryBtnPressed ?? () => Navigator.of(context).pop(true),
              text: primaryBtnText ?? "popUpConfirmButton".tr(),
            ),
            if (secondaryBtnPressed != null && secondaryBtnText != null)
              CustomTextButtonWidget(
                onPressed: secondaryBtnPressed!,
                text: secondaryBtnText!,
              ),
          ],
    );
  }
}

class CustomHTMLAlertDialogWidget extends StatelessWidget {
  final Color? backgroundColor;
  final BorderRadiusGeometry? borderRadius;
  final double radius;
  final BorderSide? borderSide;
  final Color borderSideColor;
  final EdgeInsets insetPadding;
  final EdgeInsetsGeometry buttonPadding;
  final EdgeInsetsGeometry actionsPadding;
  final EdgeInsetsGeometry contentPadding;
  final Widget? title;
  final EdgeInsetsGeometry titlePadding;
  final BoxBorder? titleBorder;
  final Color titleBorderColor;
  final double titleBorderWidth;
  final MessageType titleMessageType;
  final String? titleText;
  final Color titleTextColor;
  final double titleTextSize;
  final AppFontWeight titleTextWeight;
  final Widget? content;
  final String? contentText;
  final Color contentTextColor;
  final List<Widget>? actions;
  final VoidCallback? primaryBtnPressed;
  final String? primaryBtnText;
  final VoidCallback? secondaryBtnPressed;
  final String? secondaryBtnText;
  final bool? isHtml;
  const CustomHTMLAlertDialogWidget({
    super.key,
    this.backgroundColor,
    this.borderRadius,
    this.radius = 10.0,
    this.borderSide,
    this.borderSideColor = Colors.transparent,
    this.insetPadding = const EdgeInsets.symmetric(
      horizontal: UIHelper.mediumPadding,
    ),
    this.buttonPadding = EdgeInsets.zero,
    this.actionsPadding = EdgeInsets.zero,
    this.contentPadding = const EdgeInsets.symmetric(
      vertical: UIHelper.middlePadding,
      horizontal: UIHelper.mediumPadding,
    ),
    this.title,
    this.titlePadding = const EdgeInsets.symmetric(
      vertical: UIHelper.smallPadding,
    ),
    this.titleBorder,
    this.titleBorderColor = AppColor.gray,
    this.titleBorderWidth = 1.0,
    this.titleMessageType = MessageType.none,
    this.titleText,
    this.titleTextColor = AppColor.black,
    this.titleTextSize = 18.0,
    this.titleTextWeight = AppFontWeight.bold,
    this.content,
    this.contentText,
    this.contentTextColor = AppColor.black,
    this.actions,
    this.primaryBtnPressed,
    this.primaryBtnText,
    this.secondaryBtnPressed,
    this.secondaryBtnText,
    this.isHtml
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.all(Radius.circular(radius)),
        side: borderSide ?? BorderSide(color: borderSideColor),
      ),
      insetPadding: insetPadding,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 10),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pop(true);
                },
                child: Icon(Icons.close),
              ),
            ),

        if (isHtml == false)
            Flexible(
              child: content ??
                  Linkify(
                      onOpen: (link) =>
                          CommonFunctions.openBaladyWebView(link.url),
                      text:contentText ?? "",
                      softWrap: true,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                        color: contentTextColor,
                        fontFamily: Constants.appFontType,
                      ))
            ),

    if (isHtml == true)
      Flexible(
    child: content ??
        Html(
            onLinkTap: (url, attributes, element) =>
        CommonFunctions.openBaladyWebView(url),
            data:contentText ?? "",
          style: {
            "body": Style(
                fontSize: FontSize(14.0),
                fontWeight: FontWeight.w600,
                lineHeight: const LineHeight(1.4),
                textAlign: TextAlign.start,
                color: AppColor.primary500Light,
                fontFamily: Constants.appFontType),
          },
        )
    ),
          ],
        ),
      ),
      /*actions: actions ??
          [
            CustomTextButtonWidget(
              onPressed:
                  primaryBtnPressed ?? () => Navigator.of(context).pop(true),
              text: primaryBtnText ?? "close".tr(),
            ),
            if (secondaryBtnPressed != null && secondaryBtnText != null)
              CustomTextButtonWidget(
                onPressed: secondaryBtnPressed!,
                text: secondaryBtnText!,
              ),
          ],*/
    );
  }
}
