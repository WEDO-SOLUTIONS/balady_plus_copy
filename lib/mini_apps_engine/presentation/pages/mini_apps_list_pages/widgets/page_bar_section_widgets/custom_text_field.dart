import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/keys/general_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

//!
class MiniAppsCustomTextField extends StatelessWidget {
  final String? hintText;
  final double? height;
  final double? width;
  final Widget? icon;
  final bool? obscureText;
  final Widget? suffixIcon;
  final Widget? suffixString;
  final Function()? onPressed;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final double? horizontalPadding;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final double? hintTextSize;
  final Text? prefixString;
  final List<TextInputFormatter>? inputFormatters;
  final Pattern? allowedInputPattern;
  final Pattern? deniedInputPattern;
  final bool isDigitsOnly;
  final TextInputAction? textInputAction;
  final bool? autofocus;
  final void Function(String)? onFieldSubmitted;
  final int? maxLines;
  final Color? backgroundColor;
  final Color? borderColor;

  final bool isReadOnly;
  final bool isEnabled;

  final EdgeInsetsGeometry? suffixPadding;

  final void Function()? onTap;

  const MiniAppsCustomTextField({
    super.key,
    this.hintText,
    this.icon,
    this.suffixIcon,
    this.suffixString,
    required this.keyboardType,
    this.controller,
    this.onPressed,
    this.obscureText,
    this.focusNode,
    this.height,
    this.width,
    this.horizontalPadding,
    this.validator,
    this.onChanged,
    this.hintTextSize,
    this.prefixString,
    this.inputFormatters,
    this.allowedInputPattern,
    this.deniedInputPattern,
    this.isDigitsOnly = false,
    this.textInputAction,
    this.onFieldSubmitted,
    this.autofocus,
    this.maxLines,
    this.backgroundColor,
    this.borderColor,
    required this.isReadOnly,
    this.isEnabled = true,
    required this.onTap,
    this.suffixPadding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final inputTheme = theme.inputDecorationTheme;

    final TextDirection currentDirection = CommonFunctions.isAppAR ? TextDirection.rtl : TextDirection.ltr;

    final content = SizedBox(
      width: width ?? 700,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding ?? 8),
        child: AbsorbPointer(
          absorbing: !isEnabled,
          child: Directionality(
            textDirection: currentDirection,
            child: TextFormField(
              textAlignVertical: TextAlignVertical.center,
              readOnly: isReadOnly,
              enabled: isEnabled,
              maxLines: maxLines ?? 1,
              textInputAction: textInputAction,
              onFieldSubmitted: onFieldSubmitted,
              onTap: onTap,
              inputFormatters:
                  inputFormatters ??
                  [
                    if (isDigitsOnly) FilteringTextInputFormatter.digitsOnly,
                    if (allowedInputPattern != null) FilteringTextInputFormatter.allow(allowedInputPattern!),
                    if (deniedInputPattern != null) FilteringTextInputFormatter.deny(deniedInputPattern!),
                  ],
              onChanged: onChanged,
              focusNode: focusNode,
              autofocus: autofocus ?? false,
              cursorColor: theme.textSelectionTheme.cursorColor,
              style: theme.textTheme.bodyLarge?.copyWith(fontSize: 16, fontFamily: GeneralKey.appFontType),
              decoration: InputDecoration(
                hintText: hintText ?? "search2".tr(),
                hintStyle: TextStyle(fontFamily: GeneralKey.appFontType, color: inputTheme.hintStyle?.color),
                prefixIcon: Theme.of(context).brightness == Brightness.dark
                    ? Image.asset("assets/icon_dark.webp", scale: 25)
                    : Image.asset("assets/icon_light.webp", scale: 25),

                enabledBorder: inputTheme.enabledBorder,

                disabledBorder: inputTheme.disabledBorder,

                fillColor: backgroundColor ?? inputTheme.fillColor,

                contentPadding: EdgeInsets.zero,
                suffixIcon: suffixIcon,
              ),
              obscureText: obscureText ?? false,
              keyboardType: keyboardType,
              controller: controller,
            ),
          ),
        ),
      ),
    );

    if (onTap != null && isEnabled == false) {
      return GestureDetector(onTap: onTap, behavior: HitTestBehavior.opaque, child: content);
    }
    return content;
  }
}
