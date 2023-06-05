import 'package:flutter/material.dart';

import '../../../../../core/utils/utils_exports.dart' show AppColor, AppStyle;
import '../../../shared_feature_exports.dart'
    show
        ClickableWidget,
        CustomHorizontalSpace,
        CustomTextWidget,
        DrawIconBasedTypeWidget;

class CustomTextButtonWidget extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;

  final Size? btnSize;
  final double btnHeight;
  final double? btnWidth;
  final Color? btnEffectColor;
  final AlignmentGeometry? btnAlignment;

  final VoidCallback? onPressed;
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
        minimumSize:
            btnSize ?? (btnWidth != null ? Size(btnWidth!, btnHeight) : null),
      ),
      child: CustomTextWidget(
        text,
        textStyle: textStyle ?? AppStyle.textButtonStyle,
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
        minimumSize:
            btnSize ?? (btnWidth != null ? Size(btnWidth!, btnHeight) : null),
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
              icon,
              CustomHorizontalSpace(width: iconTextTweenSpace),
            ],
            // Text
            CustomTextWidget(
              text,
              textStyle: textStyle ?? AppStyle.textButtonStyle,
            ),
            // Icon Widget
            if (atEnd) ...[
              CustomHorizontalSpace(width: iconTextTweenSpace),
              icon,
            ],
          ],
        ),
      ),
    );
  }

  AlignmentGeometry get iconPosition =>
      iconAlignment ?? AlignmentDirectional.centerStart;
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(btnRadius),
          ),
          side: BorderSide(
            width: btnBorderWidth,
            color: btnBorderColor ?? btnColor ?? AppColor.blue,
          ),
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
    );
  }

  bool get isTextWidget => text != null && text is Widget;
  bool get isTextString => text != null && text is String;
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(btnRadius),
                ),
                side: BorderSide(
                  width: btnBorderWidth,
                  color: btnBorderColor ?? btnColor ?? AppColor.blue,
                ),
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
            Align(
              alignment: iconAlignment ?? AlignmentDirectional.centerStart,
              child: icon,
            ),
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(btnRadius),
            ),
            side: BorderSide(
              width: btnBorderWidth,
              color: btnBorderColor ?? btnColor ?? AppColor.blue,
            ),
          ),
          child: Row(
            mainAxisAlignment: btnAlignment ?? MainAxisAlignment.center,
            children: [
              // Icon Widget
              if (atStart) ...[
                icon,
                CustomHorizontalSpace(width: iconTextTweenSpace),
              ],
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
              if (atEnd) ...[
                CustomHorizontalSpace(width: iconTextTweenSpace),
                icon,
              ],
            ],
          ),
        ),
      ),
    );
  }

  bool get isTextWidget => text != null && text is Widget;
  bool get isTextString => text != null && text is String;
  AlignmentGeometry get iconPosition =>
      iconAlignment ?? AlignmentDirectional.centerStart;
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
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: borderColor ?? Colors.transparent,
          width: borderWidth,
        ),
      ),
      child: ClickableWidget(
        onPressed: onPressed,
        effectColor: Colors.transparent,
        child: DrawIconBasedTypeWidget(
          icon: icon,
          iconColor: iconColor,
          iconSize: iconSize,
        ),
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
              color: underlineColor ??
                  AppStyle.textButtonStyle.color ??
                  Colors.black,
            ),
          ),
        ),
        child: CustomTextWidget(
          text,
          textStyle: textStyle ?? AppStyle.textButtonStyle,
        ),
      ),
    );
  }
}
