import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show FilteringTextInputFormatter, TextInputFormatter;

import '../../../../../core/utils/utils_exports.dart'
    show AppColor, AppStyle, BorderConversion, BorderType;
import '../../../shared_feature_exports.dart' show WidgetLabel;

class CustomTextFieldWidget extends StatelessWidget {
  final bool enabled;
  final String? label;
  final TextStyle? labelStyle;
  final bool isRequired;

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool autocorrect;
  final List<String>? autofillHints;
  final AutovalidateMode? autovalidateMode;
  final Color? cursorColor;
  final double? cursorHeight;
  final double cursorWidth;
  final bool? showCursor;
  final String? initialValue;
  final bool isDigitsOnly;
  final List<TextInputFormatter>? inputFormatters;
  final Pattern? allowedInputPattern;
  final Pattern? deniedInputPattern;
  final TextInputType? keyboardType;
  final int? maxLength;
  final int maxLines;
  final bool obsecureText;
  final bool readOnly;
  final Color? disabledColor;
  final TextAlign? textAlign;
  final TextInputAction? textInputAction;

  final TextStyle? textFieldStyle;

  final double? textFieldWidth;
  final double? textFieldHeight;
  final String? hintText;
  final TextStyle? hintStyle;
  final bool filled;
  final Color? fillColor;
  final double textFieldVerticalPadding;
  final double startPadding;
  final double endPadding;
  final Widget? prefixIcon;
  final double prefixSize;
  final double spaceBeforePrefix;
  final double spaceAfterPrefix;
  final Widget? suffixIcon;
  final double suffixSize;
  final double spaceBeforeSuffix;
  final double spaceAfterSuffix;
  final BorderType? borderType;
  final double borderRadius;
  final Color? borderColor;
  final String? errorText;

  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final void Function()? onTap;
  final String? Function(String?)? onValidate;

