import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/typedef/app_typedef.dart';
import 'package:balady_uikit/core/widgets/smooth_rectangle_input_border.dart';
import 'package:balady_uikit/src/components/text_input/widgets/input_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const _defaultTextFieldHeight = AppSizes.l;
const _defaultSearchHeight = AppSizes.m;

/// A text input field with a label, hint text, and supporting text.
/// It contains a clear button to clear the text field.
/// It also has a validation error message and error state.
/// It can be used for search, text, password, and other input types.
///
/// The [BaladyInput] widget is a wrapper around the [TextFormField] widget.
///
/// Expample:
/// ```dart
/// final input = BaladyInput(
///   labelText: 'Label',
///   hintText: 'Hint',
///   supportingText: 'Supporting text',
///   initialValue: 'Initial value',
///   isRequired: true,
/// );
/// ```
///
/// See also:
/// * [Figma]
/// https://www.figma.com/file/owbsr9Pf0mQSEHXlbiPGOv/Balady-%E2%80%93-Components-Library?type=design&node-id=2248%3A6641&mode=design&t=20OcgdYeLqsLY5l8-1
@Deprecated('Use [BaladyTextInput] instead')
class BaladyInput extends StatefulWidget {
  // TODO(ilyasov) remove after implementing new inputs

  /// GlobalKey needed to access to FormFieldState
  final GlobalKey<FormFieldState<String>>? stateKey;

  /// If true, the input field will be enabled and the user will be able to change it.
  /// By default, it is true.
  /// If it is false, the input field will be displayed as disabled with specific colors.
  final bool enabled;

  /// If true, the input field will be read-only and the user will not be able to change it.
  /// But the user can still select the text and copy it.
  /// It will be shown as the default input field.
  final bool readOnly;

  /// The label text to display above the input field.
  /// It is null by default and it will not be displayed.
  /// If it is not null and not empty it will be displayed.
  /// It is not required.
  /// If [isRequired] field is true it will be displayed with an asterisk.
  ///
  /// TextStyle: [caption]
  /// Color: [textAndIconsBaseSecondary]
  final String? labelText;

  /// False by default.
  /// If true, the input field will be required and the label will be displayed with an asterisk.
  final bool isRequired;

  /// The hint text to display inside the input field when it is empty.
  ///
  /// TextStyle: [text]
  /// Color: [textAndIconsBaseTertiary]
  final String? hintText;

  /// The supporting text to display below the input field.
  /// It is null by default and it will not be displayed.
  /// If it is not null it will be displayed.
  /// If [errorText] field is not null it will not be displayed.
  ///
  /// TextStyle: [footNoteBold]
  /// Color: [textAndIconsBaseTertiary]
  final String? supportingText;

  /// The error text to display below the input field.
  /// It is null by default and it will not be displayed.
  /// If it is not null it will be displayed and the input field will be in error state.
  /// So if you have an error you should set this field to switch the input field to error state.
  ///
  /// TextStyle: [footNoteBold]
  /// Color: [textAndIconsStatusNegative]
  final String? errorText;

  /// The initial value to display inside the input field.
  /// If a [controller] is not specified, [initialValue] can be used to give
  /// the automatically generated controller an initial value.
  final String? initialValue;

  /// The controller to control the input field.
  /// It is null by default and it will be created automatically.
  final TextEditingController? controller;

  /// If true, the input field will accept only digits.
  /// False by default.
  final bool isDigitsOnly;

  /// A pattern to allow the input field to accept only specific characters.
  /// It is null by default and it will accept any character.
  final Pattern? allowedInputPattern;

  /// A pattern to deny the input field from accepting specific characters.
  /// It is null by default and it will accept any character.
  final Pattern? deniedInputPattern;

  /// The max width of the input field.
  final double? textFieldWidth;

  /// The max height of the input field.
  /// Default value is [_defaultTextFieldHeight].
  final double textFieldHeight;

