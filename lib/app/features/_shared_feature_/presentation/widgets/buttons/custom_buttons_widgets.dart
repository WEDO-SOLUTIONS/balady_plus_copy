import 'package:balady_plus/app/core/utils/constants/keys/general_keys.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/enums/enums.dart';
import '../../../../../core/utils/utils_exports.dart' show AppColor, AppFontWeight, AppStyle, CommonFunctions;
import '../../../shared_feature_exports.dart'
    show ClickableWidget, CustomHorizontalSpace, CustomTextWidget, DrawIconBasedTypeWidget;

class CustomTextButtonWidget extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;

  final Size? btnSize;
  final double btnHeight;
  final double? btnWidth;
  final Color? btnEffectColor;
  final AlignmentGeometry? btnAlignment;

  final VoidCallback? onPressed;

  final Color btnTextColor;
  final double btnTextSize;

  final AppFontWeight btnTextWeight;

  final bool haveUnderline;
  final Color? underlineColor;

  const CustomTextButtonWidget({
    super.key,
    required this.text,
    this.textStyle,
    this.btnSize,
    this.btnHeight = 50.0,
    this.btnWidth,
    this.btnEffectColor,
    this.btnAlignment,
    this.onPressed,
    this.btnTextColor = AppColor.spruce,
    this.btnTextWeight = AppFontWeight.bold,
    this.btnTextSize = 18.0,
    this.haveUnderline = false,
    this.underlineColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        // Effect color when pressed on button
        foregroundColor: btnEffectColor ?? Colors.transparent,
        // splashFactory: InkRipple.splashFactory,
        splashFactory: InkSplash.splashFactory,
        // splashFactory: btnEffectColor != null
        //     ? InkSplash.splashFactory
        //     : NoSplash.splashFactory,
        padding: EdgeInsets.zero,
        alignment: btnAlignment ?? Alignment.center,
        minimumSize: btnSize ?? (btnWidth != null ? Size(btnWidth!, btnHeight) : null),
      ),
      child: CustomTextWidget(
        text,
        textStyle: textStyle,
        fontColor: btnTextColor,
        fontWeight: btnTextWeight,
        fontSize: btnTextSize,
        textDecoration: haveUnderline ? TextDecoration.underline : TextDecoration.none,
        textDecorationColor: underlineColor,
      ),
    );
  }
}

class CustomTextIconButtonWidget extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;

  final Size? btnSize;
  final double btnHeight;
  final double? btnWidth;
  final Color? btnEffectColor;
  final MainAxisAlignment? btnAlignment;

  final Widget icon;
  final double iconTextTweenSpace;
  final AlignmentGeometry? iconAlignment;

  final VoidCallback? onPressed;
  const CustomTextIconButtonWidget({
    super.key,
    required this.text,
    this.textStyle,
    this.btnSize,
    this.btnHeight = 50.0,
    this.btnWidth,
    this.btnEffectColor,
    this.btnAlignment,
    required this.icon,
    this.iconTextTweenSpace = 8.0,
    this.iconAlignment,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        // Effect color when pressed on button
        foregroundColor: btnEffectColor ?? Colors.transparent,
        splashFactory: InkSplash.splashFactory,
        // splashFactory: btnEffectColor != null
        //     ? InkSplash.splashFactory
        //     : NoSplash.splashFactory,
        padding: EdgeInsets.zero,
        // alignment: btnAlignment,
        minimumSize: btnSize ?? (btnWidth != null ? Size(btnWidth!, btnHeight) : null),
      ),
      child: SizedBox(
        height: btnSize?.height ?? btnHeight,
        width: btnSize?.width ?? btnWidth,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: btnAlignment ?? MainAxisAlignment.center,
          children: [
            // Icon Widget
            if (atStart) ...[
              RotatedBox(quarterTurns: CommonFunctions.isAppAR ? 0 : 2, child: icon),
              CustomHorizontalSpace(width: iconTextTweenSpace),
            ],
            // Text
            CustomTextWidget(text, textStyle: textStyle ?? AppStyle.textButtonStyle),
            // Icon Widget
            if (atEnd) ...[
              CustomHorizontalSpace(width: iconTextTweenSpace),
              RotatedBox(quarterTurns: CommonFunctions.isAppAR ? 0 : 2, child: icon),
            ],
          ],
        ),
      ),
    );
  }

  AlignmentGeometry get iconPosition => iconAlignment ?? AlignmentDirectional.centerStart;
  bool get atStart => iconPosition == AlignmentDirectional.centerStart;
  bool get atEnd => iconPosition == AlignmentDirectional.centerEnd;
}

