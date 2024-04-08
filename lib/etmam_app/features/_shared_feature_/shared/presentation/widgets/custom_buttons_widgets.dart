import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show AppColor, AppColorsTheme, AppFontWeight, ButtonIconPosition, IconPath;
import '../../shared_feature_exports.dart'
    show CustomHorizontalSpace, CustomSvgIconWidget, CustomTextWidget;
import 'package:flutter/material.dart';

class CustomTextButtonWidget extends StatelessWidget {
  final VoidCallback btnPressed;
  final String btnText;
  final Color? btnTextColor;
  final AppFontWeight btnTextWeight;
  final double btnTextSize;
  final bool haveUnderline;
  final Color? underlineColor;
  final AlignmentGeometry? alignment;
  final Size? btnSize;
  final Size? btnMaxSize;

  const CustomTextButtonWidget(
      {Key? key,
      required this.btnPressed,
      required this.btnText,
      this.btnTextColor,
      this.btnTextWeight = AppFontWeight.medium,
      this.btnTextSize = 12.0,
      this.haveUnderline = false,
      this.underlineColor,
      this.alignment,
      this.btnSize,
      this.btnMaxSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: btnPressed,
      style: TextButton.styleFrom(
        
          foregroundColor: Colors.transparent,
          padding: EdgeInsets.zero,
          alignment: alignment ?? AlignmentDirectional.centerStart,
          minimumSize: btnSize,
          maximumSize: btnMaxSize),
      child: CustomTextWidget(
        btnText,
        fontColor: btnTextColor ?? AppColor.darkTurquoise,
        fontWeight: btnTextWeight,
        fontSize: btnTextSize,
        textDecoration:
            haveUnderline ? TextDecoration.underline : TextDecoration.none,
        textDecorationColor: underlineColor,
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
  final String? btnText;
  final Color btnTextColor;
  final AppFontWeight btnTextWeight;
  final double btnTextSize;
  final bool textUnderline;
  final Color? textUnderlineColor;
  final EdgeInsetsGeometry padding;
  final int? maxLines;
  final TextOverflow? textOverflow;
  final MainAxisSize mainAxisSize;
  final bool withFlexible;

  const CustomTextButtonWithIconWidget({
    Key? key,
    this.btnBackgroundColor,
    this.btnEffectColor,
    this.btnAlignment,
    required this.btnPressed,
    required this.icon,
    this.buttonIconPosition = ButtonIconPosition.left,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.spaceBetweenTextAndIcon = 4.0,
    this.btnText,
    this.btnTextColor = AppColor.spruce,
    this.btnTextWeight = AppFontWeight.bold,
    this.btnTextSize = 18.0,
    this.textUnderline = false,
    this.textUnderlineColor,
    this.maxLines,
    this.textOverflow,
    this.withFlexible = false,
    this.mainAxisSize = MainAxisSize.max,
    this.padding = EdgeInsets.zero,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      clipBehavior: Clip.hardEdge,
      onPressed: btnPressed,
      style: TextButton.styleFrom(
        padding: padding,
        backgroundColor: btnBackgroundColor,
        alignment: btnAlignment,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
        foregroundColor: btnEffectColor ?? btnBackgroundColor ?? btnTextColor,
      ),
      child: Row(
        mainAxisSize: mainAxisSize,
        mainAxisAlignment: mainAxisAlignment,
        children: [
          if (buttonIconPosition == ButtonIconPosition.right) icon,
          if (buttonIconPosition == ButtonIconPosition.right)
            CustomHorizontalSpace(width: spaceBetweenTextAndIcon),
          if (btnText != null)
            withFlexible
                ? Flexible(
                    child: CustomTextWidget(
                      btnText!,
                      fontColor: btnTextColor,
                      fontWeight: btnTextWeight,
                      fontSize: btnTextSize,
                      maxLines: maxLines,
                      textOverflow: textOverflow ?? TextOverflow.visible,
                      textDecoration: textUnderline
                          ? TextDecoration.underline
                          : TextDecoration.none,
                      textDecorationColor: textUnderlineColor,
                    ),
                  )
                : CustomTextWidget(
                    btnText!,
                    fontColor: btnTextColor,
                    fontWeight: btnTextWeight,
                    fontSize: btnTextSize,
                    maxLines: maxLines,
                    textOverflow: textOverflow ?? TextOverflow.visible,
                    textDecoration: textUnderline
                        ? TextDecoration.underline
                        : TextDecoration.none,
                    textDecorationColor: textUnderlineColor,
                  ),
          if (buttonIconPosition == ButtonIconPosition.left)
            CustomHorizontalSpace(width: spaceBetweenTextAndIcon),
          if (buttonIconPosition == ButtonIconPosition.left) icon,
        ],
      ),
    );
  }
}

class CustomIconButtonWidget extends StatelessWidget {
  final VoidCallback? btnPressed;
  final Widget icon;
  final EdgeInsetsGeometry? padding;

  const CustomIconButtonWidget({
    Key? key,
    required this.btnPressed,
    required this.icon,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: btnPressed,
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16),
        child: icon,
      ),
    );
  }
}

class CustomNewIconButtonWidget extends StatelessWidget {
  final VoidCallback? btnPressed;
  final Widget? iconWidget;
  final String? iconSvg;
  final double iconSize;
  final Color? iconColor;
  final EdgeInsetsGeometry? padding;