  /// A widget to display before the input field.
  /// It is null by default and it will not be displayed.
  /// Could be an icon or any other widget.
  final BaladyInputAffixBase? prefixConfig;

  /// A widget to display after the input field.
  /// It is null by default and it will be a clear button with clear method
  /// if the text field is not empty.
  /// If it is not null it will be displayed after the input field.
  final BaladyInputAffixBase? suffixConfig;

  /// The background color of the input field.
  final BaladyInputBackground background;

  // --- DEFAULT TEXT FORM FIELD PROPERTIES --- //
  final FocusNode? focusNode;
  final bool autocorrect;
  final List<String>? autofillHints;
  final AutovalidateMode? autovalidateMode;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final int maxLines;
  final bool obscureText;
  final TextAlign? textAlign;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final OnStringChanged? onChanged;
  final OnStringChanged? onSubmitted;
  final OnTap? onTap;
  final OnTapOutside? onTapOutside;
  final OnValidate? onValidate;
  final bool higlighFocusedBorder;
  final bool? autofocus;
  final Color? fillColor;
  final Color? hintColor;
  final Color? textColor;
  final double? radiusBorder;
  final TextStyle? textStyle;
  final TextStyle? labelStyle;
  final bool isDisposed;

  /// The style of the input field.
  final BaladyInputStyle? inputStyle;

  /// Base constructor for the [BaladyInput] widget.
  const BaladyInput({
    super.key,
    this.stateKey,
    this.enabled = true,
    this.labelText,
    this.hintText,
    this.supportingText,
    this.errorText,
    this.initialValue,
    this.isRequired = false,
    this.controller,
    this.focusNode,
    this.autocorrect = false,
    this.autofillHints,
    this.autovalidateMode,
    this.isDigitsOnly = false,
    this.allowedInputPattern,
    this.deniedInputPattern,
    this.inputFormatters,
    this.maxLength,
    this.maxLines = 1,
    this.obscureText = false,
    this.readOnly = false,
    this.textAlign,
    this.textInputAction,
    this.keyboardType,
    this.prefixConfig,
    this.suffixConfig,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.onTapOutside,
    this.onValidate,
    this.textFieldWidth,
    this.textFieldHeight = _defaultTextFieldHeight,
    this.higlighFocusedBorder = true,
    this.autofocus = false,
    this.fillColor,
    this.hintColor,
    this.textColor,
    this.radiusBorder,
    this.textStyle,
    this.labelStyle,
    this.isDisposed = true,
    this.background = BaladyInputBackground.white,
    this.inputStyle,
  });