class CustomElevatedButtonWidget extends StatelessWidget {
  final Color? btnColor;
  final Color? btnShadowColor;
  final double btnHeight;
  final double? btnWidth;
  final double btnRadius;
  final Color? btnBorderColor;
  final double btnBorderWidth;
  final double btnElevation;
  final AlignmentGeometry? btnAlignment;
  final EdgeInsetsGeometry? btnPadding;
  final EdgeInsetsGeometry? btnMargin;
  final int? maxLines;
  final bool loading;

  /// It can be Widget or String
  final Object? text;
  final TextStyle? textStyle;

  final VoidCallback? onPressed;
  const CustomElevatedButtonWidget({
    super.key,
    this.btnColor,
    this.btnShadowColor,
    this.btnHeight = 60.0,
    this.btnWidth,
    this.btnRadius = 8.0,
    this.btnBorderColor,
    this.btnBorderWidth = 1.0,
    this.btnElevation = 2.0,
    this.btnAlignment,
    this.btnPadding,
    this.btnMargin,
    required this.text,
    this.textStyle,
    this.onPressed,
    this.loading = false,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: btnMargin ?? EdgeInsets.zero,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: btnColor ?? AppColor.blue,
          padding: btnPadding ?? EdgeInsets.zero,
          backgroundColor: btnColor ?? AppColor.blue,
          // shadowColor: Colors.pink,
          shadowColor: btnShadowColor ?? Colors.transparent,
          alignment: btnAlignment ?? Alignment.center,
          elevation: btnElevation,
          minimumSize: Size(btnWidth ?? double.infinity, btnHeight),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(btnRadius)),
          side: BorderSide(width: btnBorderWidth, color: btnBorderColor ?? btnColor ?? AppColor.blue),
        ),
        child: loading
            ? Center(child: CircularProgressIndicator(color: textStyle?.color))
            : isTextWidget
            ? text as Widget
            : isTextString
            ? CustomTextWidget(
                text as String,
                textAlign: TextAlign.center,
                maxLines: maxLines,
                textStyle: textStyle ?? AppStyle.elevatedButtonStyle,
              )
            : const SizedBox(),
      ),
    );
  }

  bool get isTextWidget => text != null && text is Widget;
  bool get isTextString => text != null && text is String;
}

class EnhancedCustomElevatedButtonWidget extends StatelessWidget {
  final VoidCallback? btnPressed;
  final Color btnColor;
  final double btnHeight;
  final double btnWidth;
  final double btnRadius;
  final Color? btnBorderColor;
  final double btnBorderWidth;
  final AlignmentGeometry btnAlignment;
  final String btnText;
  final Color btnTextColor;
  final AppFontWeight btnTextWeight;
  final double btnTextSize;
  final bool btnTextUnderline;
  final Color? btnTextUnderlineColor;
  final double spaceBetweenTextAndIcon;
  final Widget? icon;
  final ButtonIconPosition buttonIconPosition;
  final double horizontalMargin;
  final double verticalMargin;

  const EnhancedCustomElevatedButtonWidget({
    super.key,
    required this.btnPressed,
    this.btnColor = AppColor.primary900Light,
    this.btnHeight = 65.0,
    this.btnWidth = double.infinity,
    this.btnRadius = 2,
    this.btnBorderColor,
    this.btnBorderWidth = 2.0,
    this.btnAlignment = Alignment.center,
    required this.btnText,
    this.buttonIconPosition = ButtonIconPosition.right,
    this.btnTextColor = AppColor.white,
    this.btnTextWeight = AppFontWeight.medium,
    this.btnTextSize = 18.0,
    this.btnTextUnderline = false,
    this.btnTextUnderlineColor,
    this.spaceBetweenTextAndIcon = 4.0,
    this.icon,
    this.horizontalMargin = 0,
    this.verticalMargin = 0,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: btnPressed,
      child: Container(
        height: btnHeight,
        width: btnWidth,
        alignment: btnAlignment,
        margin: EdgeInsets.symmetric(horizontal: horizontalMargin, vertical: verticalMargin),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(btnRadius)),
          border: Border.all(width: btnBorderWidth, color: btnBorderColor ?? btnColor),
          color: btnColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null && buttonIconPosition == ButtonIconPosition.right) icon ?? Container(),
            if (icon != null && buttonIconPosition == ButtonIconPosition.right)
              CustomHorizontalSpace(width: spaceBetweenTextAndIcon),
            CustomTextWidget(
              btnText,
              fontColor: btnTextColor,
              fontWeight: btnTextWeight,
              fontSize: btnTextSize,
              textDecoration: btnTextUnderline ? TextDecoration.underline : TextDecoration.none,
              textDecorationColor: btnTextUnderlineColor,
            ),
            if (icon != null && buttonIconPosition == ButtonIconPosition.left)
              CustomHorizontalSpace(width: spaceBetweenTextAndIcon),
            if (icon != null && buttonIconPosition == ButtonIconPosition.left) icon ?? Container(),
          ],
        ),
      ),
    );
  }
}

