import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  final bool? autoFocus;
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
    this.autoFocus,
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
    const textColor = Colors.black;
    const hintColor = Color(0x8C1B153D);

    return SizedBox(
      width: width ?? 700,
      height: height,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding ?? 8),
        child: GestureDetector(
          onTap: onTap,
          child: AbsorbPointer(
            absorbing: !isEnabled,
            child: SizedBox.expand(
              child: TextFormField(
                readOnly: isReadOnly,
                enabled: isEnabled,
                maxLines: 1,
                textAlignVertical: TextAlignVertical.center,
                textInputAction: textInputAction,
                onFieldSubmitted: onFieldSubmitted,
                inputFormatters: inputFormatters ??
                    [
                      if (isDigitsOnly) FilteringTextInputFormatter.digitsOnly,
                      if (allowedInputPattern != null)
                        FilteringTextInputFormatter.allow(allowedInputPattern!),
                      if (deniedInputPattern != null)
                        FilteringTextInputFormatter.deny(deniedInputPattern!),
                    ],
                onChanged: onChanged,
                focusNode: focusNode,
                autofocus: autofocus ?? false,
                cursorColor: const Color(0XFF2AB3A9),
                style: const TextStyle(color: textColor),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: context.screenHeight * 0.04,
                    horizontal: context.screenWidth * 0.04,
                  ),
                  filled: true,
                  fillColor: backgroundColor ?? const Color(0xFFF5F7FA),
                  errorStyle: const TextStyle(color: Colors.red),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: borderColor ?? const Color(0xFFCED8DC),
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: borderColor ?? const Color(0xFF2AB3A9),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  hintText: hintText,
                  hintStyle: TextStyle(
                    color: hintColor,
                    fontSize: hintTextSize ?? 15,
                  ),
                  prefixIcon: icon,
                  suffixIcon: _buildSuffix(context),
                ),
                obscureText: obscureText ?? false,
                keyboardType: keyboardType,
                controller: controller,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget? _buildSuffix(BuildContext context) {
    if (suffixIcon == null && suffixString == null) return null;

    return Padding(
      padding: suffixPadding ??
          const EdgeInsetsDirectional.symmetric(horizontal: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        textDirection: Directionality.of(context),
        children: [
          if (suffixString != null) suffixString!,
          if (suffixString != null && suffixIcon != null)
            const SizedBox(width: 8),
          if (suffixIcon != null) suffixIcon!,
        ],
      ),
    );
  }

}
