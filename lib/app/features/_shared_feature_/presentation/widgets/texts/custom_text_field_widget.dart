import 'package:balady_plus/app/core/utils/constants/keys/general_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FilteringTextInputFormatter, TextInputFormatter;

import '../../../../../core/utils/utils_exports.dart' show AppColor, AppStyle, BorderConversion, BorderType;
import '../../../shared_feature_exports.dart'
    show CustomHorizontalSpace, CustomVerticalSpace, LabelTextWithOptional, WidgetLabel;
import '../custom_tooltip_widget.dart';

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
  final double? spacerSize;
  final double? bottomMargin;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final void Function()? onTap;
  final void Function(PointerDownEvent)? onTapOutside;
  final String? Function(String?)? onValidate;
  final bool showOptional;
  final bool showToolTip;
  final String? toolTipMessage;

  const CustomTextFieldWidget({
    super.key,
    this.enabled = true,
    this.showOptional = false,
    this.label,
    this.labelStyle,
    this.isRequired = false,
    this.controller,
    this.focusNode,
    this.autocorrect = false,
    this.autofillHints,
    this.bottomMargin,
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
    this.spacerSize,
    this.onTapOutside,
    this.showToolTip = false,
    this.toolTipMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        // if field is required, then show label beside asterisk e.g. *Username
        Row(
          children: [
            Flexible(
              child: WidgetLabel(
                isRequired: !showOptional || isRequired ? true : false,
                label: label,
                labelStyle: labelStyle,
              ),
            ),
            if (showToolTip) ...[
              CustomTooltipWidget(message: toolTipMessage ?? "", child: const Icon(Icons.info_outline)),
            ],
          ],
        ),
        // Field
        TextFormField(
          enabled: enabled,
          controller: controller,
          focusNode: focusNode,
          autocorrect: autocorrect,
          autofillHints: autofillHints,
          autovalidateMode: autovalidateMode ?? AutovalidateMode.onUserInteraction,
          cursorColor: cursorColor ?? AppColor.blue,
          cursorHeight: cursorHeight,
          showCursor: showCursor,
          cursorWidth: cursorWidth,
          initialValue: initialValue,
          scrollPadding: EdgeInsets.only(
            // (13.0 * 4.0) => (fontSize * 4.0)
            bottom: MediaQuery.of(context).viewInsets.bottom + (13.0 * 4.0),
          ),
          inputFormatters:
              inputFormatters ??
              [
                if (isDigitsOnly) ...[_arabicToLatinDigits, FilteringTextInputFormatter.digitsOnly],
                if (allowedInputPattern != null) FilteringTextInputFormatter.allow(allowedInputPattern!),
                if (deniedInputPattern != null) FilteringTextInputFormatter.deny(deniedInputPattern!),
              ],
          keyboardType: keyboardType,
          maxLength: maxLength,
          maxLines: maxLines,
          obscureText: obsecureText,
          readOnly: readOnly,
          textAlign: textAlign ?? TextAlign.start,
          textInputAction: textInputAction,
          style: textFieldStyle ?? AppStyle.mainTextThirdStyle.copyWith(fontSize: 13.0, color: AppColor.black),
          decoration: InputDecoration(
            constraints: BoxConstraints(
              maxWidth: textFieldWidth ?? double.infinity,
              maxHeight: textFieldHeight ?? double.infinity,
            ),
            hintText: hintText,
            hintStyle: hintStyle,
            filled: filled,
            fillColor: readOnly ? disabledColor ?? AppColor.gray : fillColor ?? AppColor.white,
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
                    padding: EdgeInsetsDirectional.only(start: spaceBeforePrefix, end: spaceAfterPrefix),
                    child: prefixIcon,
                  )
                : null,
            prefixIconConstraints: BoxConstraints(minHeight: prefixSize, minWidth: prefixSize),
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
                    padding: EdgeInsetsDirectional.only(start: spaceBeforeSuffix, end: spaceAfterSuffix),
                    child: suffixIcon,
                  )
                : null,
            suffixIconConstraints: BoxConstraints(minHeight: suffixSize, minWidth: suffixSize),
            border: fieldBorderType.inputBorder(color: fieldBorderColor, radius: borderRadius),
            enabledBorder: fieldBorderType.inputBorder(color: fieldBorderColor, radius: borderRadius),
            focusedBorder: fieldBorderType.inputBorder(color: fieldBorderFocusedColor, radius: borderRadius),
            errorBorder: fieldBorderType.inputBorder(color: AppColor.error, radius: borderRadius),
            errorStyle: const TextStyle(color: AppColor.error),
            errorText: errorText,
            errorMaxLines: 5,
          ),
          onTap: onTap,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
          validator: onValidate,
          onTapOutside: onTapOutside,
        ),
        if (spacerSize != null) CustomVerticalSpace(height: spacerSize!),
        SizedBox(height: bottomMargin),
      ],
    );
  }

  BorderType get fieldBorderType => borderType ?? BorderType.outline;
  Color get fieldBorderColor => borderColor ?? AppColor.blackModern300Light;
  Color get fieldBorderFocusedColor => borderColor ?? AppColor.primary900Light;
}