class CustomElevatedStackIconButtonWidget extends StatelessWidget {
  final Color? btnColor;
  final Color? btnShadowColor;
  final double btnHeight;
  final double? btnWidth;
  final double btnRadius;
  final Color? btnBorderColor;
  final double btnBorderWidth;
  final double btnElevation;
  final AlignmentGeometry? btnAlignment;
  final EdgeInsetsGeometry? btnPadding;
  final EdgeInsetsGeometry? btnMargin;

  /// It can be Widget or String
  final Object? text;
  final TextStyle? textStyle;

  final Widget icon;
  final AlignmentGeometry? iconAlignment;

  final VoidCallback? onPressed;
  const CustomElevatedStackIconButtonWidget({
    super.key,
    this.btnColor,
    this.btnShadowColor,
    this.btnHeight = 60.0,
    this.btnWidth,
    this.btnRadius = 8.0,
    this.btnBorderColor,
    this.btnBorderWidth = 1.0,
    this.btnElevation = 2.0,
    this.btnAlignment,
    this.btnPadding,
    this.btnMargin,
    required this.text,
    this.textStyle,
    required this.icon,
    this.iconAlignment,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: btnMargin ?? EdgeInsets.zero,
      child: SizedBox(
        width: btnWidth,
        height: btnHeight,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Button with Text widget
            ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                foregroundColor: btnColor ?? AppColor.blue,
                padding: btnPadding ?? EdgeInsets.zero,
                backgroundColor: btnColor ?? AppColor.blue,
                // shadowColor: Colors.pink,
                shadowColor: btnShadowColor ?? Colors.transparent,
                alignment: btnAlignment ?? Alignment.center,
                elevation: btnElevation,
                minimumSize: Size(btnWidth ?? double.infinity, btnHeight),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(btnRadius)),
                side: BorderSide(width: btnBorderWidth, color: btnBorderColor ?? btnColor ?? AppColor.blue),
              ),
              child: isTextWidget
                  ? text as Widget
                  : isTextString
                  ? CustomTextWidget(
                      text as String,
                      textAlign: TextAlign.center,
                      textStyle: textStyle ?? AppStyle.elevatedButtonStyle,
                    )
                  : const SizedBox(),
            ),
            // Icon Widget
            Align(alignment: iconAlignment ?? AlignmentDirectional.centerStart, child: icon),
          ],
        ),
      ),
    );
  }

  bool get isTextWidget => text != null && text is Widget;
  bool get isTextString => text != null && text is String;
}

class CustomElevatedIconButtonWidget extends StatelessWidget {
  final Color? btnColor;
  final Color? btnShadowColor;
  final double btnHeight;
  final double? btnWidth;
  final double btnRadius;
  final Color? btnBorderColor;
  final double btnBorderWidth;
  final double btnElevation;
  final MainAxisAlignment? btnAlignment;
  final EdgeInsetsGeometry? btnPadding;
  final EdgeInsetsGeometry? btnMargin;

  /// It can be Widget or String
  final Object? text;
  final TextStyle? textStyle;

  final Widget icon;
  final double iconTextTweenSpace;
  final AlignmentGeometry? iconAlignment;

