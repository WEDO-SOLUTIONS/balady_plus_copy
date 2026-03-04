import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/widgets/smooth_rectangle_input_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BaladyTextField extends StatelessWidget {
  final BaladyInputConfig config;
  final TextEditingController controller;
  final bool showCursor;
  final double cursorWidth;
  final EdgeInsetsDirectional contentPadding;
  final BaladyInputStyle inputStyle;
  final BaladyInputState inputState;
  final bool truncateText;

  const BaladyTextField({
    required this.config,
    required this.controller,
    required this.showCursor,
    required this.cursorWidth,
    required this.contentPadding,
    required this.inputStyle,
    required this.inputState,
    required this.truncateText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final fillColor = config.fillColor ?? config.background.getFillColor(context);
    final minHeight = config.textFieldHeight < BaladyInputConfig.defaultTextFieldHeight
        ? config.textFieldHeight
        : BaladyInputConfig.defaultTextFieldHeight;
    final defaultTextStyle = context.textStyles.bodyLargeRegular;
    final errorColor = context.colors.errorDefault;

    final textStyle = _textStyle(context);
    return Stack(
      children: [
        TextFormField(
          key: config.stateKey ?? const Key('BaladyInputField'),
          enabled: !inputState.isDisabled,
          controller: controller,
          focusNode: config.focusNode,
          autocorrect: config.autocorrect,
          autofillHints: config.autofillHints,
          autovalidateMode: config.autovalidateMode ?? AutovalidateMode.onUserInteraction,
          cursorColor: context.colors.accentDefault,
          showCursor: showCursor,
          cursorWidth: cursorWidth,
          autofocus: config.autofocus ?? false,
          scrollPadding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + (13.0 * 4.0), //(fontSize * 4.0)
          ),
          inputFormatters: config.inputFormatters ?? _customInputFormatters,
          keyboardType: config.keyboardType,
          maxLines: config.maxLines,
          obscureText: config.obscureText,
          readOnly: inputState.isReadOnly,
          textAlign: config.textAlign ?? TextAlign.start,
          textInputAction: config.textInputAction,
          style: textStyle.copyWith(
            color: truncateText ? Colors.transparent : textStyle.color,
          ),
          decoration: InputDecoration(
            constraints: BoxConstraints(
              minHeight: minHeight,
              maxWidth: config.textFieldWidth ?? double.infinity,
              maxHeight: inputStyle == BaladyInputStyle.search ? config.textFieldHeight : double.infinity,
            ),
            hintText: config.hintText,
            hintStyle: (config.textStyle ?? defaultTextStyle).copyWith(
              color: config.hintColor ?? context.colors.foregroundMuted,
            ),
            filled: true,
            fillColor: fillColor,
            contentPadding: contentPadding,
            border: _transparentRoundedBorder,
            error: config.onValidate?.call(controller.text) == null
                ? inputState.isError
                    ? const SizedBox.shrink()
                    : null
                : null,
            focusedErrorBorder:
                config.highlightFocusedBorder ? _coloredRoundedBorder(errorColor) : _transparentRoundedBorder,
            disabledBorder: _transparentRoundedBorder,
            enabledBorder: _transparentRoundedBorder,
            focusedBorder: config.highlightFocusedBorder
                ? _coloredRoundedBorder(context.colors.accentDefault)
                : _transparentRoundedBorder,
            errorBorder: _transparentRoundedBorder,
          ),
          onTap: () {
            if (truncateText) config.focusNode?.requestFocus();
            controller.selection = TextSelection.fromPosition(
              TextPosition(
                offset: controller.text.length,
              ),
            );
            config.onTap?.call();
          },
          onChanged: config.onChanged,
          onFieldSubmitted: config.onSubmitted,
          validator: config.onValidate,
          onTapOutside: config.onTapOutside,
        ),
        if (truncateText)
          IgnorePointer(
            child: Container(
              alignment: AlignmentDirectional.centerStart,
              height: minHeight,
              child: Padding(
                padding: contentPadding,
                child: Text(
                  controller.text,
                  maxLines: config.maxLines,
                  style: textStyle.copyWith(
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  TextStyle _textStyle(BuildContext context) {
    final baseStyle = config.textStyle ??
        switch (inputStyle) {
          BaladyInputStyle.input => context.textStyles.captionMediumRegular,
          BaladyInputStyle.multiline => context.textStyles.captionMediumRegular,
          BaladyInputStyle.search => context.textStyles.bodySmallRegular,
        };
    final style = baseStyle.copyWith(
      overflow: TextOverflow.ellipsis,
    );

    final defaultColor = config.textColor ?? context.colors.foregroundDefault;

    if (inputState.isDisabled) {
      final disabledColor = defaultColor.withOpacity(0.4);
      return style.copyWith(color: disabledColor);
    }

    if (inputState.isError) {
      final errorColor = context.colors.errorDefault;
      return style.copyWith(color: errorColor);
    }

    return style.copyWith(color: defaultColor);
  }

  List<TextInputFormatter> get _customInputFormatters => [
        if (config.isDigitsOnly) FilteringTextInputFormatter.digitsOnly,
        if (config.allowedInputPattern != null) FilteringTextInputFormatter.allow(config.allowedInputPattern!),
        if (config.deniedInputPattern != null) FilteringTextInputFormatter.deny(config.deniedInputPattern!),
      ];

  InputBorder? get _transparentRoundedBorder => SmoothRectangleInputBorder(
        smoothness: 0.6,
        side: const BorderSide(
          color: Colors.transparent,
          width: 0,
        ),
        borderRadius: BorderRadius.circular(config.radiusBorder ?? RadiusBorder.l),
      );

  InputBorder? _coloredRoundedBorder(Color color) => SmoothRectangleInputBorder(
        side: BorderSide(color: color),
        smoothness: .6,
        borderRadius: BorderRadius.circular(config.radiusBorder ?? RadiusBorder.l),
      );
}