  /// A constructor to create a search input field.
  /// Because search input is a specific input field, it has restricted properties.
  ///
  /// A [hintText] is required because of different locale languages but it should not depends on localization files.
  /// A [prefixConfig] is set by default to [GeneralIcons.search] and should not be changed.
  /// The [suffixConfig] is set by default to a clear button and should not be changed.
  /// The [obscureText] is set by default to false and should not be changed.
  ///
  /// Example:
  /// ```dart
  /// final searchInput = BaladyInput.search(
  ///   hintText: _getHintText(isArabic),
  ///   labelText: showLabel ? _getLabel(isArabic) : null,
  ///   errorText: null,
  ///   enabled: true,
  ///   controller: null,
  /// ),
  /// ```
  ///
  /// See also:
  /// * [Figma]
  /// https://www.figma.com/file/owbsr9Pf0mQSEHXlbiPGOv/Balady-%E2%80%93-Components-Library?type=design&node-id=2248%3A6641&mode=design&t=20OcgdYeLqsLY5l8-1
  factory BaladyInput.searchV2({
    required String hintText,
    bool enabled = true,
    String? labelText,
    String? errorText,
    String? initialValue,
    bool isRequired = false,
    TextEditingController? controller,
    FocusNode? focusNode,
    bool autocorrect = false,
    List<String>? autofillHints,
    AutovalidateMode? autovalidateMode,
    bool isDigitsOnly = false,
    Pattern? allowedInputPattern,
    Pattern? deniedInputPattern,
    List<TextInputFormatter>? inputFormatters,
    int? maxLength,
    int maxLines = 1,
    bool readOnly = false,
    TextAlign? textAlign,
    TextInputType? keyboardType,
    OnStringChanged? onChanged,
    OnStringChanged? onSubmitted,
    OnTap? onTap,
    OnTapOutside? onTapOutside,
    OnValidate? onValidate,
    double? textFieldWidth,
    double textFieldHeight = _defaultSearchHeight,
    bool? autofocus,
    Color? fillColor,
    Color? hintColor,
    Color? textColor,
    TextStyle? textStyle,
  }) =>
      BaladyInput(
        hintText: hintText,
        prefixConfig: const BaladyInputAffixIcon(
          icon: SystemIcons.search,
        ),
        enabled: enabled,
        labelText: labelText,
        errorText: errorText,
        initialValue: initialValue,
        isRequired: isRequired,
        controller: controller,
        focusNode: focusNode,
        autocorrect: autocorrect,
        autofocus: autofocus,
        autofillHints: autofillHints,
        autovalidateMode: autovalidateMode,
        isDigitsOnly: isDigitsOnly,
        allowedInputPattern: allowedInputPattern,
        deniedInputPattern: deniedInputPattern,
        inputFormatters: inputFormatters,
        maxLength: maxLength,
        maxLines: maxLines,
        readOnly: readOnly,
        textAlign: textAlign,
        textInputAction: TextInputAction.search,
        keyboardType: keyboardType,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        onTap: onTap,
        onTapOutside: onTapOutside,
        onValidate: onValidate,
        textFieldWidth: textFieldWidth,
        textFieldHeight: textFieldHeight,
        higlighFocusedBorder: false,
        fillColor: fillColor,
        hintColor: hintColor,
        textColor: textColor,
        radiusBorder: RadiusBorder.m,
        textStyle: textStyle,
        inputStyle: BaladyInputStyle.search,
      );

  @override
  State<BaladyInput> createState() => _BaladyInputState();
}