  final VoidCallback? onPressed;
  const CustomElevatedIconButtonWidget({
    super.key,
    this.btnColor,
    this.btnShadowColor,
    this.btnHeight = 60.0,
    this.btnWidth,
    this.btnRadius = 8.0,
    this.btnBorderColor,
    this.btnBorderWidth = 1.0,
    this.btnElevation = 2.0,
    this.btnAlignment,
    this.btnPadding,
    this.btnMargin,
    required this.text,
    this.textStyle,
    required this.icon,
    this.iconTextTweenSpace = 8.0,
    this.iconAlignment,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: btnMargin ?? EdgeInsets.zero,
      child: SizedBox(
        width: btnWidth,
        height: btnHeight,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: btnColor ?? AppColor.blue,
            padding: btnPadding ?? EdgeInsets.zero,
            // foreground
            // onPrimary: Colors.purple,
            // shadowColor: Colors.pink,
            shadowColor: btnShadowColor ?? Colors.transparent,
            // alignment: btnAlignment ?? MainAxisAlignment.center,
            elevation: btnElevation,
            minimumSize: Size(btnWidth ?? double.infinity, btnHeight),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(btnRadius)),
            side: BorderSide(width: btnBorderWidth, color: btnBorderColor ?? btnColor ?? AppColor.blue),
          ),
          child: Row(
            mainAxisAlignment: btnAlignment ?? MainAxisAlignment.center,
            children: [
              // Icon Widget
              if (atStart) ...[icon, CustomHorizontalSpace(width: iconTextTweenSpace)],
              // Text
              if (isTextWidget)
                text as Widget
              else if (isTextString)
                CustomTextWidget(
                  text as String,
                  textAlign: TextAlign.center,
                  textStyle: textStyle ?? AppStyle.elevatedButtonStyle,
                )
              else
                const SizedBox(),
              // Icon Widget
              if (atEnd) ...[CustomHorizontalSpace(width: iconTextTweenSpace), icon],
            ],
          ),
        ),
      ),
    );
  }

  bool get isTextWidget => text != null && text is Widget;
  bool get isTextString => text != null && text is String;
  AlignmentGeometry get iconPosition => iconAlignment ?? AlignmentDirectional.centerStart;
  bool get atStart => iconPosition == AlignmentDirectional.centerStart;
  bool get atEnd => iconPosition == AlignmentDirectional.centerEnd;
}

class CustomIconButtonWidget extends StatelessWidget {
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderRadius;
  final double borderWidth;
  final double btnWidth;
  final double btnHeight;
  final double verticalPadding;
  final double horizontalPadding;

  final dynamic icon;
  final double iconSize;
  final Color? iconColor;

  final VoidCallback? onPressed;
  const CustomIconButtonWidget({
    super.key,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius = 4.0,
    this.borderWidth = 1.0,
    this.btnHeight = 28.0,
    this.btnWidth = 28.0,
    this.verticalPadding = 0.0,
    this.horizontalPadding = 0.0,
    required this.icon,
    this.iconSize = 18.0,
    this.iconColor,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: btnWidth,
      height: btnHeight,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: borderColor ?? Colors.transparent, width: borderWidth),
      ),
      child: ClickableWidget(
        onPressed: onPressed,
        effectColor: Colors.transparent,
        child: DrawIconBasedTypeWidget(icon: icon, iconColor: iconColor, iconSize: iconSize),
      ),
    );
  }
}

class CustomUnderlineTextdButtonWidget extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  final double underlineWidth;
  final Color? underlineColor;

  final VoidCallback? onPressed;
  const CustomUnderlineTextdButtonWidget({
    super.key,
    required this.text,
    this.textStyle,
    this.underlineWidth = 1.5,
    this.underlineColor,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ClickableWidget(
      onPressed: onPressed,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: underlineWidth,
              color: underlineColor ?? AppStyle.textButtonStyle.color ?? Colors.black,
            ),
          ),
        ),
        child: CustomTextWidget(text, textStyle: textStyle ?? AppStyle.textButtonStyle),
      ),
    );
  }
}

class CustomTextButtonWithIconWidget extends StatelessWidget {
  final Color? btnBackgroundColor;
  final Color? btnEffectColor;
  final AlignmentGeometry? btnAlignment;
  final VoidCallback? btnPressed;
  final Widget icon;
  final ButtonIconPosition buttonIconPosition;
  final MainAxisAlignment mainAxisAlignment;
  final double spaceBetweenTextAndIcon;
  final String btnText;
  final Color btnTextColor;
  final AppFontWeight btnTextWeight;
  final double btnTextSize;
  final bool textUnderline;
  final Color? textUnderlineColor;
  final EdgeInsetsGeometry padding;
  final MainAxisSize mainAxisSize;

