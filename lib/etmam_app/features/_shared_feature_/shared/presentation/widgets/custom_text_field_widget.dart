import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show
        AppColor,
        AppColorsTheme,
        AppConfig,
        AppFontWeight,
        BorderType,
        UIHelper;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show CustomVerticalSpace, CustomHorizontalSpace, CustomTextWidget;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFieldWidget extends StatelessWidget {
  final String label;
  final Color labelColor;
  final double labelSize;
  final TextAlign labelTextAlign;

  final bool filled;
  final Color fillColor;
  final double borderWidth;
  final double borderRadius;
  final Color borderColor;
  final BorderType borderType;

  final TextEditingController controller;
  final FocusNode? focusNode;
  final bool autoCorrect;
  final bool readOnly;
  final Color? cursorColor;
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
  final double spacerSize;
  final void Function(String)? onFieldSubmitted;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final VoidCallback? onTap;
  final List<TextInputFormatter>? inputFormatter;
  final TextDirection? textDirection;
  final AppFontWeight labelFontWeight;

  const CustomTextFieldWidget(
      {Key? key,
      required this.label,
      this.labelColor = AppColor.bottomNavigationShadow,
      this.labelSize = 13.0,
      this.labelTextAlign = TextAlign.start,
      this.labelFontWeight = AppFontWeight.bold,
      this.filled = false,
      this.textDirection,
      this.fillColor = Colors.transparent,
      this.borderWidth = 1.0,
      this.borderRadius = 2.0,
      this.borderColor = AppColor.black200,
      this.borderType = BorderType.underline,
      required this.controller,
      this.focusNode,
      this.autoCorrect = true,
      this.readOnly = false,
      this.cursorColor,
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
      this.contentVerticalPadding = UIHelper.littlePadding,
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
      this.inputFormatter})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // label
        if (label.isNotEmpty) ...[
          CustomTextWidget(
            label,
            fontColor: labelColor,
            fontSize: labelSize,
            textAlign: labelTextAlign,
            fontWeight: labelFontWeight,
          ),
          CustomVerticalSpace(height: 16),
        ],
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
                // text field
                Expanded(
                  //  width: _getTextFieldWidth(constraints.maxWidth),
                  // width: constraints.maxWidth,
                  child: MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
                    child: TextFormField(
                      controller: controller,
                      textDirection: textDirection,
                      focusNode: focusNode ?? FocusNode(),
                      autocorrect: autoCorrect,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      readOnly: readOnly,
                      cursorColor: cursorColor ?? AppColor.darkTurquoise,
                      keyboardType: keyboardType,
                      maxLines: obsecureText ? 1 : maxLines,
                      maxLength: maxLength,
                      minLines: obsecureText ? 1 : minLines,
                      obscureText: obsecureText,
                      textAlignVertical: textAlignVertical,
                      textInputAction: textInputAction,
                      inputFormatters: inputFormatter,
                      style: textFieldStyle ??
                          const TextStyle(
                              fontSize: 16.0,
                              fontFamily: AppConfig.appFontType,
                              color: AppColor.black,
                              fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: contentHorizontalPadding,
                          vertical: contentVerticalPadding,
                        ),
                        // counter: const SizedBox(),
                        hintText: hintText,
                        hintStyle: hintStyle ??
                            const TextStyle(
                                fontSize: 16.0,
                                fontFamily: AppConfig.appFontType,
                                color: AppColor.black300,
                                fontWeight: FontWeight.w500),
                        filled: filled,
                        fillColor: readOnly ? AppColor.black400 : fillColor,
                        enabledBorder: _getBorder(borderColor),
                        focusedBorder: _getBorder(AppColor.darkTurquoise),
                        errorBorder: _getBorder(AppColor.redBrown),
                        hintTextDirection: textDirection,
                        focusedErrorBorder: _getBorder(AppColor.redBrown),
                        errorMaxLines: errorMaxLines,
                        errorStyle: const TextStyle(color: AppColor.redBrown),
                        suffixIcon: suffixIcon,
                        suffixIconConstraints: suffixSize != null
                            ? BoxConstraints(
                                minHeight: suffixSize!, minWidth: suffixSize!)
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
                ),
              ],
            );
          },
        ),
        CustomVerticalSpace(height: spacerSize),
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

