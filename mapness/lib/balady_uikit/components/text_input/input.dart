import 'package:balady_uikit/balady_uikit.dart' show RadiusBorder, SystemIcons, Spacing;
import 'package:flutter/material.dart';
import 'package:mapness/balady_uikit/components/text_input/input_styles.dart';
import 'package:mapness/balady_uikit/components/text_input/models/input_models.dart';
import 'package:mapness/balady_uikit/components/text_input/widgets/input_widgets.dart';

class BaladyTextInput extends StatefulWidget {
  final BaladyInputState inputState;
  final BaladyInputStyle? inputStyle;
  final TextEditingController? controller;

  final BaladyInputLabel? label;
  final BaladyInputConfig config;
  final BaladyInputAffixBase? prefixConfig;
  final BaladyInputAffixBase? suffixConfig;
  final BaladySupportingText? supportingText;

  const BaladyTextInput({
    required this.config,
    this.inputStyle,
    this.controller,
    this.inputState = BaladyInputState.defaultValue,
    this.label,
    this.prefixConfig,
    this.suffixConfig,
    this.supportingText,
    super.key,
  });

  factory BaladyTextInput.search({
    BaladyInputConfig? config,
    TextEditingController? controller,
    BaladyInputState inputState = BaladyInputState.defaultValue,
    BaladyInputLabel? label,
    BaladySupportingText? supportingText,
    BaladyInputAffixIcon? affixIcon,
  }) =>
      BaladyTextInput(
        config: (config ?? const BaladyInputConfig()).copyWith(
          highlightFocusedBorder: false,
          textFieldHeight: BaladyInputConfig.defaultSearchHeight,
          textInputAction: TextInputAction.search,
          radiusBorder: RadiusBorder.m,
        ),
        controller: controller,
        inputState: inputState,
        label: label,
        prefixConfig: affixIcon ??
            const BaladyInputAffixIcon(
              icon: SystemIcons.search,
            ),
        supportingText: supportingText,
        inputStyle: BaladyInputStyle.search,
      );

  @override
  State<BaladyTextInput> createState() => _BaladyTextInputState();
}

class _BaladyTextInputState extends State<BaladyTextInput> {
  late final TextEditingController _controller;
  bool _showClearButton = false;
  bool _showCursor = true;
  double _cursorWidth = 2.0;
  bool _unfocusedForTruncate = false;

  late BaladyInputStyle inputStyle;
  late BaladyInputAffixBase? prefixParams;
  late BaladyInputAffixBase suffixParams;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController(text: widget.config.initialValue);
    _controller.addListener(() {
      _hideCursorOnArabic(Directionality.of(context) == TextDirection.rtl);
      _setShowClearButton(_controller.text.isNotEmpty);
    });
    widget.config.focusNode?.addListener(_truncateText);
    _setupLayout();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _setupLayout();
  }

  void _setupLayout() {
    inputStyle =
        widget.inputStyle ?? (widget.config.maxLines == 1 ? BaladyInputStyle.input : BaladyInputStyle.multiline);

    prefixParams = widget.prefixConfig;
  }

  void _truncateText() {
    // BSA-1391: We need to truncate text if it is too long. But only for a one line
    // and only when we unfocused
    if (context.mounted) {
      setState(() {
        _unfocusedForTruncate =
            widget.config.maxLines == 1 && widget.config.focusNode != null && !widget.config.focusNode!.hasFocus;
      });
    }
  }

  /// BALADY-708: Hide cursor when typing space in Arabic
  /// This logic is presented in iPhone search input
  void _hideCursorOnArabic(bool isArabic) {
    if (!isArabic) {
      return;
    }
    final text = _controller.text;
    if (text.isEmpty) {
      return;
    }
    final lastChar = text[text.length - 1];
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
    if (widget.inputState.isReadOnly || widget.inputState.isDisabled) {
      return;
    }
    if (context.mounted) {
      setState(() {
        _showClearButton = value;
      });
    }
  }

  void _clearTextField() {
    widget.config.onChanged?.call('');
    setState(() {
      _controller.clear();
    });
  }

  @override
  void dispose() {
    widget.config.focusNode?.removeListener(_truncateText);
    if (widget.config.isDisposed) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final contentPadding = EdgeInsetsDirectional.only(
      start: prefixParams != null
          ? (prefixParams!.widgetWithPadding(inputStyle, BaladyInputAffixType.prefix))
          : Spacing.$4x,
      end: _showClearButton ? (suffixParams.widgetWithPadding(inputStyle, BaladyInputAffixType.suffix)) : Spacing.$4x,
      top: Spacing.$2x,
      bottom: Spacing.$2x,
    );
    suffixParams = widget.suffixConfig ??
        BaladyInputAffixCleanIcon(
          isVisible: _showClearButton,
          onPressed: _clearTextField,
        );
    if (suffixParams is BaladyInputAffixCleanIcon) {
      final suffixAlignment = suffixParams.alignment ?? inputStyle.defaultAlignment;
      suffixParams = (suffixParams as BaladyInputAffixCleanIcon).copyWith(
        isVisible: _showClearButton,
        alignment: suffixAlignment,
      );
      // Here we rewrite onPressed if the icon came from outside
      if (widget.suffixConfig is BaladyInputAffixCleanIcon && suffixParams is BaladyInputAffixCleanIcon) {
        final _suffixParams = suffixParams as BaladyInputAffixCleanIcon;
        suffixParams = _suffixParams.copyWith(
          onPressed: () {
            if (_suffixParams.cleanOnPressed) {
              _clearTextField();
            }
            _suffixParams.onPressed?.call();
          },
        );
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) WidgetLabel(label: widget.label!),
        Stack(
          children: [
            // input
            BaladyTextField(
              config: widget.config,
              controller: _controller,
              showCursor: _showCursor,
              cursorWidth: _cursorWidth,
              contentPadding: contentPadding,
              inputStyle: inputStyle,
              inputState: widget.inputState,
              truncateText: _unfocusedForTruncate,
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
                  alignment: prefixParams!.inStackAlignment(BaladyInputAffixType.prefix),
                  child: BaladyInputAffix(
                    config: prefixParams!,
                    inputStyle: inputStyle,
                    type: BaladyInputAffixType.prefix,
                  ),
                ),
              ),
          ],
        ),
        // supporting text
        if (widget.supportingText != null)
          BaladyInputSupportingText(
            controller: _controller,
            config: widget.supportingText!,
            isError: widget.inputState.isError,
          ),
      ],
    );
  }
}