  const CustomTextButtonWithIconWidget({
    super.key,
    this.btnBackgroundColor,
    this.btnEffectColor,
    this.btnAlignment,
    required this.btnPressed,
    required this.icon,
    this.buttonIconPosition = ButtonIconPosition.left,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.spaceBetweenTextAndIcon = 4.0,
    required this.btnText,
    this.btnTextColor = AppColor.spruce,
    this.btnTextWeight = AppFontWeight.bold,
    this.btnTextSize = 18.0,
    this.textUnderline = false,
    this.textUnderlineColor,
    this.padding = EdgeInsets.zero,
    this.mainAxisSize = MainAxisSize.max,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: btnPressed,
      style: TextButton.styleFrom(
        foregroundColor: btnEffectColor ?? btnBackgroundColor ?? btnTextColor,
        padding: padding,
        backgroundColor: btnBackgroundColor,
        alignment: btnAlignment,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        mainAxisSize: mainAxisSize,
        children: [
          if (buttonIconPosition == ButtonIconPosition.right) icon,
          if (buttonIconPosition == ButtonIconPosition.right) CustomHorizontalSpace(width: spaceBetweenTextAndIcon),
          CustomTextWidget(
            btnText,
            fontColor: btnTextColor,
            fontWeight: btnTextWeight,
            fontSize: btnTextSize,
            textDecoration: textUnderline ? TextDecoration.underline : TextDecoration.none,
            textDecorationColor: textUnderlineColor,
          ),
          if (buttonIconPosition == ButtonIconPosition.left) CustomHorizontalSpace(width: spaceBetweenTextAndIcon),
          if (buttonIconPosition == ButtonIconPosition.left) icon,
        ],
      ),
    );
  }
}

class CustomTextButtonWithIconWidgetWithFlexible extends StatelessWidget {
  final Color? btnBackgroundColor;
  final Color? btnEffectColor;
  final AlignmentGeometry? btnAlignment;
  final VoidCallback? btnPressed;
  final Widget icon;
  final ButtonIconPosition buttonIconPosition;
  final MainAxisAlignment mainAxisAlignment;
  final double spaceBetweenTextAndIcon;
  final String btnText;
  final Color btnTextColor;
  final AppFontWeight btnTextWeight;
  final double btnTextSize;
  final bool textUnderline;
  final Color? textUnderlineColor;
  final EdgeInsetsGeometry padding;

  const CustomTextButtonWithIconWidgetWithFlexible({
    super.key,
    this.btnBackgroundColor,
    this.btnEffectColor,
    this.btnAlignment,
    required this.btnPressed,
    required this.icon,
    this.buttonIconPosition = ButtonIconPosition.left,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.spaceBetweenTextAndIcon = 4.0,
    required this.btnText,
    this.btnTextColor = AppColor.spruce,
    this.btnTextWeight = AppFontWeight.bold,
    this.btnTextSize = 18.0,
    this.textUnderline = false,
    this.textUnderlineColor,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: btnPressed,
      style: TextButton.styleFrom(
        foregroundColor: btnEffectColor ?? btnBackgroundColor ?? btnTextColor,
        backgroundColor: btnBackgroundColor,
        padding: padding,
      ),
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        children: [
          if (buttonIconPosition == ButtonIconPosition.right) icon,
          if (buttonIconPosition == ButtonIconPosition.right) CustomHorizontalSpace(width: spaceBetweenTextAndIcon),
          Flexible(
            child: CustomTextWidget(
              btnText,
              maxLines: 1,
              textOverflow: TextOverflow.ellipsis,
              fontColor: btnTextColor,
              fontWeight: btnTextWeight,
              fontSize: btnTextSize,
              textDecoration: textUnderline ? TextDecoration.underline : TextDecoration.none,
              textDecorationColor: textUnderlineColor,
            ),
          ),
          if (buttonIconPosition == ButtonIconPosition.left) CustomHorizontalSpace(width: spaceBetweenTextAndIcon),
          if (buttonIconPosition == ButtonIconPosition.left) icon,
        ],
      ),
    );
  }
}

class CustomElevatedButtonWidget1 extends StatelessWidget {
  final VoidCallback? btnPressed;
  final Color btnColor;
  final double btnHeight;
  final double btnWidth;
  final double btnRadius;
  final Color? btnBorderColor;
  final double btnBorderWidth;
  final double btnElevation;
  final AlignmentGeometry btnAlignment;
  final String btnText;
  final Color btnTextColor;
  final AppFontWeight btnTextWeight;
  final double btnTextSize;
  final bool btnTextUnderline;
  final Color? btnTextUnderlineColor;
  final double spaceBetweenTextAndIcon;
  final Widget? icon;
  final ButtonIconPosition buttonIconPosition;