class CustomTextFieldWidgetWithOptinal extends StatelessWidget {
  // if app in different languages, pass the key to search about word
  final String label;
  final Color labelColor;
  final double labelSize;
  final TextAlign labelTextAlign;
  final bool isDigitsOnly;
  final bool filled;
  final Color fillColor;
  final double borderWidth;
  final double borderRadius;
  final Color borderColor;
  final BorderType borderType;

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool autoCorrect;
  final bool readOnly;
  final Color cursorColor;
  final TextAlign textFieldAlign;
  final TextInputType? keyboardType;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final TextAlignVertical textAlignVertical;
  final TextInputAction? textInputAction;
  final bool obsecureText;
  final TextStyle? textFieldStyle;
  final double contentVerticalPadding;
  final double contentHorizontalPadding;
  final String hintText;
  final TextStyle? hintStyle;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double prefixSize;
  final double? suffixSize;
  final int errorMaxLines;
  final double? spacerSize;
  final void Function(String)? onFieldSubmitted;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final VoidCallback? onTap;
  final List<TextInputFormatter>? inputFormatter;
  final TextDirection? textDirection;
  final bool? showOptional;

  const CustomTextFieldWidgetWithOptinal({
    super.key,
    required this.label,
    this.labelColor = AppColor.baladyDarkGreen2,
    this.labelSize = 13.0,
    this.labelTextAlign = TextAlign.start,
    this.isDigitsOnly = false,
    this.filled = false,
    this.textDirection,
    this.fillColor = Colors.transparent,
    this.borderWidth = 1.0,
    this.borderRadius = 2.0,
    this.borderColor = AppColor.black200,
    this.borderType = BorderType.underline,
    this.controller,
    this.focusNode,
    this.autoCorrect = true,
    this.readOnly = false,
    this.cursorColor = AppColor.baladyDarkGreen2,
    this.textFieldAlign = TextAlign.start,
    this.keyboardType,
    this.maxLength,
    this.maxLines,
    this.minLines,
    this.textAlignVertical = TextAlignVertical.center,
    this.textInputAction = TextInputAction.done,
    this.obsecureText = false,
    this.textFieldStyle,
    this.contentHorizontalPadding = 10,
    this.contentVerticalPadding = GeneralKey.semiSmallPadding,
    this.hintText = '',
    this.hintStyle,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixSize = 25.0,
    this.suffixSize,
    this.errorMaxLines = 2,
    this.spacerSize = 30.0,
    this.onFieldSubmitted,
    this.onChanged,
    this.onSaved,
    this.validator,
    this.onTap,
    this.inputFormatter,
    this.showOptional,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // label
        LabelTextWithOptional(
          label: label,
          labelColor: labelColor,
          labelSize: labelSize,
          labelTextAlign: labelTextAlign,
          showOptional: showOptional,
        ),

        LayoutBuilder(
          builder: (context, constraints) {
            return Row(
              children: [
                // prefix
                if (prefixIcon != null)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomHorizontalSpace(width: 5.0),
                      SizedBox(
                        width: prefixSize,
                        height: prefixSize,
                        child: FittedBox(child: prefixIcon),
                      ),
                      const CustomHorizontalSpace(width: 5.0),
                    ],
                  ),
                Expanded(
                  child: TextFormField(
                    controller: controller,
                    textDirection: textDirection,
                    focusNode: focusNode,
                    autocorrect: autoCorrect,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    readOnly: readOnly,
                    cursorColor: cursorColor,
                    keyboardType: keyboardType,
                    maxLines: obsecureText ? 1 : maxLines,
                    maxLength: maxLength,
                    minLines: obsecureText ? 1 : minLines,
                    obscureText: obsecureText,
                    textAlignVertical: textAlignVertical,
                    textInputAction: textInputAction,
                    inputFormatters:
                        inputFormatter ??
                        [
                          if (isDigitsOnly) ...[_arabicToLatinDigits, FilteringTextInputFormatter.digitsOnly],
                        ],
                    style:
                        textFieldStyle ??
                        const TextStyle(
                          fontSize: 16.0,
                          fontFamily: GeneralKey.appFontType,
                          color: AppColor.black,
                          fontWeight: FontWeight.w500,
                        ),
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: contentHorizontalPadding,
                        vertical: contentVerticalPadding,
                      ),
                      // counter: const SizedBox(),
                      hintText: hintText,

                      hintStyle:
                          hintStyle ??
                          const TextStyle(
                            fontSize: 16.0,
                            fontFamily: GeneralKey.appFontType,
                            color: AppColor.black300,
                            fontWeight: FontWeight.w500,
                          ),
                      filled: filled,
                      fillColor: readOnly ? AppColor.black400 : fillColor,
                      enabledBorder: _getBorder(borderColor),
                      focusedBorder: _getBorder(AppColor.primary900Light),
                      errorBorder: _getBorder(AppColor.redBrown),
                      hintTextDirection: textDirection,
                      focusedErrorBorder: _getBorder(AppColor.redBrown),
                      errorMaxLines: errorMaxLines,
                      errorStyle: const TextStyle(color: AppColor.redBrown),
                      suffixIcon: suffixIcon,
                      suffixIconConstraints: suffixSize != null
                          ? BoxConstraints(minHeight: suffixSize!, minWidth: suffixSize!)
                          : null,
                    ),
                    onChanged: onChanged,
                    onFieldSubmitted: onFieldSubmitted,
                    validator: (value) => validator!(value),
                    onSaved: onSaved,
                    onTap: /*readOnly
                        ? () => CustomPopUpsWidgets.showWarningMessageDialog(
                              context,
                              Helpers.translatingWord("fieldReadOnlyWord"),
                            )
                        :*/
                        onTap,
                  ),
                ),
              ],
            );
          },
        ),
        if (spacerSize != null) CustomVerticalSpace(height: spacerSize!),
      ],
    );
  }

  InputBorder _getBorder(Color borderColor) {
    switch (borderType) {
      case BorderType.none:
        return InputBorder.none;
      case BorderType.outline:
        return OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: borderColor, width: borderWidth),
        );
      case BorderType.underline:
        return UnderlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: borderColor, width: borderWidth),
        );
    }
  }
}

