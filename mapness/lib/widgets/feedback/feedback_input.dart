import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/entities/feedback/fields_entity/feedback_text_type_entity.dart';
import 'package:mapness/shared/utils/text_utils/phone_number_formatter.dart';

/// A stateless widget that provides a customizable text input field for feedback purposes.
///
/// The widget also applies input formatters based on the [type] parameter.
/// If the [type] is [FeedbackTextType.phone] it applies the [PhoneNumberFormatter] to format the input as a phone number
/// And handle onChanged with formatt input value as pure phone number.

class FeedbackTextInput extends StatefulWidget {
  const FeedbackTextInput({
    required this.labelText,
    required this.hintText,
    required this.isRequired,
    required this.type,
    this.maxLength,
    this.maxLines = 1,
    this.controller,
    this.allowedInputPattern,
    this.keyboardType,
    this.onChanged,
    this.errorText,
    this.focusNode,
    this.onTap,
    this.readonly = false,
    super.key,
  });

  final String hintText;
  final String? labelText;
  final Pattern? allowedInputPattern;
  final bool isRequired;
  final int? maxLength;
  final int? maxLines;
  final FeedbackTextType type;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final String? errorText;
  final FocusNode? focusNode;
  final VoidCallback? onTap;
  final bool readonly;

  @override
  State<FeedbackTextInput> createState() => _FeedbackTextInputState();
}

class _FeedbackTextInputState extends State<FeedbackTextInput> {
  late final TextEditingController _controller;

  BaladyInputState _inputErrorState = BaladyInputState.defaultValue;
  var _isForceLtr = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();

    _controller.addListener(_controllerListener);

    widget.focusNode?.addListener(() {
      if (widget.focusNode?.hasFocus == true && mounted) {
        setState(() {
          _inputErrorState = BaladyInputState.defaultValue;
        });
      }
    });
  }

  @override
  void didUpdateWidget(covariant FeedbackTextInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller?.text != _controller.text) {
      _controller.text = widget.controller?.text ?? '';
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_controllerListener);
    super.dispose();
  }

  void _controllerListener() {
    // This is a hack, because the phone number formatter doesn't work well with the text direction

    if (widget.type == FeedbackTextType.phone) {
      final isTextNotEmpty = _controller.text.isNotEmpty;
      if (_isForceLtr != isTextNotEmpty) {
        setState(() {
          _isForceLtr = isTextNotEmpty;
        });
      }
    }
  }

  void _onChanged(String value) {
    var formattedValue = value;
    if (widget.type == FeedbackTextType.phone) {
      formattedValue = PhoneNumberFormatter.formatPure(formattedValue);
    }
    widget.onChanged?.call(formattedValue);
  }

  @override
  Widget build(BuildContext context) {
    final srcDirection = Directionality.of(context);
    // we need to force the text direction to ltr when the input is a phone number
    final direction = _isForceLtr ? TextDirection.ltr : srcDirection;
    // in arabic phone texted ltr but should be aligned to right edge as other fields
    final textAlign = _isForceLtr && srcDirection == TextDirection.rtl ? TextAlign.end : null;

    final bool hasNoFocusWithError = widget.focusNode?.hasFocus == false && widget.errorText != null;
    final bool exceedsMaxLength = widget.maxLength != null && _controller.text.length > widget.maxLength!;

    _inputErrorState = (hasNoFocusWithError || exceedsMaxLength)
        ? BaladyInputState.error
        : BaladyInputState.defaultValue;

    final separateLabelForPhone = widget.type == FeedbackTextType.phone && widget.labelText != null;
    final inputWidget = Directionality(
      textDirection: direction,
      child: BaladyTextInput(
        label: separateLabelForPhone
            ? null
            : (widget.labelText != null
                  ? BaladyInputLabel(
                      text: widget.labelText!,
                      isRequired: widget.isRequired,
                      style: context.textStyles.captionMediumRegular
                          .copyWith(
                            color: context.colors.foregroundDefault,
                          )
                          .apply(
                            fontSizeFactor: MediaQuery.of(context).textScaleFactor,
                          ),
                    )
                  : null),
        inputState: widget.readonly ? BaladyInputState.readOnly : _inputErrorState,
        controller: _controller,
        config: BaladyInputConfig(
          isDisposed: false,
          textAlign: textAlign,
          focusNode: widget.focusNode,
          hintText: widget.hintText,
          background: BaladyInputBackground.color,
          fillColor: context.colors.neutralContainerDefault,
          autovalidateMode: AutovalidateMode.onUnfocus,
          allowedInputPattern: widget.allowedInputPattern,
          maxLines: widget.maxLines,
          keyboardType: widget.keyboardType,
          onChanged: _onChanged,
          onTap: widget.onTap,
          inputFormatters: [if (widget.type == FeedbackTextType.phone) const PhoneNumberFormatter()],
        ),
        suffixConfig: widget.type == FeedbackTextType.phone
            ? const BaladyInputAffixWidget(widget: SizedBox.shrink(), width: 0)
            : null,
        supportingText: widget.maxLength != null
            ? BaladySupportingText(text: _inputErrorState == BaladyInputState.defaultValue ? null : widget.errorText)
            : null,
      ),
    );

    if (!separateLabelForPhone) {
      return inputWidget;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PhoneLabelWidget(labelText: widget.labelText!, isRequired: widget.isRequired),
        inputWidget,
      ],
    );
  }
}

class _PhoneLabelWidget extends StatelessWidget {
  const _PhoneLabelWidget({required this.labelText, required this.isRequired});

  final String labelText;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    final defaultStyle = context.textStyles.captionMediumRegular.copyWith(color: context.colors.foregroundDefault);
    return Row(
      children: [
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(bottom: Spacing.$2x),
            child: RichText(
              text: TextSpan(
                text: labelText,
                style: defaultStyle,
                children: [
                  if (isRequired)
                    TextSpan(
                      text: '*',
                      style: defaultStyle.copyWith(color: context.colors.errorDefault),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