  const CustomElevatedButtonWidget1({
    super.key,
    required this.btnPressed,
    this.btnColor = AppColor.primary900Light,
    this.btnHeight = 65.0,
    this.btnWidth = double.infinity,
    this.btnRadius = 2.5,
    this.btnBorderColor,
    this.btnBorderWidth = 2.0,
    this.btnElevation = 2.0,
    this.btnAlignment = Alignment.center,
    required this.btnText,
    this.buttonIconPosition = ButtonIconPosition.right,
    this.btnTextColor = AppColor.white,
    this.btnTextWeight = AppFontWeight.medium,
    this.btnTextSize = 18.0,
    this.btnTextUnderline = false,
    this.btnTextUnderlineColor,
    this.spaceBetweenTextAndIcon = 4.0,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        backgroundColor: btnColor,
        // background
        // onPrimary: Colors.yellow, // foreground
        alignment: btnAlignment,
        elevation: btnElevation,
        minimumSize: Size(btnWidth, btnHeight),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(btnRadius)),
        side: BorderSide(width: btnBorderWidth, color: btnBorderColor ?? btnColor),
      ),
      onPressed: btnPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null && buttonIconPosition == ButtonIconPosition.right) icon ?? Container(),
          if (icon != null && buttonIconPosition == ButtonIconPosition.right)
            CustomHorizontalSpace(width: spaceBetweenTextAndIcon),
          CustomTextWidget(
            btnText,
            fontColor: btnTextColor,
            fontWeight: btnTextWeight,
            fontSize: btnTextSize,
            textDecoration: btnTextUnderline ? TextDecoration.underline : TextDecoration.none,
            textDecorationColor: btnTextUnderlineColor,
          ),
          if (icon != null && buttonIconPosition == ButtonIconPosition.left)
            CustomHorizontalSpace(width: spaceBetweenTextAndIcon),
          if (icon != null && buttonIconPosition == ButtonIconPosition.left) icon ?? Container(),
        ],
      ),
    );
  }
}

/*
class CustomElevatedButtonWidget extends StatelessWidget {
  final VoidCallback? btnPressed;
  final Color btnColor;
  final double btnHeight;
  final double btnWidth;
  final double btnRadius;
  final Color? btnBorderColor;
  final double btnBorderWidth;
  final AlignmentGeometry btnAlignment;
  final String btnText;
  final Color btnTextColor;
  final FONT_WEIGHT btnTextWeight;
  final double btnTextSize;
  final bool btnTextUnderline;
  final Color? btnTextUnderlineColor;
  final double spaceBetweenTextAndIcon;
  final Widget? icon;
  final BUTTON_ICON_POSITION buttonIconPosition;
  final double horizontalMargin;
  final double verticalMargin;

  const CustomElevatedButtonWidget(
      {Key? key,
      required this.btnPressed,
      this.btnColor = AppColor.primary900Light,
      this.btnHeight = 65.0,
      this.btnWidth = double.infinity,
      this.btnRadius = 2,
      this.btnBorderColor,
      this.btnBorderWidth = 2.0,
      this.btnAlignment = Alignment.center,
      required this.btnText,
      this.buttonIconPosition = BUTTON_ICON_POSITION.right,
      this.btnTextColor = AppColor.white,
      this.btnTextWeight = AppFontWeight.medium,
      this.btnTextSize = 18.0,
      this.btnTextUnderline = false,
      this.btnTextUnderlineColor,
      this.spaceBetweenTextAndIcon = 4.0,
      this.icon,
      this.horizontalMargin = 0,
      this.verticalMargin = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: btnPressed,
      child: Container(
        height: btnHeight,
        width: btnWidth,
        alignment: btnAlignment,
        margin: EdgeInsets.symmetric(
            horizontal: horizontalMargin, vertical: verticalMargin),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(btnRadius)),
            border: Border.all(
              width: btnBorderWidth,
              color: btnBorderColor ?? btnColor,
            ),
            color: btnColor),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null &&
                buttonIconPosition == BUTTON_ICON_POSITION.right)
              icon ?? Container(),
            if (icon != null &&
                buttonIconPosition == BUTTON_ICON_POSITION.right)
              CustomHorizontalSpace(width: spaceBetweenTextAndIcon),
            CustomTextWidget(
              btnText,
              fontColor: btnTextColor,
              fontWeight: btnTextWeight,
              fontSize: btnTextSize,
              textDecoration: btnTextUnderline
                  ? TextDecoration.underline
                  : TextDecoration.none,
              textDecorationColor: btnTextUnderlineColor,
            ),
            if (icon != null && buttonIconPosition == BUTTON_ICON_POSITION.left)
              CustomHorizontalSpace(width: spaceBetweenTextAndIcon),
            if (icon != null && buttonIconPosition == BUTTON_ICON_POSITION.left)
              icon ?? Container(),
          ],
        ),
      ),
    );
  }
}
*/
class CustomElevatedButtonWithIconWidget1 extends StatelessWidget {
  final VoidCallback? btnPressed;
  final Color btnColor;
  final double btnHeight;
  final double btnWidth;
  final double btnRadius;
  final Color? btnBorderColor;
  final double btnBorderWidth;
  final double btnElevation;
  final AlignmentGeometry btnAlignment;
  final String btnText;
  final Color btnTextColor;
  final AppFontWeight btnTextWeight;
  final double btnTextSize;
  final bool btnTextUnderline;
  final Color? btnTextUnderlineColor;
  final Widget icon;
  final ButtonIconPosition buttonIconPosition;
  final MainAxisAlignment mainAxisAlignment;
  final double spaceBetweenTextAndIcon;