class CustomTextFieldWithValueWidget extends StatefulWidget {
  final bool enabled;
  final String? label;
  final TextStyle? labelStyle;
  final bool isRequired;
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
  final String? value;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final void Function()? onTap;
  final String? Function(String?)? onValidate;

  const CustomTextFieldWithValueWidget({
    super.key,
    this.enabled = true,
    this.label,
    this.labelStyle,
    this.isRequired = false,
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
    this.value,
  });

  @override
  State<CustomTextFieldWithValueWidget> createState() => _CustomTextFieldWithValueWidgetState();
}

class _CustomTextFieldWithValueWidgetState extends State<CustomTextFieldWithValueWidget> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.text = widget.value ?? "";
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        // if field is required, then show label beside asterisk e.g. *Username
        WidgetLabel(isRequired: widget.isRequired, label: widget.label, labelStyle: widget.labelStyle),
        // Field
        TextFormField(
          enabled: widget.enabled,
          controller: controller,
          focusNode: widget.focusNode,
          autocorrect: widget.autocorrect,
          autofillHints: widget.autofillHints,
          autovalidateMode: widget.autovalidateMode ?? AutovalidateMode.onUserInteraction,
          cursorColor: widget.cursorColor ?? AppColor.blue,
          cursorHeight: widget.cursorHeight,
          showCursor: widget.showCursor,
          cursorWidth: widget.cursorWidth,
          initialValue: widget.initialValue,
          scrollPadding: EdgeInsets.only(
            // (13.0 * 4.0) => (fontSize * 4.0)
            bottom: MediaQuery.of(context).viewInsets.bottom + (13.0 * 4.0),
          ),
          inputFormatters:
              widget.inputFormatters ??
              [
                if (widget.isDigitsOnly) ...[_arabicToLatinDigits, FilteringTextInputFormatter.digitsOnly],
                if (widget.allowedInputPattern != null) FilteringTextInputFormatter.allow(widget.allowedInputPattern!),
                if (widget.deniedInputPattern != null) FilteringTextInputFormatter.deny(widget.deniedInputPattern!),
              ],
          keyboardType: widget.keyboardType,
          maxLength: widget.maxLength,
          maxLines: widget.maxLines,
          obscureText: widget.obsecureText,
          readOnly: widget.readOnly,
          textAlign: widget.textAlign ?? TextAlign.start,
          textInputAction: widget.textInputAction,
          style: widget.textFieldStyle ?? AppStyle.mainTextThirdStyle.copyWith(fontSize: 13.0, color: AppColor.black),
          decoration: InputDecoration(
            constraints: BoxConstraints(
              maxWidth: widget.textFieldWidth ?? double.infinity,
              maxHeight: widget.textFieldHeight ?? double.infinity,
            ),
            hintText: widget.hintText,
            hintStyle: widget.hintStyle,
            filled: widget.filled,
            fillColor: widget.readOnly ? widget.disabledColor ?? AppColor.gray : widget.fillColor ?? Colors.transparent,
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
              widget.prefixIcon == null ? widget.startPadding : 0.0,
              widget.textFieldVerticalPadding,
              widget.suffixIcon == null ? widget.endPadding : 0.0,
              widget.textFieldVerticalPadding,
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
            prefixIcon: widget.prefixIcon != null
                ? Padding(
                    // color: Colors.red,
                    padding: EdgeInsetsDirectional.only(start: widget.spaceBeforePrefix, end: widget.spaceAfterPrefix),
                    child: widget.prefixIcon,
                  )
                : null,
            prefixIconConstraints: BoxConstraints(minHeight: widget.prefixSize, minWidth: widget.prefixSize),
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
            suffixIcon: widget.suffixIcon != null
                ? Padding(
                    // color: Colors.red,
                    padding: EdgeInsetsDirectional.only(start: widget.spaceBeforeSuffix, end: widget.spaceAfterSuffix),
                    child: widget.suffixIcon,
                  )
                : null,
            suffixIconConstraints: BoxConstraints(minHeight: widget.suffixSize, minWidth: widget.suffixSize),
            border: fieldBorderType.inputBorder(color: fieldBorderColor, radius: widget.borderRadius),
            enabledBorder: fieldBorderType.inputBorder(color: fieldBorderColor, radius: widget.borderRadius),
            focusedBorder: fieldBorderType.inputBorder(color: fieldBorderFocusedColor, radius: widget.borderRadius),
            errorBorder: fieldBorderType.inputBorder(color: AppColor.error, radius: widget.borderRadius),
            errorStyle: const TextStyle(color: AppColor.error),
            errorText: widget.errorText,
          ),
          onTap: widget.onTap,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          validator: widget.onValidate,
        ),
      ],
    );
  }

  BorderType get fieldBorderType => widget.borderType ?? BorderType.outline;

  Color get fieldBorderColor => widget.borderColor ?? AppColor.blackModern300Light;

  Color get fieldBorderFocusedColor => widget.borderColor ?? AppColor.primary900Light;
}

final _arabicToLatinDigits = TextInputFormatter.withFunction((oldValue, newValue) {
  const arabic = '٠١٢٣٤٥٦٧٨٩';
  final converted = newValue.text.splitMapJoin(
    RegExp('[٠-٩]'),
    onMatch: (m) => arabic.indexOf(m[0]!).toString(),
    onNonMatch: (s) => s,
  );
  return converted == newValue.text ? newValue : newValue.copyWith(text: converted);
});