class CustomSearchTextFieldWidget extends StatelessWidget {
  final String label;
  final Color labelColor;
  final double labelSize;
  final TextAlign labelTextAlign;

  final bool filled;
  final Color fillColor;
  final double borderWidth;
  final double borderRadius;
  final Color borderColor;
  final BorderType borderType;

  final TextEditingController controller;
  final FocusNode? focusNode;
  final bool autoCorrect;
  final bool readOnly;
  final Color? cursorColor;
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
  final double spacerSize;
  final void Function(String)? onFieldSubmitted;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final VoidCallback? onTap;
  final List<TextInputFormatter>? inputFormatter;
  final TextDirection? textDirection;

  const CustomSearchTextFieldWidget(
      {Key? key,
      required this.label,
      this.labelColor = AppColor.bottomNavigationShadow,
      this.labelSize = 13.0,
      this.labelTextAlign = TextAlign.start,
      this.filled = false,
      this.textDirection,
      this.fillColor = Colors.transparent,
      this.borderWidth = 1.0,
      this.borderRadius = 2.0,
      this.borderColor = AppColor.black200,
      this.borderType = BorderType.underline,
      required this.controller,
      this.focusNode,
      this.autoCorrect = true,
      this.readOnly = false,
      this.cursorColor,
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
      this.contentVerticalPadding = UIHelper.littlePadding,
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
      this.inputFormatter})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // label
        if (label.isNotEmpty)
          CustomTextWidget(
            label,
            fontColor: labelColor,
            fontSize: labelSize,
            textAlign: labelTextAlign,
            fontWeight: AppFontWeight.bold,
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
                // text field
                Expanded(
                  //  width: _getTextFieldWidth(constraints.maxWidth),
                  // width: constraints.maxWidth,
                  child: MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
                    child: TextFormField(
                      controller: controller,
                      textDirection: textDirection,
                      focusNode: focusNode ?? FocusNode(),
                      autocorrect: autoCorrect,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      readOnly: readOnly,
                      cursorColor: cursorColor ?? AppColor.darkTurquoise,
                      keyboardType: keyboardType,
                      maxLines: obsecureText ? 1 : maxLines,
                      maxLength: maxLength,
                      minLines: obsecureText ? 1 : minLines,
                      obscureText: obsecureText,
                      textAlignVertical: textAlignVertical,
                      textInputAction: textInputAction,
                      inputFormatters: inputFormatter,
                      style: textFieldStyle ??
                          const TextStyle(
                              fontSize: 16.0,
                              fontFamily: AppConfig.appFontType,
                              color: AppColor.black,
                              fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: contentHorizontalPadding,
                          vertical: contentVerticalPadding,
                        ),
                        // counter: const SizedBox(),
                        hintText: hintText,
                        hintStyle: hintStyle ??
                            const TextStyle(
                                fontSize: 16.0,
                                fontFamily: AppConfig.appFontType,
                                color: AppColor.black300,
                                fontWeight: FontWeight.w500),
                        filled: filled,
                        fillColor: readOnly ? AppColor.black400 : fillColor,
                        enabledBorder: _getBorder(borderColor),
                        focusedBorder: _getBorder(AppColor.darkTurquoise),
                        errorBorder: _getBorder(AppColor.redBrown),
                        hintTextDirection: textDirection,
                        focusedErrorBorder: _getBorder(AppColor.redBrown),
                        errorMaxLines: errorMaxLines,
                        errorStyle: const TextStyle(color: AppColor.redBrown),
                        suffixIcon: suffixIcon,
                        suffixIconConstraints: suffixSize != null
                            ? BoxConstraints(
                                minHeight: suffixSize!, minWidth: suffixSize!)
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
                ),
              ],
            );
          },
        ),
        CustomVerticalSpace(height: spacerSize),
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