  const CustomElevatedButtonWithIconWidget1({
    super.key,
    required this.btnPressed,
    this.btnColor = AppColor.primary900Light,
    this.btnHeight = 65.0,
    this.btnWidth = double.infinity,
    this.btnRadius = 2.5,
    this.btnBorderColor,
    this.btnBorderWidth = 1.0,
    this.btnElevation = 2.0,
    this.btnAlignment = Alignment.center,
    required this.btnText,
    this.btnTextColor = AppColor.white,
    this.btnTextWeight = AppFontWeight.medium,
    this.btnTextSize = 18.0,
    this.btnTextUnderline = false,
    this.btnTextUnderlineColor,
    required this.icon,
    this.buttonIconPosition = ButtonIconPosition.left,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.spaceBetweenTextAndIcon = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: btnColor,
        // background
        // onPrimary: Colors.yellow, // foreground
        alignment: btnAlignment,
        elevation: btnElevation,
        minimumSize: Size(btnWidth, btnHeight),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(btnRadius)),
        side: BorderSide(width: btnBorderWidth, color: btnBorderColor ?? btnColor),
        // padding: Edge
      ),
      onPressed: btnPressed,
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        children: [
          if (buttonIconPosition == ButtonIconPosition.right) icon,
          if (buttonIconPosition == ButtonIconPosition.right) CustomHorizontalSpace(width: spaceBetweenTextAndIcon),
          CustomTextWidget(
            btnText,
            fontColor: btnTextColor,
            fontWeight: btnTextWeight,
            fontSize: btnTextSize,
            textDecoration: btnTextUnderline ? TextDecoration.underline : TextDecoration.none,
            textDecorationColor: btnTextUnderlineColor,
          ),
          if (buttonIconPosition == ButtonIconPosition.left) CustomHorizontalSpace(width: spaceBetweenTextAndIcon),
          if (buttonIconPosition == ButtonIconPosition.left) icon,
        ],
      ),
    );
  }
}

class CustomElevatedButtonWithIconWidget extends StatelessWidget {
  final VoidCallback? btnPressed;
  final Color btnColor;
  final double btnHeight;
  final double btnWidth;
  final double btnRadius;
  final Color? btnBorderColor;
  final double btnBorderWidth;
  final double btnElevation;
  final AlignmentGeometry btnAlignment;
  final String btnText;
  final Color btnTextColor;
  final AppFontWeight btnTextWeight;
  final double btnTextSize;
  final bool btnTextUnderline;
  final Color? btnTextUnderlineColor;
  final Widget icon;
  final ButtonIconPosition buttonIconPosition;
  final MainAxisAlignment mainAxisAlignment;
  final double spaceBetweenTextAndIcon;

  const CustomElevatedButtonWithIconWidget({
    super.key,
    required this.btnPressed,
    this.btnColor = AppColor.primary900Light,
    this.btnHeight = 65.0,
    this.btnWidth = double.infinity,
    this.btnRadius = 2.5,
    this.btnBorderColor,
    this.btnBorderWidth = 1.0,
    this.btnElevation = 2.0,
    this.btnAlignment = Alignment.center,
    required this.btnText,
    this.btnTextColor = AppColor.white,
    this.btnTextWeight = AppFontWeight.medium,
    this.btnTextSize = 18.0,
    this.btnTextUnderline = false,
    this.btnTextUnderlineColor,
    required this.icon,
    this.buttonIconPosition = ButtonIconPosition.left,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.spaceBetweenTextAndIcon = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: btnPressed,
      child: Container(
        height: btnHeight,
        width: btnWidth,
        alignment: btnAlignment,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(btnRadius)),
          border: Border.all(width: btnBorderWidth, color: btnBorderColor ?? btnColor),
          color: btnColor,
        ),
        child: Row(
          mainAxisAlignment: mainAxisAlignment,
          children: [
            if (buttonIconPosition == ButtonIconPosition.right) icon,
            if (buttonIconPosition == ButtonIconPosition.right) CustomHorizontalSpace(width: spaceBetweenTextAndIcon),
            CustomTextWidget(
              btnText,
              fontColor: btnTextColor,
              fontWeight: btnTextWeight,
              fontSize: btnTextSize,
              textDecoration: btnTextUnderline ? TextDecoration.underline : TextDecoration.none,
              textDecorationColor: btnTextUnderlineColor,
            ),
            if (buttonIconPosition == ButtonIconPosition.left) CustomHorizontalSpace(width: spaceBetweenTextAndIcon),
            if (buttonIconPosition == ButtonIconPosition.left) icon,
          ],
        ),
      ),
    );
  }
}

