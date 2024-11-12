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
  late final _inputKeys = List<UniqueKey>.generate(_inputs.length, (i) => UniqueKey());

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
      _inputKeys.add(UniqueKey());
    });
  }

  void _removeInput(int i) {
    setState(() {
      _inputs.removeAt(i);
      _inputKeys.removeAt(i);
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

  bool _isValid(String? value) {
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
    return validator(value) == null;
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
        valueTransformer: (values) {
          if (values == null) {
            return [];
          }

          return values
              .where(
                (value) => value.trim().isNotEmpty,
              )
              .toList();
        },
        validator: (values) {
          if (_isRequired && values == null) {
            return FormBuilderValidators.required()(values);
          }

          for (final value in values ?? []) {
            if (!_isValid(value)) {
              return 'Wrong field';
            }
          }

          return null;
        },
        builder: (fieldState) => Column(
              children: [
                for (var i = 0; i < _inputs.length; i++) ...[
                  Row(
                    key: _inputKeys[i],
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: FeedbackTextInput(
                          labelText: i == 0 ? widget.field.label : null,
                          hintText: widget.field.hint,
                          onValidate: (v) => _isValid(v) ? null : context.l10n.feedbackTextFieldWrongFormat,
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
                      ),
                      if (i != 0)
                        Padding(
                          padding: const EdgeInsetsDirectional.only(start: Spacing.$2x),
                          child: AppButton.close(
                            onTap: () {
                              _removeInput(i);
                              fieldState.didChange(_inputs);
                            },
                            buttonColorScheme: ButtonColorScheme.onColor,
                            padding: EdgeInsets.zero,
                            size: ButtonSize.medium,
                          ),
                        ),
                    ],
                  ),
                  Spacing.$2x.heightBox,
                ],
                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    buttonColorScheme: ButtonColorScheme.secondary,
                    primaryLabel: isPhoneField ? context.l10n.addPhoneNumber : context.l10n.add,
                    primaryIcon: isPhoneField ? null : GeneralIcons.plusCircle,
                    onTap: () {
                      _addInput();
                      fieldState.didChange(_inputs);
                    },
                  ),
                ),
              ],
            ));
  }
}
