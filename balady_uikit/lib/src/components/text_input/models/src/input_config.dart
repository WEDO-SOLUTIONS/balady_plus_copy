import 'package:balady_uikit/core/typedef/app_typedef.dart';
import 'package:balady_uikit/src/components/text_input/input_styles.dart';
import 'package:balady_uikit/src/layouts/sizes.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class BaladyInputConfig {
  static const defaultTextFieldHeight = AppSizes.l;
  static const defaultSearchHeight = AppSizes.m;

  /// GlobalKey needed to access to FormFieldState
  final GlobalKey<FormFieldState<String>>? stateKey;
  final String? hintText;
  final String? initialValue;
  final bool isDisposed;
  final BaladyInputBackground background;
  final double? textFieldWidth;
  final double textFieldHeight;

  // --- DEFAULT TEXT FORM FIELD PROPERTIES --- //

  final FocusNode? focusNode;
  final bool autocorrect;
  final List<String>? autofillHints;
  final AutovalidateMode? autovalidateMode;
  final List<TextInputFormatter>? inputFormatters;
  final bool isDigitsOnly;
  final Pattern? allowedInputPattern;
  final Pattern? deniedInputPattern;
  final int? maxLines;
  final bool obscureText;
  final TextAlign? textAlign;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final OnStringChanged? onChanged;
  final OnStringChanged? onSubmitted;
  final OnTap? onTap;
  final OnTapOutside? onTapOutside;
  final OnValidate? onValidate;
  final bool highlightFocusedBorder;
  final bool? autofocus;
  final Color? fillColor;
  final Color? hintColor;
  final Color? textColor;
  final double? radiusBorder;
  final TextStyle? textStyle;

  const BaladyInputConfig({
    this.maxLines = 1,
    this.background = BaladyInputBackground.white,
    this.textFieldHeight = defaultTextFieldHeight,
    this.isDigitsOnly = false,
    this.autocorrect = false,
    this.obscureText = false,
    this.isDisposed = true,
    this.highlightFocusedBorder = true,
    this.autofocus = false,
    this.stateKey,
    this.hintText,
    this.initialValue,
    this.focusNode,
    this.autofillHints,
    this.autovalidateMode,
    this.inputFormatters,
    this.allowedInputPattern,
    this.deniedInputPattern,
    this.textAlign,
    this.textInputAction,
    this.keyboardType,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.onTapOutside,
    this.onValidate,
    this.textFieldWidth,
    this.fillColor,
    this.hintColor,
    this.textColor,
    this.radiusBorder,
    this.textStyle,
  });

  BaladyInputConfig copyWith({
    String? hintText,
    String? initialValue,
    FocusNode? focusNode,
    bool? autocorrect,
    List<String>? autofillHints,
    AutovalidateMode? autovalidateMode,
    List<TextInputFormatter>? inputFormatters,
    bool? isDigitsOnly,
    Pattern? allowedInputPattern,
    Pattern? deniedInputPattern,
    int? maxLength,
    int? maxLines,
    bool? obscureText,
    TextAlign? textAlign,
    TextInputAction? textInputAction,
    TextInputType? keyboardType,
    OnStringChanged? onChanged,
    OnStringChanged? onSubmitted,
    OnTap? onTap,
    OnTapOutside? onTapOutside,
    OnValidate? onValidate,
    double? textFieldWidth,
    double? textFieldHeight,
    bool? highlightFocusedBorder,
    bool? autofocus,
    Color? fillColor,
    Color? hintColor,
    Color? textColor,
    double? radiusBorder,
    TextStyle? textStyle,
    bool? isDisposed,
    BaladyInputBackground? background,
  }) {
    return BaladyInputConfig(
      hintText: hintText ?? this.hintText,
      initialValue: initialValue ?? this.initialValue,
      focusNode: focusNode ?? this.focusNode,
      autocorrect: autocorrect ?? this.autocorrect,
      autofillHints: autofillHints ?? this.autofillHints,
      autovalidateMode: autovalidateMode ?? this.autovalidateMode,
      inputFormatters: inputFormatters ?? this.inputFormatters,
      isDigitsOnly: isDigitsOnly ?? this.isDigitsOnly,
      allowedInputPattern: allowedInputPattern ?? this.allowedInputPattern,
      deniedInputPattern: deniedInputPattern ?? this.deniedInputPattern,
      maxLines: maxLines ?? this.maxLines,
      obscureText: obscureText ?? this.obscureText,
      textAlign: textAlign ?? this.textAlign,
      textInputAction: textInputAction ?? this.textInputAction,
      keyboardType: keyboardType ?? this.keyboardType,
      onChanged: onChanged ?? this.onChanged,
      onSubmitted: onSubmitted ?? this.onSubmitted,
      onTap: onTap ?? this.onTap,
      onTapOutside: onTapOutside ?? this.onTapOutside,
      onValidate: onValidate ?? this.onValidate,
      textFieldWidth: textFieldWidth ?? this.textFieldWidth,
      textFieldHeight: textFieldHeight ?? this.textFieldHeight,
      highlightFocusedBorder: highlightFocusedBorder ?? this.highlightFocusedBorder,
      autofocus: autofocus ?? this.autofocus,
      fillColor: fillColor ?? this.fillColor,
      hintColor: hintColor ?? this.hintColor,
      textColor: textColor ?? this.textColor,
      radiusBorder: radiusBorder ?? this.radiusBorder,
      textStyle: textStyle ?? this.textStyle,
      isDisposed: isDisposed ?? this.isDisposed,
      background: background ?? this.background,
    );
  }
}