  const CustomNewIconButtonWidget(
      {Key? key,
      required this.btnPressed,
      this.iconSize = 24,
      this.iconWidget,
      this.iconSvg,
      this.padding,
      this.iconColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        padding: padding ?? const EdgeInsets.all(8),
        iconSize: iconSize,
        onPressed: btnPressed,
        icon: iconWidget ??
            CustomSvgIconWidget(iconSvg ?? "",
                iconSize: iconSize, iconColor: iconColor));
  }
}

class CustomInkWellButtonWidget extends StatelessWidget {
  final VoidCallback? btnPressed;
  final Widget widget;

  const CustomInkWellButtonWidget({
    Key? key,
    required this.btnPressed,
    required this.widget,
  }) : super(key: key);

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

class CustomElevatedButtonWidget extends StatelessWidget {
  final VoidCallback? btnPressed;
  final Color? btnColor;
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
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final EdgeInsetsGeometry btnPadding;
  final List<BoxShadow>? boxShadow;
  final double horizontalMargin;

  const CustomElevatedButtonWidget(
      {Key? key,
      required this.btnPressed,
      this.btnColor,
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
      this.mainAxisAlignment = MainAxisAlignment.center,
      this.mainAxisSize = MainAxisSize.min,
      this.btnPadding = EdgeInsets.zero,
      this.boxShadow,
      this.horizontalMargin = 0,
      this.icon})
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
        padding: btnPadding,
        margin: EdgeInsets.symmetric(
          horizontal: horizontalMargin,
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(btnRadius)),
            border: Border.all(
              width: btnBorderWidth,
              color: btnBorderColor ?? btnColor ?? AppColorsTheme.primary700,
            ),
            boxShadow: boxShadow,
            color: btnColor ?? AppColorsTheme.primary700),
        child: Row(
          mainAxisAlignment: mainAxisAlignment,
          mainAxisSize: mainAxisSize,
          children: [
            if (icon != null && buttonIconPosition == ButtonIconPosition.right)
              icon ?? Container(),
            if (icon != null && buttonIconPosition == ButtonIconPosition.right)
              CustomHorizontalSpace(width: spaceBetweenTextAndIcon),
            Flexible(
              child: CustomTextWidget(
                btnText,
                fontColor: btnTextColor,
                fontWeight: btnTextWeight,
                fontSize: btnTextSize,
                textDecoration: btnTextUnderline
                    ? TextDecoration.underline
                    : TextDecoration.none,
                textDecorationColor: btnTextUnderlineColor,
                maxLines: 1,
                textOverflow: TextOverflow.ellipsis,
              ),
            ),
            if (icon != null && buttonIconPosition == ButtonIconPosition.left)
              CustomHorizontalSpace(width: spaceBetweenTextAndIcon),
            if (icon != null && buttonIconPosition == ButtonIconPosition.left)
              icon ?? Container(),
          ],
        ),
      ),
    );
  }
}

class CustomGoToDetailsButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final Color labelColor;
  final Color? arrowColor;
  final EdgeInsetsGeometry? padding;
  final Widget? leading;
  final double leadingWidth;
  final double leadingSpace;
  final Color? effectColor;
  final Color? bgColor;
  final double borderRadius;
  final double? elevation;
  final Color? borderColor;
  final String icon;
  final double iconHeight;
  final double iconWidth;

  const CustomGoToDetailsButtonWidget(
      {Key? key,
      required this.onPressed,
      required this.label,
      this.labelColor = AppColor.black,
      this.arrowColor,
      this.padding,
      this.leading,
      this.leadingWidth = 20.0,
      this.leadingSpace = 10.0,
      this.effectColor,
      this.bgColor,
      this.borderRadius = 0.0,
      this.elevation,
      this.borderColor,
      this.icon = IconPath.goToDetailsArrow,
      this.iconHeight = 24,
      this.iconWidth = 24})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: effectColor ?? Colors.transparent,
        backgroundColor: bgColor ?? Colors.transparent,
        shape: RoundedRectangleBorder(
          side: borderColor != null
              ? BorderSide(
                  color: borderColor ?? AppColorsTheme.primary700, width: 0.5)
              : BorderSide.none,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        elevation: elevation,
        padding: padding ?? const EdgeInsets.all(16),
      ),
      onPressed: onPressed,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (leading != null)
            Container(
              alignment: AlignmentDirectional.centerStart,
              width: leadingWidth + leadingSpace,
              child: leading!,
            ),
          Expanded(
            child: LayoutBuilder(
              builder: (_, constraints) {
                final width = constraints.maxWidth;
                return Row(
                  children: [
                    SizedBox(
                      width: width - 30.0,
                      child: CustomTextWidget(
                        label,
                        fontSize: 16,
                        fontColor: labelColor,
                        fontWeight: AppFontWeight.medium,
                        textAlign: TextAlign.start,
                        maxLines: 1,
                        textOverflow: TextOverflow.ellipsis,
                      ),
                    ),
                    CustomSvgIconWidget(
                      icon,
                      iconColor: arrowColor ?? AppColorsTheme.primary700,
                      iconHeight: iconHeight,
                      iconWidth: iconWidth,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CustomStackFooterButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final String btnText;
  final bool isBtnDisabled;

  const CustomStackFooterButtonWidget({
    Key? key,
    required this.onPressed,
    required this.btnText,
    this.isBtnDisabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: const BoxDecoration(
          // borderRadius: BorderRadius.only(
          //     topLeft: Radius.circular(12), topRight: Radius.circular(12)),
          color: AppColor.white,
        ),
        child: SafeArea(
          top: false,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 32,
            ),
            margin: const EdgeInsets.symmetric(
              vertical: 12,
            ),
            child: CustomPrimaryButton(
              btnText: btnText,
              onPressed: isBtnDisabled ? () {} : onPressed,
              textColor: AppColor.white,
              isBtnDisabled: isBtnDisabled,
            ),
          ),
        ),
      ),
    );
  }
}

class CustomPrimaryButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String btnText;
  final Color? btnColor;
  final Color textColor;
  final double btnHeight;
  final Color? btnBorderColor;
  final bool isBtnDisabled;
  final double btnWidth;

  const CustomPrimaryButton({
    Key? key,
    required this.onPressed,
    required this.btnText,
    this.btnColor,
    this.textColor = AppColor.white,
    this.btnHeight = 56,
    this.btnBorderColor,
    this.isBtnDisabled = false,
    this.btnWidth = double.infinity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomElevatedButtonWidget(
      boxShadow: const [
        BoxShadow(
            color: Color(0x14484b52),
            offset: Offset(-2, 4),
            blurRadius: 8,
            spreadRadius: 0),
      ],
      btnRadius: 8,
      btnColor: isBtnDisabled
          ? btnColor ?? AppColor.black200
          : btnColor ?? AppColor.primary900,
      btnTextColor: textColor,
      btnPressed: isBtnDisabled ? () {} : onPressed,
      btnText: btnText,
      btnTextSize: 16.0,
      btnTextWeight: AppFontWeight.bold,
      btnHeight: btnHeight,
      btnBorderColor: btnBorderColor,
      btnBorderWidth: 1,
      btnWidth: btnWidth,
    );
  }
}

class EtmamCustomPrimaryButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String btnText;
  final Color? btnColor;
  final Color textColor;
  final double btnHeight;
  final Color? btnBorderColor;
  final bool isBtnDisabled;

  const EtmamCustomPrimaryButton({
    Key? key,
    required this.onPressed,
    required this.btnText,
    this.btnColor,
    this.textColor = AppColor.white,
    this.btnHeight = 56,
    this.btnBorderColor,
    this.isBtnDisabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomElevatedButtonWidget(
      boxShadow: const [
        BoxShadow(
            color: Color(0x14484b52),
            offset: Offset(-2, 4),
            blurRadius: 8,
            spreadRadius: 0),
      ],
      btnRadius: 2,
      btnColor: isBtnDisabled
          ? btnColor ?? AppColor.black200
          : btnColor ?? AppColor.darkTurquoise,
      btnTextColor: textColor,
      btnPressed: isBtnDisabled ? () {} : onPressed,
      btnText: btnText,
      btnTextSize: 16.0,
      btnTextWeight: AppFontWeight.medium,
      btnHeight: btnHeight,
      btnBorderColor: btnBorderColor,
      btnBorderWidth: 1,
    );
  }
}
