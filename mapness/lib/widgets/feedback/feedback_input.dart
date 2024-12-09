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
    this.onValidate,
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
  final FormFieldValidator<String>? onValidate;

  @override
  State<FeedbackTextInput> createState() => _FeedbackTextInputState();
}

class _FeedbackTextInputState extends State<FeedbackTextInput> {
  late final TextEditingController _controller;
  bool _isForceLtr = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();

    _controller.addListener(() {
      // This is a hack, because the phone number formatter doesn't work well with the text direction

      if (widget.type == FeedbackTextType.phone) {
        final isTextNotEmpty = _controller.text.isNotEmpty;
        if (_isForceLtr != isTextNotEmpty) {
          setState(() {
            _isForceLtr = isTextNotEmpty;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // we need to force the text direction to ltr when the input is a phone number
    final direction = _isForceLtr ? TextDirection.ltr : Directionality.of(context);
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
          child: BaladyInput(
            controller: _controller,
            hintText: widget.hintText,
            fillColor: context.colorsV2.backgroundSurface1,
            onValidate: widget.onValidate,
            allowedInputPattern: widget.allowedInputPattern,
            isRequired: widget.isRequired,
            maxLength: widget.maxLength,
            maxLines: widget.maxLines,
            keyboardType: widget.keyboardType,
            suffixIcon: widget.type == FeedbackTextType.phone ? const SizedBox.shrink() : null,
            onChanged: (value) {
              var formattedValue = value;
              if (widget.type == FeedbackTextType.phone) {
                formattedValue = PhoneNumberFormatter.formatPure(formattedValue);
              }
              widget.onChanged?.call(formattedValue);
            },
            inputFormatters: [
              if (widget.type == FeedbackTextType.phone) const PhoneNumberFormatter(),
            ],
          ),
        ),
      ],
    );
  }
}