class _BaladyInputState extends State<BaladyInput> {
  late final TextEditingController _controller;
  bool _showClearButton = false;
  bool _showCursor = true;
  double _cursorWidth = 2.0;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController(text: widget.initialValue);
    _controller.addListener(() {
      _hideCursorOnArabic(Directionality.of(context) == TextDirection.rtl);
      _setShowClearButton(_controller.text.isNotEmpty);
    });
  }

  /// BALADY-708: Hide cursor when typing space in Arabic
  /// This logic is presented in iPhone search input
  void _hideCursorOnArabic(bool isArabic) {
    if (!isArabic) {
      return;
    }
    if (_controller.text.isEmpty) {
      return;
    }
    final lastChar = _controller.text[_controller.text.length - 1];
    if (lastChar == ' ') {
      setState(() {
        _showCursor = false;
        _cursorWidth = 0;
      });
    } else {
      setState(() {
        _showCursor = true;
        _cursorWidth = 2;
      });
    }
  }

  void _setShowClearButton(bool value) {
    if (widget.readOnly) {
      return;
    }
    if (context.mounted) {
      setState(() {
        _showClearButton = value;
      });
    }
  }

  void _clearTextField() {
    widget.onChanged?.call('');
    setState(() {
      _controller.clear();
    });
  }

  @override
  void dispose() {
    if (widget.isDisposed) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inputStyle =
        widget.inputStyle ?? (widget.maxLines == 1 ? BaladyInputStyle.input : BaladyInputStyle.multiline);
    final fillColor = widget.fillColor ?? widget.background.getFillColor(context);

    final minHeight =
        widget.textFieldHeight < _defaultTextFieldHeight ? widget.textFieldHeight : _defaultTextFieldHeight;

    final defaultTextStyle = context.textStyles.bodyLargeRegular;

    final errorColor = context.colors.errorDefault;
    final BaladyInputAffixBase? prefixParams = widget.prefixConfig;
    BaladyInputAffixBase? suffixParams = widget.suffixConfig ??
        BaladyInputAffixCleanIcon(
          isVisible: _showClearButton,
          onPressed: _clearTextField,
        );
    if (suffixParams is BaladyInputAffixCleanIcon) {
      final suffixAlignment = suffixParams.alignment ?? inputStyle.defaultAlignment;
      suffixParams = suffixParams.copyWith(
        isVisible: _showClearButton,
        alignment: suffixAlignment,
      );
      // Here we rewrite onPressed if the icon came from outside
      if (widget.suffixConfig is BaladyInputAffixCleanIcon) {
        suffixParams = (suffixParams as BaladyInputAffixCleanIcon).copyWith(onPressed: () {
          if ((suffixParams! as BaladyInputAffixCleanIcon).cleanOnPressed) {
            _clearTextField();
          }
          (suffixParams as BaladyInputAffixCleanIcon).onPressed?.call();
        });
      }
    }
    final contentPadding = EdgeInsetsDirectional.only(
      start: prefixParams != null
          ? (prefixParams.widgetWithPadding(inputStyle, BaladyInputAffixType.prefix))
          : Spacing.$4x,
      end: _showClearButton ? (suffixParams.widgetWithPadding(inputStyle, BaladyInputAffixType.prefix)) : Spacing.$4x,
      top: Spacing.$3x,
      bottom: Spacing.$3x,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null && widget.labelText!.isNotEmpty)
          WidgetLabel(
            label: BaladyInputLabel(
              text: widget.labelText!,
              isRequired: widget.isRequired,
              style: widget.labelStyle,
            ),
          ),
        Stack(
          children: [
            TextFormField(
              key: widget.stateKey ?? const Key('BaladyInputField'),
              enabled: widget.enabled,
              controller: _controller,
              focusNode: widget.focusNode,
              autocorrect: widget.autocorrect,
              autofillHints: widget.autofillHints,
              autovalidateMode: widget.autovalidateMode ?? AutovalidateMode.onUserInteraction,
              cursorColor: context.colors.accentDefault,
              showCursor: _showCursor,
              cursorWidth: _cursorWidth,
              autofocus: widget.autofocus ?? false,
              scrollPadding: EdgeInsets.only(
                bottom: MediaQuery.viewInsetsOf(context).bottom + (13.0 * 4.0), //(fontSize * 4.0)
              ),
              inputFormatters: widget.inputFormatters ?? _customInputFormatters,
              keyboardType: widget.keyboardType,
              maxLength: widget.maxLength,
              maxLines: widget.maxLines,
              obscureText: widget.obscureText,
              readOnly: widget.readOnly,
              textAlign: widget.textAlign ?? TextAlign.start,
              textInputAction: widget.textInputAction,
              style: _textStyle(context, inputStyle),
              decoration: InputDecoration(
                constraints: BoxConstraints(
                  minHeight: minHeight,
                  maxWidth: widget.textFieldWidth ?? double.infinity,
                  maxHeight: widget.inputStyle == BaladyInputStyle.search ? widget.textFieldHeight : double.infinity,
                ),
                hintText: widget.hintText,
                hintStyle: (widget.textStyle ?? defaultTextStyle).copyWith(
                  color: widget.hintColor ?? context.colors.foregroundMuted,
                ),
                filled: true,
                fillColor: fillColor,
                contentPadding: contentPadding,
                border: _transparentRoundedBorder,
                focusedErrorBorder:
                    widget.higlighFocusedBorder ? _coloredRoundedBorder(errorColor) : _transparentRoundedBorder,
                disabledBorder: _transparentRoundedBorder,
                enabledBorder: _transparentRoundedBorder,
                focusedBorder: widget.higlighFocusedBorder
                    ? _coloredRoundedBorder(context.colors.accentDefault)
                    : _transparentRoundedBorder,
                errorBorder: _transparentRoundedBorder,
              ),
              onTap: () {
                _controller.selection = TextSelection.fromPosition(
                  TextPosition(
                    offset: _controller.text.length,
                  ),
                );
                widget.onTap?.call();
              },
              onChanged: widget.onChanged,
              onFieldSubmitted: widget.onSubmitted,
              validator: widget.onValidate,
              onTapOutside: widget.onTapOutside,
            ),
            // suffix
            Positioned.fill(
              child: Align(
                alignment: suffixParams.inStackAlignment(BaladyInputAffixType.suffix),
                child: BaladyInputAffix(
                  config: suffixParams,
                  inputStyle: inputStyle,
                  type: BaladyInputAffixType.suffix,
                ),
              ),
            ),
            // prefix
            if (prefixParams != null)
              Positioned.fill(
                child: Align(
                  alignment: prefixParams.inStackAlignment(BaladyInputAffixType.prefix),
                  child: BaladyInputAffix(
                    config: prefixParams,
                    inputStyle: inputStyle,
                    type: BaladyInputAffixType.prefix,
                  ),
                ),
              ),
          ],
        ),
        // supporting text
        Builder(builder: (context) {
          final isError = widget.errorText != null && widget.errorText!.isNotEmpty;
          final isSupportingText = widget.supportingText != null && widget.supportingText!.isNotEmpty;
          final text = isError
              ? widget.errorText!
              : isSupportingText
                  ? widget.supportingText!
                  : null;

          if (text != null) {
            return Padding(
              padding: const EdgeInsets.only(top: Spacing.$2x),
              child: BaladyInputSupportingText(
                controller: _controller,
                isError: isError,
                config: BaladySupportingText(text: text),
              ),
            );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }

  InputBorder? get _transparentRoundedBorder => SmoothRectangleInputBorder(
        smoothness: 0.6,
        side: const BorderSide(
          color: Colors.transparent,
          width: 0,
        ),
        borderRadius: BorderRadius.circular(widget.radiusBorder ?? RadiusBorder.l),
      );

  InputBorder? _coloredRoundedBorder(Color color) => SmoothRectangleInputBorder(
        side: BorderSide(color: color),
        smoothness: .6,
        borderRadius: BorderRadius.circular(widget.radiusBorder ?? RadiusBorder.l),
      );

  List<TextInputFormatter> get _customInputFormatters => [
        if (widget.isDigitsOnly) FilteringTextInputFormatter.digitsOnly,
        if (widget.allowedInputPattern != null) FilteringTextInputFormatter.allow(widget.allowedInputPattern!),
        if (widget.deniedInputPattern != null) FilteringTextInputFormatter.deny(widget.deniedInputPattern!),
      ];

  TextStyle _textStyle(BuildContext context, BaladyInputStyle inputStyle) {
    final baseStyle = widget.textStyle ??
        switch (inputStyle) {
          BaladyInputStyle.input => context.textStyles.bodyLargeRegular,
          BaladyInputStyle.multiline => context.textStyles.bodyLargeRegular,
          BaladyInputStyle.search => context.textStyles.bodySmallRegular,
        };
    final style = baseStyle.copyWith(
      overflow: TextOverflow.ellipsis,
    );

    final defaultColor = widget.textColor ?? context.colors.foregroundDefault;

    if (!widget.enabled) {
      final disabledColor = defaultColor.withOpacity(0.4);
      return style.copyWith(color: disabledColor);
    }
    final errorText = widget.errorText;
    if (errorText != null && errorText.isNotEmpty) {
      final errorColor = context.colors.errorDefault;
      return style.copyWith(color: errorColor);
    }

    return style.copyWith(color: defaultColor);
  }
}
