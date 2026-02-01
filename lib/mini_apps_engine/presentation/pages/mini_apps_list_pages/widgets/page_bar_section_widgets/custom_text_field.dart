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
    Color textColor = Theme.of(context).colorScheme.onSurface;
    Color hintColor = Theme.of(context).disabledColor;

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
                textAlign: CommonFunctions.isAppAR
                    ? TextAlign.right
                    : TextAlign.left,
                textDirection: CommonFunctions.isAppAR
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                textAlignVertical: TextAlignVertical.center,
                readOnly: isReadOnly,
                enabled: isEnabled,
                maxLines: 1,
                textInputAction: textInputAction,
                onFieldSubmitted: onFieldSubmitted,
                inputFormatters:
                    inputFormatters ??
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
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 16,
                  ),
                  filled: true,
                  fillColor:
                      backgroundColor ?? Theme.of(context).colorScheme.surface,
                  errorStyle: const TextStyle(color: Colors.red),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(color: const Color(0xFFCED8DC)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: const Color(0xFFCED8DC)),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),

                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).disabledColor,
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
      padding: suffixPadding ?? const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (suffixString != null)
            DefaultTextStyle.merge(
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
              child: suffixString!,
            ),
          if (suffixString != null && suffixIcon != null)
            const SizedBox(width: 20),
          if (suffixIcon != null)
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.onSurface,
                BlendMode.srcIn,
              ),
              child: suffixIcon!,
            ),
        ],
      ),
    );
  }
}