  const CustomTextFieldWidget({
    super.key,
    this.enabled = true,
    this.label,
    this.labelStyle,
    this.isRequired = false,
    this.controller,
    this.focusNode,
    this.autocorrect = false,
    this.autofillHints,
    this.autovalidateMode,
    this.cursorColor,
    this.cursorHeight,
    this.cursorWidth = 2.0,
    this.showCursor,
    this.initialValue,
    this.isDigitsOnly = false,
    this.inputFormatters,
    this.allowedInputPattern,
    this.deniedInputPattern,
    this.keyboardType,
    this.maxLength,
    this.maxLines = 1,
    this.obsecureText = false,
    this.readOnly = false,
    this.disabledColor,
    this.textAlign,
    this.textInputAction,
    this.textFieldStyle,
    this.textFieldWidth,
    this.textFieldHeight,
    // this.textFieldHeight = 90.0,
    this.hintText,
    this.hintStyle,
    this.filled = true,
    this.fillColor,
    // this.textFieldVerticalPadding = 24.0,
    this.textFieldVerticalPadding = 20.0,
    this.startPadding = 16.0,
    this.endPadding = 6.0,
    this.prefixIcon,
    this.prefixSize = 18.0,
    this.spaceBeforePrefix = 20.0,
    this.spaceAfterPrefix = 8.0,
    this.suffixIcon,
    this.suffixSize = 18.0,
    this.spaceBeforeSuffix = 6.0,
    this.spaceAfterSuffix = 16.0,
    this.borderType,
    this.borderColor,
    this.borderRadius = 8.0,
    this.errorText,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.onValidate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        // if field is required, then show label beside asterisk e.g. *Username
        WidgetLabel(
          isRequired: isRequired,
          label: label,
          labelStyle: labelStyle,
        ),
        // Field
        TextFormField(
          enabled: enabled,
          controller: controller,
          focusNode: focusNode,
          autocorrect: autocorrect,
          autofillHints: autofillHints,
          autovalidateMode:
              autovalidateMode ?? AutovalidateMode.onUserInteraction,
          cursorColor: cursorColor ?? AppColor.blue,
          cursorHeight: cursorHeight,
          showCursor: showCursor,
          cursorWidth: cursorWidth,
          initialValue: initialValue,
          scrollPadding: EdgeInsets.only(
            // (13.0 * 4.0) => (fontSize * 4.0)
            bottom: MediaQuery.of(context).viewInsets.bottom + (13.0 * 4.0),
          ),
          inputFormatters: inputFormatters ??
              [
                if (isDigitsOnly) FilteringTextInputFormatter.digitsOnly,
                if (allowedInputPattern != null)
                  FilteringTextInputFormatter.allow(allowedInputPattern!),
                if (deniedInputPattern != null)
                  FilteringTextInputFormatter.deny(deniedInputPattern!),
              ],
          keyboardType: keyboardType,
          maxLength: maxLength,
          maxLines: maxLines,
          obscureText: obsecureText,
          readOnly: readOnly,
          textAlign: textAlign ?? TextAlign.start,
          textInputAction: textInputAction,
          style: textFieldStyle ??
              AppStyle.mainTextThirdStyle.copyWith(
                fontSize: 13.0,
                color: AppColor.black,
              ),
          decoration: InputDecoration(
            constraints: BoxConstraints(
              maxWidth: textFieldWidth ?? double.infinity,
              maxHeight: textFieldHeight ?? double.infinity,
            ),
            hintText: hintText,
            hintStyle: hintStyle,
            filled: filled,
            fillColor: readOnly
                ? disabledColor ?? AppColor.gray
                : fillColor ?? AppColor.white,
            /*
            **First scenario:
            contentPadding: add padding before prefix-icon and after suffix-icon
            imagine: S T P (S: Suffix, T: Text, P: Prefix)
            if app RTL: right-padding add padding before prefix
                        to be S T Px (x: added padding)
                        left-padding add padding after suffix
                        to be Sx T P (x: added padding)
            imagine: P T S (S: Suffix, T: Text, P: Prefix)
            if app LTR: right-padding add padding after suffix
                        to be P T xS (x: added padding)
                        left-padding add padding before prefix
                        to be xP T S (x: added padding)
            
            Prefix is opposite of Suffix

            **Second scenario: "Enhanced"
            contentPadding: add padding vertically only,
                            and remove any padding about suffix and prefix
            */
            // contentPadding: EdgeInsets.symmetric(
            //   vertical: textFieldVerticalPadding,
            // ),
            contentPadding: EdgeInsetsDirectional.fromSTEB(
              prefixIcon == null ? startPadding : 0.0,
              textFieldVerticalPadding,
              suffixIcon == null ? endPadding : 0.0,
              textFieldVerticalPadding,
            ),

            /*
            **First scenario: if we follow the first scenario of contentPadding
            we before added padding between prefix and start-of-textfield
            so padding added here to add space between prefix and text
            so specifying usign end property

            **Second scenario: "Enhanced"
            We will add space before and after prefix
            if app RTL Imagine: a P b (a: after-prefix, P: Prefix, b: before-prefix)
            so we add space-before-prefix for start property
            and add space-after-prefix for end property
            if app LTR Imagine: b P a (b: before-prefix, P: Prefix, a: after-prefix)
            it will be the same thing cause we specify start and end properties
            */
            prefixIcon: prefixIcon != null
                ? Padding(
                    // color: Colors.red,
                    padding: EdgeInsetsDirectional.only(
                      start: spaceBeforePrefix,
                      end: spaceAfterPrefix,
                    ),
                    child: prefixIcon,
                  )
                : null,
            prefixIconConstraints: BoxConstraints(
              minHeight: prefixSize,
              minWidth: prefixSize,
            ),
            /* 
            **First scenario:
            we before added padding between suffix and text
            so padding added here to add space between suffix and end-of-textfield
            not between siffix and text, so specifying usign end property

            **Second scenario: "Enhanced"
            We will add space before and after suffix
            if app RTL Imagine: a S b (a: after-suffix, S: Suffix, b: before-suffix)
            so we add space-before-suffix for start property
            and add space-after-suffix for end property
            if app LTR Imagine: b S a (b: before-suffix, S: Suffix, a: after-suffix)
            it will be the same thing cause we specify start and end properties
            */
            suffixIcon: suffixIcon != null
                ? Padding(
                    // color: Colors.red,
                    padding: EdgeInsetsDirectional.only(
                      start: spaceBeforeSuffix,
                      end: spaceAfterSuffix,
                    ),
                    child: suffixIcon,
                  )
                : null,
            suffixIconConstraints: BoxConstraints(
              minHeight: suffixSize,
              minWidth: suffixSize,
            ),
            border: fieldBorderType.inputBorder(
              color: fieldBorderColor,
              radius: borderRadius,
            ),
            enabledBorder: fieldBorderType.inputBorder(
              color: fieldBorderColor,
              radius: borderRadius,
            ),
            focusedBorder: fieldBorderType.inputBorder(
              color: fieldBorderColor,
              radius: borderRadius,
            ),
            errorBorder: fieldBorderType.inputBorder(
              color: AppColor.error,
              radius: borderRadius,
            ),
            errorStyle: const TextStyle(color: AppColor.error),
            errorText: errorText,
          ),
          onTap: onTap,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
          validator: onValidate,
        ),
      ],
    );
  }

  BorderType get fieldBorderType => borderType ?? BorderType.outline;
  Color get fieldBorderColor => borderColor ?? AppColor.gray;
}