/*
class CustomIconButtonWidget extends StatelessWidget {
  final Color backgroundColor;
  final Color borderColor;
  final double borderRadius;
  final double borderWidth;
  final double btnWidth;
  final double btnHeight;
  final VoidCallback btnPressed;
  final String? svgIcon;
  final double svgIconHeight;
  final double svgIconWidth;
  final Color? svgIconColor;
  final IconData? materialIcon;
  final MATERIAL_ICON_DIRECTION materialIconDirection;
  final Color materialIconColor;
  final double materialIconSize;
  final String image;
  final Color? imageColor;
  final bool isVisible;

  const CustomIconButtonWidget(
      {Key? key,
      this.backgroundColor = Colors.transparent,
      this.borderColor = Colors.transparent,
      this.borderRadius = 4.0,
      this.borderWidth = 1.0,
      this.btnHeight = 24.0,
      this.btnWidth = 24.0,
      this.image = "",
      required this.btnPressed,
      this.svgIcon,
      this.svgIconHeight = 24.0,
      this.svgIconWidth = 24.0,
      this.svgIconColor,
      this.materialIcon,
      this.materialIconDirection = MATERIAL_ICON_DIRECTION.left,
      this.materialIconColor = AppColor.black,
      this.materialIconSize = 18.0,
      this.imageColor,
      this.isVisible = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: Container(
        width: btnWidth,
        height: btnHeight,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: borderColor, width: borderWidth),
        ),
        child: InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: btnPressed,
          child: svgIcon != null
              ? CustomSvgIconWidget(
                  svgIcon!,
                  iconHeight: svgIconHeight,
                  iconWidth: svgIconWidth,
                  iconColor: svgIconColor,
                )
              : RotatedBox(
                  quarterTurns: _getMaterialIconDirection(),
                  child: image.isNotEmpty
                      ? Image.asset(
                          Constants.imgPath + image,
                          color: imageColor,
                        )
                      : Icon(
                          materialIcon ?? Icons.arrow_back_ios_new,
                          color: materialIconColor,
                          size: materialIconSize,
                        ),
                ),
        ),
      ),
    );
  }

  int _getMaterialIconDirection() {
    switch (materialIconDirection) {
      case MATERIAL_ICON_DIRECTION.left:
        return 0;
      case MATERIAL_ICON_DIRECTION.up:
        return 1;
      case MATERIAL_ICON_DIRECTION.right:
        return 2;
      case MATERIAL_ICON_DIRECTION.down:
        return 3;
    }
  }
}


*/
class CustomInkWellButtonWidget extends StatelessWidget {
  final VoidCallback? btnPressed;
  final Widget widget;

  const CustomInkWellButtonWidget({super.key, required this.btnPressed, required this.widget});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: btnPressed,
      child: widget,
    );
  }
}

class RotationBasedLanguageWidget extends StatelessWidget {
  final Widget child;
  const RotationBasedLanguageWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return RotatedBox(quarterTurns: CommonFunctions.isAppAR ? 0 : 2, child: child);
  }
}

class LabelTextWithOptional extends StatelessWidget {
  final String label;
  final Color labelColor;
  final double labelSize;
  final TextAlign labelTextAlign;
  final bool? showOptional;

  const LabelTextWithOptional({
    super.key,
    required this.label,
    this.labelColor = AppColor.blackModern700Light,
    this.labelSize = 13.0,
    this.labelTextAlign = TextAlign.start,
    this.showOptional = false,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: labelTextAlign,
      text: TextSpan(
        children: [
          if (label.isNotEmpty)
            TextSpan(
              text: label,
              style: TextStyle(
                color: labelColor,
                fontSize: labelSize,
                fontFamily: GeneralKey.appFontType,
                fontWeight: FontWeight.bold,
              ),
            ),
          if (showOptional == false)
            const TextSpan(
              text: " *",
              style: TextStyle(color: Colors.red, fontFamily: GeneralKey.appFontType, fontWeight: FontWeight.bold),
            ),
        ],
      ),
      textScaler: TextScaler.linear(1),
    );
  }
}
