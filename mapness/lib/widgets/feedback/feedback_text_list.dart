import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:mapness/entities/feedback/feedback_base_entity.dart';
import 'package:mapness/entities/feedback/fields_entity/feedback_text_type_entity.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/utils/text_utils/phone_number_formatter.dart';
import 'package:mapness/widgets/feedback/feedback_input.dart';

class FeedbackTextListField extends StatefulWidget {
  final FeedbackTextListEntity field;

  const FeedbackTextListField({
    required this.field,
    super.key,
  });

  @override
  State<FeedbackTextListField> createState() => _FeedbackTextListFieldState();
}

class _FeedbackTextListFieldState extends State<FeedbackTextListField> {
  late final _inputs = List<String>.of(widget.field.oldValues);

  late final _isRequired = widget.field.isRequired;

  @override
  void initState() {
    super.initState();
    if (_inputs.isEmpty) {
      _addInput();
    }
  }

  void _addInput() {
    setState(() {
      _inputs.add('');
    });
  }

  void _updateInput(int i, String text) {
    var formattedValue = text;
    if (widget.field.type == FeedbackTextType.phone) {
      formattedValue = PhoneNumberFormatter.formatPure(text);
    }
    setState(() {
      _inputs[i] = formattedValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isPhoneField = widget.field.type == FeedbackTextType.phone;
    final keyboardType = switch (widget.field.type) {
      FeedbackTextType.phone => TextInputType.phone,
      FeedbackTextType.url => TextInputType.url,
      _ => TextInputType.text,
    };
    final allowedInputPattern = switch (widget.field.type) {
      FeedbackTextType.email => RegExp(r'[a-zA-Z0-9\._+\-@]'),
      FeedbackTextType.url => RegExp(r'[a-zA-Z0-9./:?_\-]'),
      _ => null,
    };

    return FormBuilderField<List<String>>(
        name: widget.field.id,
        validator: (values) {
          if (_isRequired && values == null) {
            return FormBuilderValidators.required()(values);
          }
          final validator = switch (widget.field.type) {
            FeedbackTextType.email => FormBuilderValidators.email(checkNullOrEmpty: _isRequired),
            FeedbackTextType.phone => FormBuilderValidators.compose([
                FormBuilderValidators.phoneNumber(checkNullOrEmpty: _isRequired),
                FormBuilderValidators.minLength(
                  PhoneNumberFormatter.arabicPhoneNumberMinLength,
                  checkNullOrEmpty: _isRequired,
                ),
              ]),
            FeedbackTextType.url => FormBuilderValidators.url(checkNullOrEmpty: _isRequired),
            _ when _isRequired => FormBuilderValidators.required(),
            _ => (_) => null,
          };

          for (final value in values ?? []) {
            if (validator(value) != null) {
              return validator(value);
            }
          }

          return null;
        },
        builder: (fieldState) => Column(
              children: [
                for (var i = 0; i < _inputs.length; i++) ...[
                  FeedbackTextInput(
                    labelText: i == 0 ? widget.field.label : null,
                    hintText: widget.field.hint,
                    onValidate: (_) => fieldState.isValid ? null : context.l10n.feedbackTextFieldWrongFormat,
                    allowedInputPattern: allowedInputPattern,
                    isRequired: widget.field.isRequired,
                    maxLength: widget.field.maxLength,
                    keyboardType: keyboardType,
                    onChanged: (value) {
                      _updateInput(i, value);
                      fieldState.didChange(_inputs);
                    },
                    type: widget.field.type,
                  ),
                  Spacing.$2x.heightBox,
                ],
                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    buttonColorScheme: ButtonColorScheme.secondary,
                    primaryLabel: isPhoneField ? context.l10n.addPhoneNumber : context.l10n.add,
                    primaryIcon: isPhoneField ? null : GeneralIcons.plusCircle,
                    onTap: _addInput,
                  ),
                ),
              ],
            ));
  }
}
