import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/widget_label.dart';
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
    required this.maxLength,
    required this.type,
    this.maxLines = 1,
    this.controller,
    this.allowedInputPattern,
    this.keyboardType,
    this.onChanged,
    this.errorText,
    super.key,
  });

  final String hintText;
  final String? labelText;
  final Pattern? allowedInputPattern;
  final bool isRequired;
  final int maxLength;
  final int maxLines;
  final FeedbackTextType type;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final String? errorText;

  @override
  State<FeedbackTextInput> createState() => _FeedbackTextInputState();
}

class _FeedbackTextInputState extends State<FeedbackTextInput> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  // TODO(ilyasov): Temporary fix, need to remove it after implementing custom form field
  final _globalKey = GlobalKey<FormFieldState<String>>();

  final _inputErrorState = ValueNotifier<bool>(false);
  var _isForceLtr = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();

    _focusNode = FocusNode();

    _controller.addListener(_controllerListener);
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
    _inputErrorState.dispose();
    _focusNode.dispose();
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
    if (_globalKey.currentState?.hasError ?? false) {
      _globalKey.currentState?.validate();
    }
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

    final inputState = widget.errorText != null || (_controller.text.length > widget.maxLength)
        ? BaladyInputState.error
        : BaladyInputState.defaultValue;

    return Column(
      children: [
        Row(
          children: [
            Flexible(
              child: WidgetLabel(
                isRequired: widget.isRequired,
                label: widget.labelText,
                labelStyle: context.textStyleV3.captionMediumRegular.copyWith(
                  color: context.colorsV2.foregroundDefault,
                ),
              ),
            ),
          ],
        ),
        Directionality(
          textDirection: direction,
          child: BaladyTextInput(
            inputState: inputState,
            controller: _controller,
            config: BaladyInputConfig(
              isDisposed: false,
              textAlign: textAlign,
              stateKey: _globalKey,
              focusNode: _focusNode,
              hintText: widget.hintText,
              fillColor: context.colorsV2.backgroundSurface1,
              autovalidateMode: AutovalidateMode.onUnfocus,
              allowedInputPattern: widget.allowedInputPattern,
              maxLines: widget.maxLines,
              keyboardType: widget.keyboardType,
              onChanged: _onChanged,
              inputFormatters: [
                if (widget.type == FeedbackTextType.phone) const PhoneNumberFormatter(),
              ],
            ),
            suffixConfig: widget.type == FeedbackTextType.phone
                ? const BaladyInputAffixWidget(widget: SizedBox.shrink(), width: 0)
                : null,
            supportingText: BaladySupportingText(
              maxLength: widget.maxLength,
              text: widget.errorText,
            ),
          ),
        ),
      ],
    );
  }
}
